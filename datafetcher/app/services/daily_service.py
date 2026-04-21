"""
Last Updated: 2026-04-21
最后更新: 2026-04-21

Module: Daily stock service - source fallback, normalization, and history truncation.
模块: 日线服务 - 数据源降级、标准化和历史截断处理。

Dependencies: app.providers.aktools_client, app.models
依赖: app.providers.aktools_client, app.models

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime
from time import sleep
from typing import Any

from app.models import DailyBar, DailyResponse
from app.providers.aktools_client import AktoolsClient, rolling_window_for_trading
from app.providers.canghai_client import CanghaiClient

MANUAL_NAME_TO_SYMBOL = {
    "贵州茅台": "600519",
    "茅台": "600519",
    "kweichowmoutai": "600519",
}
MANUAL_SYMBOL_TO_NAME = {
    "600519": "贵州茅台",
}


@dataclass(frozen=True)
class StockIdentity:
    """Resolved stock identity used by downstream daily fetch.
    下游日线拉取使用的股票标识信息。
    """

    six_digit_symbol: str
    prefixed_symbol: str
    stock_name: str | None = None


class StockIdentityResolver:
    """Resolves user input into stock code + name mapping.
    将用户输入解析为股票代码与名称映射。
    """

    def __init__(self, client: AktoolsClient) -> None:
        self._client = client
        self._symbol_to_name: dict[str, str] = {}
        self._name_to_symbol: dict[str, str] = {}

    def resolve(self, user_input: str) -> StockIdentity:
        """Resolves input text (symbol or stock name) into stock identity.
        将输入文本（代码或名称）解析为统一股票标识。
        """
        normalized_input = user_input.strip()
        if not normalized_input:
            raise ValueError("symbol must not be empty")

        try:
            six_digit_symbol = normalize_six_digit_symbol(normalized_input)
            prefixed_symbol = normalize_market_prefixed_symbol(normalized_input)
            return StockIdentity(
                six_digit_symbol=six_digit_symbol,
                prefixed_symbol=prefixed_symbol,
                stock_name=self._lookup_stock_name(six_digit_symbol),
            )
        except ValueError:
            pass

        six_digit_symbol = self._resolve_symbol_from_name(normalized_input)
        return StockIdentity(
            six_digit_symbol=six_digit_symbol,
            prefixed_symbol=normalize_market_prefixed_symbol(six_digit_symbol),
            stock_name=normalized_input,
        )

    def _lookup_stock_name(self, six_digit_symbol: str) -> str | None:
        """Best-effort lookup from code to stock name.
        尝试从股票代码反查名称（失败不阻断主流程）。
        """
        try:
            self._ensure_name_symbol_cache()
        except RuntimeError:
            return MANUAL_SYMBOL_TO_NAME.get(six_digit_symbol)
        return self._symbol_to_name.get(six_digit_symbol) or MANUAL_SYMBOL_TO_NAME.get(six_digit_symbol)

    def _resolve_symbol_from_name(self, stock_name: str) -> str:
        """Resolves exact stock name to six-digit symbol.
        将股票名称精确解析为 6 位股票代码。
        """
        normalized_name = normalize_stock_name(stock_name)
        try:
            self._ensure_name_symbol_cache()
        except RuntimeError:
            matched_symbol = None
        else:
            matched_symbol = self._name_to_symbol.get(normalized_name)
        matched_symbol = matched_symbol or MANUAL_NAME_TO_SYMBOL.get(normalized_name)
        if not matched_symbol:
            raise ValueError(f"unknown stock name: {stock_name}")
        return matched_symbol

    def _ensure_name_symbol_cache(self) -> None:
        """Loads code-name mapping once with endpoint fallback.
        通过端点降级一次性加载代码-名称映射缓存。
        """
        if self._symbol_to_name:
            return

        load_errors: list[str] = []
        fetchers: list[tuple[str, Any]] = [
            ("fetch_spot_code_name_rows", getattr(self._client, "fetch_spot_code_name_rows", None)),
            ("fetch_basic_code_name_rows", getattr(self._client, "fetch_basic_code_name_rows", None)),
            ("fetch_local_akshare_code_name_rows", fetch_local_akshare_code_name_rows),
        ]
        for fetcher_name, fetcher in fetchers:
            if not callable(fetcher):
                load_errors.append(f"{fetcher_name}: not implemented")
                continue
            try:
                rows = fetcher()
                self._build_cache_from_rows(rows)
                if self._symbol_to_name:
                    return
                load_errors.append(f"{fetcher_name}: empty mapping")
            except Exception as exc:  # intentionally broad for resilient fallback
                load_errors.append(f"{fetcher_name}: {exc}")

        raise RuntimeError("code-name mapping load failed; " + "; ".join(load_errors))

    def _build_cache_from_rows(self, rows: list[dict[str, Any]]) -> None:
        """Builds code-name cache from upstream rows.
        从上游行数据构建代码-名称缓存。
        """
        for row in rows:
            pair = extract_symbol_name_pair(row)
            if not pair:
                continue
            symbol, stock_name = pair
            self._symbol_to_name[symbol] = stock_name
            normalized_name = normalize_stock_name(stock_name)
            # Keep first insertion deterministic to avoid accidental overwrite.
            # 保留首次写入，避免同名覆盖导致不稳定映射。
            self._name_to_symbol.setdefault(normalized_name, symbol)


class DailyService:
    """Handles end-to-end daily data retrieval from upstream sources.
    负责日线数据的端到端获取与处理。
    """

    def __init__(
        self,
        client: AktoolsClient,
        canghai_client: CanghaiClient | None = None,
        identity_resolver: StockIdentityResolver | None = None,
    ) -> None:
        self._client = client
        # Separate client for Canghai (Tsanghi) fallback source.
        # 单独的沧海数据客户端，用作第三层数据源降级。
        self._canghai_client = canghai_client or CanghaiClient()
        # Resolver isolates code-name matching from daily fetching workflow.
        # 解析器将「代码-名称匹配」职责从日线拉取流程中分离。
        self._identity_resolver = identity_resolver or StockIdentityResolver(client=client)

    def get_latest_daily(self, symbol: str, limit: int) -> DailyResponse:
        """Fetches and returns normalized latest bars with fallback.
        通过降级策略获取并返回标准化后的最近日线数据。
        """
        target = self._identity_resolver.resolve(symbol)
        lookback_days = estimate_calendar_days_for_limit(limit=limit)
        start_date, end_date = rolling_window_for_trading(days=lookback_days)
        normalized_rows, source_used = self._fetch_daily_rows_with_fallback(
            target=target,
            start_date=start_date,
            end_date=end_date,
        )

        normalized_rows = sorted(normalized_rows, key=lambda item: item.date)
        trimmed_rows = normalized_rows[-limit:]

        return DailyResponse(
            symbol=target.six_digit_symbol,
            stock_name=target.stock_name,
            requested_limit=limit,
            actual_count=len(trimmed_rows),
            insufficient_history=len(trimmed_rows) < limit,
            source_used=source_used,
            data=trimmed_rows,
        )

    def _fetch_daily_rows_with_fallback(
        self,
        target: StockIdentity,
        start_date: str,
        end_date: str,
    ) -> tuple[list[DailyBar], str]:
        """Fetches normalized rows from layered upstream sources.
        通过分层上游源降级拉取标准化后的日线数据。
        """
        primary_error: str | None = None
        secondary_error: str | None = None
        tertiary_error: str | None = None
        quaternary_error: str | None = None
        normalized_rows: list[DailyBar] = []
        source_used = ""

        try:
            primary_rows = self._client.fetch_hist_daily(
                symbol=target.six_digit_symbol,
                start_date=start_date,
                end_date=end_date,
            )
            normalized_rows = normalize_hist_rows(primary_rows)
            source_used = "eastmoney:stock_zh_a_hist"
        except Exception as exc:  # intentionally broad for resilient fallback
            primary_error = str(exc)

        if not normalized_rows:
            try:
                secondary_rows = self._client.fetch_sina_daily(
                    symbol=target.prefixed_symbol,
                    start_date=start_date,
                    end_date=end_date,
                )
                normalized_rows = normalize_sina_rows(secondary_rows)
                source_used = "sina:stock_zh_a_daily"
            except Exception as exc:  # intentionally broad for resilient fallback
                secondary_error = str(exc)

        if not normalized_rows:
            try:
                tertiary_rows = fetch_local_akshare_hist_rows(
                    symbol=target.six_digit_symbol,
                    start_date=start_date,
                    end_date=end_date,
                )
                normalized_rows = normalize_hist_rows(tertiary_rows)
                source_used = "local_akshare:stock_zh_a_hist"
            except Exception as exc:  # intentionally broad for resilient fallback
                tertiary_error = str(exc)

        if not normalized_rows:
            try:
                tertiary_rows = self._canghai_client.fetch_canghai_daily(
                    exchange_code=to_tsanghi_exchange_code(target.prefixed_symbol),
                    ticker=target.six_digit_symbol,
                    start_date=to_iso_yyyy_mm_dd(start_date),
                    end_date=to_iso_yyyy_mm_dd(end_date),
                )
                normalized_rows = normalize_canghai_rows(tertiary_rows)
                source_used = "canghai:stock_daily"
            except Exception as exc:  # intentionally broad for resilient fallback
                quaternary_error = str(exc)

        if not normalized_rows:
            raise RuntimeError(
                "All upstream sources failed. "
                f"symbol={target.six_digit_symbol}; "
                f"primary_error={primary_error}; secondary_error={secondary_error}; "
                f"tertiary_error={tertiary_error}; quaternary_error={quaternary_error}"
            )

        return normalized_rows, source_used


def normalize_six_digit_symbol(symbol: str) -> str:
    """Normalizes symbol to six-digit form.
    将股票代码标准化为 6 位形式。
    """
    cleaned = symbol.strip().lower()
    if cleaned.startswith(("sh", "sz", "bj")):
        cleaned = cleaned[2:]
    if len(cleaned) != 6 or not cleaned.isdigit():
        raise ValueError("symbol must be 6 digits like 600000")
    return cleaned


def normalize_market_prefixed_symbol(symbol: str) -> str:
    """Normalizes symbol to market-prefixed form for Sina API.
    将股票代码标准化为新浪接口所需市场前缀形式。
    """
    cleaned = symbol.strip().lower()
    if cleaned.startswith(("sh", "sz", "bj")):
        return cleaned
    if len(cleaned) != 6 or not cleaned.isdigit():
        raise ValueError("symbol must be 6 digits like 600000")
    if cleaned.startswith(("5", "6", "9")):
        return f"sh{cleaned}"
    if cleaned.startswith(("4", "8")):
        return f"bj{cleaned}"
    return f"sz{cleaned}"


def normalize_stock_name(stock_name: str) -> str:
    """Normalizes stock name for lookup matching.
    将股票名称标准化后用于匹配检索。
    """
    return "".join(stock_name.strip().lower().split())


def extract_symbol_name_pair(row: dict[str, Any]) -> tuple[str, str] | None:
    """Extracts (symbol, stock_name) pair from upstream row.
    从上游行数据中提取 (股票代码, 股票名称)。
    """
    symbol_keys = ("代码", "symbol", "code", "证券代码", "股票代码")
    name_keys = ("名称", "name", "证券简称", "股票简称")

    symbol_text = _first_string_value(row=row, candidate_keys=symbol_keys)
    stock_name = _first_string_value(row=row, candidate_keys=name_keys)
    if not symbol_text or not stock_name:
        return None

    try:
        six_digit_symbol = normalize_six_digit_symbol(symbol_text)
    except ValueError:
        return None
    return six_digit_symbol, stock_name.strip()


def _first_string_value(row: dict[str, Any], candidate_keys: tuple[str, ...]) -> str | None:
    """Finds first non-empty string-like value by key preference.
    按候选键优先级读取首个非空字符串值。
    """
    for key in candidate_keys:
        value = row.get(key)
        if value is None:
            continue
        text = str(value).strip()
        if text:
            return text
    return None


def estimate_calendar_days_for_limit(limit: int) -> int:
    """Estimates calendar window for requested trading bars.
    估算满足请求交易日条数所需的自然日窗口。
    """
    if limit <= 0:
        raise ValueError("limit must be positive")
    return max(420, limit * 4)


def fetch_local_akshare_code_name_rows() -> list[dict[str, Any]]:
    """Fetches code-name list directly from local akshare package.
    通过本地 akshare 包直接拉取股票代码-名称列表。
    """
    try:
        import akshare as ak  # type: ignore
    except ImportError as exc:
        raise RuntimeError("akshare not installed for local fallback") from exc

    frame = _retry_akshare_request(lambda: ak.stock_info_a_code_name(), request_name="stock_info_a_code_name")
    return dataframe_to_rows(frame)


def fetch_local_akshare_hist_rows(symbol: str, start_date: str, end_date: str) -> list[dict[str, Any]]:
    """Fetches Eastmoney-style daily rows via local akshare.
    通过本地 akshare 拉取东财样式日线行数据。
    """
    try:
        import akshare as ak  # type: ignore
    except ImportError as exc:
        raise RuntimeError("akshare not installed for local fallback") from exc

    frame = _retry_akshare_request(
        lambda: ak.stock_zh_a_hist(
            symbol=symbol,
            period="daily",
            start_date=start_date,
            end_date=end_date,
            adjust="",
        ),
        request_name=f"stock_zh_a_hist:{symbol}",
    )
    return dataframe_to_rows(frame)


def _retry_akshare_request(fetch_fn: Any, request_name: str, max_attempts: int = 8) -> Any:
    """Retries flaky akshare network calls before failing.
    针对不稳定的 akshare 网络请求进行重试。
    """
    last_error: Exception | None = None
    for attempt in range(1, max_attempts + 1):
        try:
            return fetch_fn()
        except Exception as exc:  # intentionally broad for resilient fallback
            last_error = exc
            if attempt == max_attempts:
                break
            sleep(0.6 * attempt)
    raise RuntimeError(f"akshare request failed after {max_attempts} attempts: {request_name}; {last_error}")


def dataframe_to_rows(frame: Any) -> list[dict[str, Any]]:
    """Converts pandas DataFrame to list rows with empty-frame guard.
    将 pandas DataFrame 转换为行字典列表，并处理空表场景。
    """
    if frame is None:
        return []
    if hasattr(frame, "empty") and frame.empty:
        return []
    if not hasattr(frame, "to_dict"):
        raise RuntimeError(f"unexpected frame type from akshare: {type(frame)}")
    rows = frame.to_dict(orient="records")
    if not isinstance(rows, list):
        raise RuntimeError(f"unexpected rows type from akshare frame: {type(rows)}")
    return rows


def normalize_hist_rows(rows: list[dict[str, Any]]) -> list[DailyBar]:
    """Maps Eastmoney row keys into DailyBar.
    将东方财富字段映射为 DailyBar。
    """
    return [
        DailyBar(
            date=to_iso_date(require_field(row, "日期")),
            open=to_float(require_field(row, "开盘")),
            high=to_float(require_field(row, "最高")),
            low=to_float(require_field(row, "最低")),
            close=to_float(require_field(row, "收盘")),
            volume=to_float(require_field(row, "成交量")),
            amount=to_float_or_none(row.get("成交额")),
        )
        for row in rows
    ]


def normalize_sina_rows(rows: list[dict[str, Any]]) -> list[DailyBar]:
    """Maps Sina row keys into DailyBar.
    将新浪字段映射为 DailyBar。
    """
    return [
        DailyBar(
            date=to_iso_date(require_field(row, "date")),
            open=to_float(require_field(row, "open")),
            high=to_float(require_field(row, "high")),
            low=to_float(require_field(row, "low")),
            close=to_float(require_field(row, "close")),
            volume=to_float(require_field(row, "volume")),
            amount=to_float_or_none(row.get("amount")),
        )
        for row in rows
    ]


def normalize_canghai_rows(rows: list[dict[str, Any]]) -> list[DailyBar]:
    """Maps Canghai row keys into DailyBar.
    将沧海数据字段映射为 DailyBar。
    """
    return [
        DailyBar(
            date=to_iso_date(require_field(row, "date")),
            open=to_float(require_field(row, "open")),
            high=to_float(require_field(row, "high")),
            low=to_float(require_field(row, "low")),
            close=to_float(require_field(row, "close")),
            volume=to_float(require_field(row, "volume")),
            amount=None,
        )
        for row in rows
    ]


def require_field(row: dict[str, Any], field_name: str) -> Any:
    """Gets required field from row.
    从行数据中获取必填字段。
    """
    if field_name not in row:
        raise RuntimeError(f"Missing field '{field_name}' in upstream payload")
    return row[field_name]


def to_float(value: Any) -> float:
    """Converts value to float.
    将数值转换为浮点数。
    """
    return float(value)


def to_float_or_none(value: Any) -> float | None:
    """Converts optional value to float.
    将可选数值转换为浮点数。
    """
    if value is None or value == "":
        return None
    return float(value)


def to_iso_date(value: Any) -> str:
    """Converts date representations to YYYY-MM-DD.
    将日期表示统一转换为 YYYY-MM-DD。
    """
    if isinstance(value, datetime):
        return value.date().isoformat()
    if isinstance(value, date):
        return value.isoformat()
    if not isinstance(value, str):
        raise RuntimeError(f"Unsupported date value type: {type(value)}")
    text = value.strip()
    if "T" in text:
        return text.split("T", maxsplit=1)[0]
    if len(text) == 8 and text.isdigit():
        return f"{text[:4]}-{text[4:6]}-{text[6:8]}"
    return text


def to_iso_yyyy_mm_dd(compact: str) -> str:
    """Converts YYYYMMDD string into YYYY-MM-DD.
    将紧凑的 YYYYMMDD 字符串转换为 YYYY-MM-DD。
    """
    if len(compact) != 8 or not compact.isdigit():
        raise ValueError(f"invalid compact date: {compact}")
    return f"{compact[:4]}-{compact[4:6]}-{compact[6:8]}"


def to_tsanghi_exchange_code(prefixed_symbol: str) -> str:
    """Maps market-prefixed symbol into Tsanghi exchange code.
    将带市场前缀的股票代码转换为沧海使用的交易所代码。

    Currently supports all China-related exchanges listed in Tsanghi docs:
    目前支持沧海文档中列出的所有中国相关交易所：
    - XSHG: Shanghai Stock Exchange (A shares, codes not starting with 9)
    - XSHGB: Shanghai B shares (codes starting with 9)
    - XSHE: Shenzhen Stock Exchange (A shares, codes not starting with 2)
    - XSHEB: Shenzhen B shares (codes starting with 2)
    - BJSE: Beijing Stock Exchange
    """
    text = prefixed_symbol.strip().lower()
    if text.startswith("sh"):
        # SH B shares use 900xxx and map to XSHGB.
        # 上海 B 股使用 900xxx 代码段，在沧海映射为 XSHGB。
        code = text[2:]
        if len(code) == 6 and code.startswith("9"):
            return "XSHGB"
        return "XSHG"
    if text.startswith("sz"):
        # SZ B shares use 200xxx and map to XSHEB.
        # 深圳 B 股使用 200xxx 代码段，在沧海映射为 XSHEB。
        code = text[2:]
        if len(code) == 6 and code.startswith("2"):
            return "XSHEB"
        return "XSHE"
    if text.startswith("bj"):
        # Beijing Stock Exchange, mapped to BJSE per official docs.
        # 北京证券交易所，根据官方文档映射为 BJSE。
        return "BJSE"
    raise ValueError(f"unsupported exchange for Canghai source: {prefixed_symbol}")
