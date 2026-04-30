"""
Last Updated: 2026-04-30
最后更新: 2026-04-30

Module: Stock insight service - aggregates market, valuation, profile, rating, and financial data.
模块: 个股洞察服务 - 聚合行情、估值、公司资料、评级与财务数据。

Dependencies: app.models, app.providers.aktools_client, app.providers.canghai_client, app.services.daily_service
依赖: app.models, app.providers.aktools_client, app.providers.canghai_client, app.services.daily_service

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from typing import Any

from app.models import (
    DailyResponse,
    StockInsightAnalystRating,
    StockInsightFinancialQuarter,
    StockInsightMetrics,
    StockInsightProfile,
    StockInsightResponse,
)
from app.providers.aktools_client import AktoolsClient
from app.providers.canghai_client import CanghaiClient
from app.services.daily_service import (
    DailyService,
    normalize_market_prefixed_symbol,
    to_tsanghi_exchange_code,
)


class StockInsightService:
    """Aggregates page-ready stock insight data from layered upstream sources.
    从多层上游数据源聚合个股洞察页可直接使用的数据。
    """

    def __init__(
        self,
        daily_service: DailyService,
        aktools_client: AktoolsClient,
        canghai_client: CanghaiClient,
    ) -> None:
        self._daily_service = daily_service
        self._aktools_client = aktools_client
        self._canghai_client = canghai_client

    def get_stock_insight(
        self,
        symbol: str,
        daily_limit: int,
        include_concepts: bool = False,
        max_concept_boards: int = 80,
    ) -> StockInsightResponse:
        """Builds an aggregated stock insight payload.
        构建个股洞察聚合响应。

        Core daily bars are required. Optional profile, valuation, rating, and
        financial sources are best-effort and reported through source_errors.
        日线数据为核心必需数据；资料、估值、评级和财务源为尽力拉取，
        失败时记录到 source_errors。
        """
        daily = self._daily_service.get_latest_daily(symbol=symbol, limit=daily_limit)
        prefixed_symbol = normalize_market_prefixed_symbol(daily.symbol)
        xueqiu_symbol = to_xueqiu_symbol(prefixed_symbol)

        profile = StockInsightProfile(
            symbol=daily.symbol,
            stock_name=daily.stock_name,
            exchange=prefixed_symbol[:2].upper(),
        )
        metrics = StockInsightMetrics()
        analyst_rating = StockInsightAnalystRating()
        financial_quarters: list[StockInsightFinancialQuarter] = []
        source_used: list[str] = [daily.source_used]
        source_errors: dict[str, str] = {}

        self._try_merge_individual_info(
            symbol=daily.symbol,
            profile=profile,
            metrics=metrics,
            source_used=source_used,
            source_errors=source_errors,
        )
        self._try_merge_xueqiu_spot(
            symbol=xueqiu_symbol,
            metrics=metrics,
            source_used=source_used,
            source_errors=source_errors,
        )
        self._try_merge_xueqiu_basic_info(
            symbol=xueqiu_symbol,
            profile=profile,
            source_used=source_used,
            source_errors=source_errors,
        )
        financial_quarters = self._try_fetch_financial_quarters(
            daily=daily,
            prefixed_symbol=prefixed_symbol,
            source_used=source_used,
            source_errors=source_errors,
        )
        analyst_rating = self._try_fetch_analyst_rating(
            symbol=daily.symbol,
            source_used=source_used,
            source_errors=source_errors,
        )

        if include_concepts:
            profile.concept_tags = self._try_fetch_concept_tags(
                symbol=daily.symbol,
                max_concept_boards=max_concept_boards,
                source_used=source_used,
                source_errors=source_errors,
            )

        return StockInsightResponse(
            symbol=daily.symbol,
            profile=profile,
            metrics=metrics,
            analyst_rating=analyst_rating,
            financial_quarters=financial_quarters,
            daily=daily,
            source_used=dedupe_preserve_order(source_used),
            source_errors=source_errors,
        )

    def _try_merge_individual_info(
        self,
        symbol: str,
        profile: StockInsightProfile,
        metrics: StockInsightMetrics,
        source_used: list[str],
        source_errors: dict[str, str],
    ) -> None:
        try:
            item_map = rows_to_item_map(self._aktools_client.fetch_individual_info_rows(symbol=symbol))
        except Exception as exc:  # intentionally broad: optional source
            source_errors["aktools:stock_individual_info_em"] = str(exc)
            return

        profile.stock_name = profile.stock_name or text_or_none(item_map.get("股票简称"))
        profile.industry = text_or_none(item_map.get("行业"))
        metrics.market_cap = number_or_none(item_map.get("总市值")) or metrics.market_cap
        metrics.circulating_market_cap = number_or_none(item_map.get("流通市值")) or metrics.circulating_market_cap
        source_used.append("aktools:stock_individual_info_em")

    def _try_merge_xueqiu_spot(
        self,
        symbol: str,
        metrics: StockInsightMetrics,
        source_used: list[str],
        source_errors: dict[str, str],
    ) -> None:
        try:
            item_map = rows_to_item_map(self._aktools_client.fetch_xueqiu_spot_rows(symbol=symbol))
        except Exception as exc:  # intentionally broad: optional source
            source_errors["aktools:stock_individual_spot_xq"] = str(exc)
            return

        metrics.pe_dynamic = number_or_none(item_map.get("市盈率(动)")) or metrics.pe_dynamic
        metrics.pe_ttm = number_or_none(item_map.get("市盈率(TTM)")) or metrics.pe_ttm
        metrics.dividend_ttm = number_or_none(item_map.get("股息(TTM)")) or metrics.dividend_ttm
        metrics.dividend_yield_ttm = number_or_none(item_map.get("股息率(TTM)")) or metrics.dividend_yield_ttm
        metrics.fifty_two_week_high = number_or_none(item_map.get("52周最高")) or metrics.fifty_two_week_high
        metrics.fifty_two_week_low = number_or_none(item_map.get("52周最低")) or metrics.fifty_two_week_low
        source_used.append("aktools:stock_individual_spot_xq")

    def _try_merge_xueqiu_basic_info(
        self,
        symbol: str,
        profile: StockInsightProfile,
        source_used: list[str],
        source_errors: dict[str, str],
    ) -> None:
        try:
            item_map = rows_to_item_map(self._aktools_client.fetch_xueqiu_basic_info_rows(symbol=symbol))
        except Exception as exc:  # intentionally broad: optional source
            source_errors["aktools:stock_individual_basic_info_xq"] = str(exc)
            return

        profile.stock_name = profile.stock_name or text_or_none(item_map.get("org_short_name_cn"))
        profile.stock_name_en = text_or_none(item_map.get("org_short_name_en")) or profile.stock_name_en
        profile.main_business = text_or_none(item_map.get("main_operation_business")) or profile.main_business
        profile.company_intro = text_or_none(item_map.get("org_cn_introduction")) or profile.company_intro
        source_used.append("aktools:stock_individual_basic_info_xq")

    def _try_fetch_financial_quarters(
        self,
        daily: DailyResponse,
        prefixed_symbol: str,
        source_used: list[str],
        source_errors: dict[str, str],
    ) -> list[StockInsightFinancialQuarter]:
        try:
            rows = self._canghai_client.fetch_income_statement_quarterly(
                exchange_code=to_tsanghi_exchange_code(prefixed_symbol),
                ticker=daily.symbol,
            )
        except Exception as exc:  # intentionally broad: optional source
            source_errors["canghai:income_statement_quarterly"] = str(exc)
            return []

        source_used.append("canghai:income_statement_quarterly")
        return [
            StockInsightFinancialQuarter(
                report_date=str(row.get("report_date")),
                total_operating_revenue=number_or_none(row.get("total_operating_revenue")),
                net_profit=number_or_none(row.get("net_profit")),
                net_profit_parent_company_owners=number_or_none(row.get("net_profit_parent_company_owners")),
            )
            for row in rows[:4]
            if row.get("report_date")
        ]

    def _try_fetch_analyst_rating(
        self,
        symbol: str,
        source_used: list[str],
        source_errors: dict[str, str],
    ) -> StockInsightAnalystRating:
        try:
            rows = self._aktools_client.fetch_institute_rating_rows(symbol=symbol)
        except Exception as exc:  # intentionally broad: optional source
            source_errors["aktools:stock_institute_recommend_detail"] = str(exc)
            return StockInsightAnalystRating()

        source_used.append("aktools:stock_institute_recommend_detail")
        summary = StockInsightAnalystRating(
            total_count=len(rows),
            latest_rating=text_or_none(rows[0].get("最新评级")) if rows else None,
            source_used="aktools:stock_institute_recommend_detail",
        )
        for row in rows:
            rating = text_or_none(row.get("最新评级")) or ""
            category = classify_rating(rating)
            if category == "buy":
                summary.buy_count += 1
            elif category == "hold":
                summary.hold_count += 1
            elif category == "sell":
                summary.sell_count += 1
        return summary

    def _try_fetch_concept_tags(
        self,
        symbol: str,
        max_concept_boards: int,
        source_used: list[str],
        source_errors: dict[str, str],
    ) -> list[str]:
        try:
            concept_rows = self._aktools_client.fetch_concept_board_rows()
        except Exception as exc:  # intentionally broad: optional source
            source_errors["aktools:stock_board_concept_name_em"] = str(exc)
            return []

        tags: list[str] = []
        for row in concept_rows[:max(0, max_concept_boards)]:
            concept_name = first_text(row, ("板块名称", "概念名称", "名称"))
            if not concept_name:
                continue
            try:
                constituent_rows = self._aktools_client.fetch_concept_constituent_rows(concept_name=concept_name)
            except Exception:
                continue
            if any(first_text(item, ("代码", "股票代码", "证券代码")) == symbol for item in constituent_rows):
                tags.append(concept_name)

        if tags:
            source_used.append("aktools:stock_board_concept_*_em")
        return tags


def rows_to_item_map(rows: list[dict[str, Any]]) -> dict[str, Any]:
    """Converts item/value rows into a dictionary.
    将 item/value 行转换为字典。
    """
    result: dict[str, Any] = {}
    for row in rows:
        item = row.get("item")
        if item is None:
            continue
        result[str(item)] = row.get("value")
    return result


def to_xueqiu_symbol(prefixed_symbol: str) -> str:
    """Converts sh/sz/bj prefixed symbol into Xueqiu style.
    将 sh/sz/bj 前缀股票代码转换为雪球格式。
    """
    return prefixed_symbol.upper()


def number_or_none(value: Any) -> float | None:
    """Best-effort numeric conversion for upstream scalar values.
    尽力将上游标量值转换为数字。
    """
    if value is None:
        return None
    if isinstance(value, int | float):
        return float(value)
    text = str(value).strip().replace(",", "").replace("%", "")
    if not text or text.lower() in {"nan", "none", "null", "--"}:
        return None
    try:
        return float(text)
    except ValueError:
        return None


def text_or_none(value: Any) -> str | None:
    """Returns stripped text or None for empty values.
    返回去空白文本，空值返回 None。
    """
    if value is None:
        return None
    text = str(value).strip()
    if not text or text.lower() in {"nan", "none", "null", "--"}:
        return None
    return text


def first_text(row: dict[str, Any], keys: tuple[str, ...]) -> str | None:
    """Returns the first non-empty text value from a row.
    从行数据中按候选键返回首个非空文本。
    """
    for key in keys:
        value = text_or_none(row.get(key))
        if value:
            return value
    return None


def classify_rating(rating: str) -> str | None:
    """Classifies Chinese analyst rating text.
    将中文分析师评级归类为 buy/hold/sell。
    """
    if any(keyword in rating for keyword in ("买入", "增持", "推荐", "强烈推荐", "优于大市")):
        return "buy"
    if any(keyword in rating for keyword in ("卖出", "减持", "回避", "低于大市")):
        return "sell"
    if any(keyword in rating for keyword in ("中性", "持有", "观望", "同步大市", "不评级")):
        return "hold"
    return None


def dedupe_preserve_order(items: list[str]) -> list[str]:
    """Deduplicates strings while preserving insertion order.
    按插入顺序去重字符串列表。
    """
    seen: set[str] = set()
    result: list[str] = []
    for item in items:
        if item in seen:
            continue
        seen.add(item)
        result.append(item)
    return result
