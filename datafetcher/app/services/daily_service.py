"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: Daily stock service - source fallback, normalization, and history truncation.
模块: 日线服务 - 数据源降级、标准化和历史截断处理。

Dependencies: app.providers.aktools_client, app.models
依赖: app.providers.aktools_client, app.models

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from typing import Any

from app.models import DailyBar, DailyResponse
from app.providers.aktools_client import AktoolsClient, rolling_window_for_trading


class DailyService:
    """Handles end-to-end daily data retrieval from upstream sources.
    负责日线数据的端到端获取与处理。
    """

    def __init__(self, client: AktoolsClient) -> None:
        self._client = client

    def get_latest_daily(self, symbol: str, limit: int) -> DailyResponse:
        """Fetches and returns normalized latest bars with fallback.
        通过降级策略获取并返回标准化后的最近日线数据。
        """
        six_digit_symbol = normalize_six_digit_symbol(symbol)
        prefixed_symbol = normalize_market_prefixed_symbol(symbol)
        start_date, end_date = rolling_window_for_trading(days=420)

        primary_error: str | None = None
        secondary_error: str | None = None
        normalized_rows: list[DailyBar] = []
        source_used = ""

        try:
            primary_rows = self._client.fetch_hist_daily(
                symbol=six_digit_symbol,
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
                    symbol=prefixed_symbol,
                    start_date=start_date,
                    end_date=end_date,
                )
                normalized_rows = normalize_sina_rows(secondary_rows)
                source_used = "sina:stock_zh_a_daily"
            except Exception as exc:  # intentionally broad for resilient fallback
                secondary_error = str(exc)

        if not normalized_rows:
            raise RuntimeError(
                "Both upstream sources failed. "
                f"primary_error={primary_error}; secondary_error={secondary_error}"
            )

        normalized_rows = sorted(normalized_rows, key=lambda item: item.date)
        trimmed_rows = normalized_rows[-limit:]

        return DailyResponse(
            symbol=six_digit_symbol,
            requested_limit=limit,
            actual_count=len(trimmed_rows),
            insufficient_history=len(trimmed_rows) < limit,
            source_used=source_used,
            data=trimmed_rows,
        )


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
    if not isinstance(value, str):
        raise RuntimeError(f"Unsupported date value type: {type(value)}")
    text = value.strip()
    if "T" in text:
        return text.split("T", maxsplit=1)[0]
    if len(text) == 8 and text.isdigit():
        return f"{text[:4]}-{text[4:6]}-{text[6:8]}"
    return text
