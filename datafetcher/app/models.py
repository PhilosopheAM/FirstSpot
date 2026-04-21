"""
Last Updated: 2026-04-21
最后更新: 2026-04-21

Module: DataFetcher response models for normalized stock daily data.
模块: DataFetcher 统一股票日线数据响应模型。

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
