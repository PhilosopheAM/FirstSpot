"""
Last Updated: 2026-04-30
最后更新: 2026-04-30

Module: DataFetcher response models for normalized stock daily and insight data.
模块: DataFetcher 统一股票日线与个股洞察数据响应模型。

Dependencies: pydantic
依赖: pydantic

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from pydantic import BaseModel, Field


class DailyBar(BaseModel):
    """Normalized single daily OHLC row.
    标准化后的单条日线 OHLC 数据。
    """

    date: str = Field(description="Trading date in YYYY-MM-DD")
    open: float
    high: float
    low: float
    close: float
    volume: float
    amount: float | None = None


class DailyResponse(BaseModel):
    """Unified response contract for Flutter.
    面向 Flutter 的统一返回结构。
    """

    symbol: str = Field(description="Normalized six-digit symbol")
    stock_name: str | None = Field(default=None, description="Resolved stock name if available")
    requested_limit: int
    actual_count: int
    insufficient_history: bool
    source_used: str
    data: list[DailyBar]


class StockInsightProfile(BaseModel):
    """Basic security profile for stock insight page.
    个股洞察页使用的基础证券档案。
    """

    symbol: str = Field(description="Normalized six-digit symbol")
    stock_name: str | None = Field(default=None, description="Chinese stock short name")
    stock_name_en: str | None = Field(default=None, description="English stock name if available")
    exchange: str | None = Field(default=None, description="Market exchange code such as SH/SZ/BJ")
    industry: str | None = Field(default=None, description="Industry label from upstream source")
    concept_tags: list[str] = Field(default_factory=list, description="Concept labels if resolved")
    company_intro: str | None = Field(default=None, description="Company introduction text")
    main_business: str | None = Field(default=None, description="Main business description")


class StockInsightMetrics(BaseModel):
    """Valuation and range metrics for stock insight page.
    个股洞察页使用的估值与区间指标。
    """

    market_cap: float | None = Field(default=None, description="Total market capitalization in CNY")
    circulating_market_cap: float | None = Field(default=None, description="Float market capitalization in CNY")
    pe_dynamic: float | None = Field(default=None, description="Dynamic PE ratio")
    pe_ttm: float | None = Field(default=None, description="Trailing twelve months PE ratio")
    dividend_ttm: float | None = Field(default=None, description="TTM dividend per share")
    dividend_yield_ttm: float | None = Field(default=None, description="TTM dividend yield percentage")
    fifty_two_week_high: float | None = Field(default=None, description="52-week high price")
    fifty_two_week_low: float | None = Field(default=None, description="52-week low price")


class StockInsightFinancialQuarter(BaseModel):
    """One quarterly income statement summary row.
    单季度利润表摘要行。
    """

    report_date: str
    total_operating_revenue: float | None = None
    net_profit: float | None = None
    net_profit_parent_company_owners: float | None = None


class StockInsightAnalystRating(BaseModel):
    """Aggregated analyst rating counts.
    聚合后的分析师评级计数。
    """

    total_count: int = 0
    buy_count: int = 0
    hold_count: int = 0
    sell_count: int = 0
    latest_rating: str | None = None
    source_used: str | None = None


class StockInsightResponse(BaseModel):
    """Aggregated stock insight payload for Flutter.
    面向 Flutter 的个股洞察聚合响应。
    """

    symbol: str = Field(description="Normalized six-digit symbol")
    profile: StockInsightProfile
    metrics: StockInsightMetrics
    analyst_rating: StockInsightAnalystRating
    financial_quarters: list[StockInsightFinancialQuarter]
    daily: DailyResponse
    source_used: list[str] = Field(default_factory=list, description="Successful optional insight sources")
    source_errors: dict[str, str] = Field(default_factory=dict, description="Non-blocking source errors")
