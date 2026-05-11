"""
Last Updated: 2026-04-30
最后更新: 2026-04-30

Module: Unit tests for StockInsightService aggregation behavior.
模块: StockInsightService 聚合行为单元测试。

Dependencies: app.models, app.services.stock_insight_service
依赖: app.models, app.services.stock_insight_service

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from app.models import DailyBar, DailyResponse
from app.services.stock_insight_service import StockInsightService


class FakeDailyService:
    """Fake daily service returning deterministic bars.
    返回确定性日线数据的伪服务。
    """

    def get_latest_daily(self, symbol: str, limit: int) -> DailyResponse:
        return DailyResponse(
            symbol="600519",
            stock_name="贵州茅台",
            requested_limit=limit,
            actual_count=2,
            insufficient_history=False,
            source_used="eastmoney:stock_zh_a_hist",
            data=[
                DailyBar(date="2026-04-28", open=1400, high=1410, low=1390, close=1405, volume=1000, amount=1),
                DailyBar(date="2026-04-29", open=1405, high=1412, low=1400, close=1401, volume=1200, amount=2),
            ],
        )


class FakeAktoolsClient:
    """Fake AKTools client for optional stock insight sources.
    个股洞察可选源使用的 AKTools 伪客户端。
    """

    def fetch_individual_info_rows(self, symbol: str) -> list[dict[str, object]]:
        return [
            {"item": "股票简称", "value": "贵州茅台"},
            {"item": "总市值", "value": 1_760_000_000_000},
            {"item": "流通市值", "value": 1_750_000_000_000},
            {"item": "行业", "value": "酿酒行业"},
        ]

    def fetch_xueqiu_spot_rows(self, symbol: str) -> list[dict[str, object]]:
        return [
            {"item": "市盈率(动)", "value": "23.4"},
            {"item": "市盈率(TTM)", "value": "24.1"},
            {"item": "股息(TTM)", "value": "30.876"},
            {"item": "股息率(TTM)", "value": "2.18"},
            {"item": "52周最高", "value": "1600"},
            {"item": "52周最低", "value": "1300"},
        ]

    def fetch_xueqiu_basic_info_rows(self, symbol: str) -> list[dict[str, object]]:
        return [
            {"item": "org_short_name_en", "value": "Kweichow Moutai"},
            {"item": "main_operation_business", "value": "茅台酒及系列酒的生产与销售。"},
            {"item": "org_cn_introduction", "value": "贵州茅台酒股份有限公司。"},
        ]

    def fetch_institute_rating_rows(self, symbol: str) -> list[dict[str, object]]:
        return [
            {"最新评级": "买入"},
            {"最新评级": "增持"},
            {"最新评级": "中性"},
            {"最新评级": "减持"},
        ]

    def fetch_concept_board_rows(self) -> list[dict[str, object]]:
        return [{"板块名称": "白酒概念"}, {"板块名称": "人工智能"}]

    def fetch_concept_constituent_rows(self, concept_name: str) -> list[dict[str, object]]:
        if concept_name == "白酒概念":
            return [{"代码": "600519"}, {"代码": "000858"}]
        return [{"代码": "300750"}]


class FakeCanghaiClient:
    """Fake Canghai client for quarterly financial rows.
    季度财务行使用的沧海伪客户端。
    """

    def fetch_income_statement_quarterly(self, *args, **kwargs) -> list[dict[str, object]]:
        return [
            {
                "report_date": "2026-03-31",
                "total_operating_revenue": 54_702_912_385.23,
                "net_profit": 28_153_831_489.89,
                "net_profit_parent_company_owners": 27_242_512_886.45,
            },
            {
                "report_date": "2025-12-31",
                "total_operating_revenue": 41_150_282_256.03,
                "net_profit": 18_411_520_087.50,
                "net_profit_parent_company_owners": 17_693_320_389.50,
            },
        ]


class FailingOptionalAktoolsClient(FakeAktoolsClient):
    """Fake AKTools client that fails all optional calls.
    所有可选调用都失败的 AKTools 伪客户端。
    """

    def fetch_individual_info_rows(self, symbol: str) -> list[dict[str, object]]:
        raise RuntimeError("individual info unavailable")

    def fetch_xueqiu_spot_rows(self, symbol: str) -> list[dict[str, object]]:
        raise RuntimeError("spot unavailable")

    def fetch_xueqiu_basic_info_rows(self, symbol: str) -> list[dict[str, object]]:
        raise RuntimeError("basic info unavailable")

    def fetch_institute_rating_rows(self, symbol: str) -> list[dict[str, object]]:
        raise RuntimeError("rating unavailable")


class FailingCanghaiClient(FakeCanghaiClient):
    """Fake Canghai client that fails financial calls.
    财务调用失败的沧海伪客户端。
    """

    def fetch_income_statement_quarterly(self, *args, **kwargs) -> list[dict[str, object]]:
        raise RuntimeError("financial unavailable")


def test_stock_insight_service_aggregates_optional_sources() -> None:
    service = StockInsightService(
        daily_service=FakeDailyService(),
        aktools_client=FakeAktoolsClient(),
        canghai_client=FakeCanghaiClient(),
    )

    response = service.get_stock_insight(symbol="贵州茅台", daily_limit=2, include_concepts=True)

    assert response.symbol == "600519"
    assert response.profile.industry == "酿酒行业"
    assert response.profile.stock_name_en == "Kweichow Moutai"
    assert response.profile.concept_tags == ["白酒概念"]
    assert response.metrics.market_cap == 1_760_000_000_000
    assert response.metrics.pe_ttm == 24.1
    assert response.metrics.dividend_yield_ttm == 2.18
    assert response.analyst_rating.buy_count == 2
    assert response.analyst_rating.hold_count == 1
    assert response.analyst_rating.sell_count == 1
    assert len(response.financial_quarters) == 2
    assert response.source_errors == {}


def test_stock_insight_service_keeps_daily_when_optional_sources_fail() -> None:
    service = StockInsightService(
        daily_service=FakeDailyService(),
        aktools_client=FailingOptionalAktoolsClient(),
        canghai_client=FailingCanghaiClient(),
    )

    response = service.get_stock_insight(symbol="600519", daily_limit=2)

    assert response.daily.actual_count == 2
    assert response.profile.stock_name == "贵州茅台"
    assert response.financial_quarters == []
    assert response.analyst_rating.total_count == 0
    assert "aktools:stock_individual_info_em" in response.source_errors
    assert "canghai:income_statement_quarterly" in response.source_errors
