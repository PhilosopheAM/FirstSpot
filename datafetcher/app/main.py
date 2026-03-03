"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: DataFetcher HTTP entrypoint for single-stock daily bars.
模块: DataFetcher HTTP 入口，提供单股票日线接口。

Dependencies: fastapi, app.services.daily_service, app.providers.aktools_client, app.models, app.config
依赖: fastapi, app.services.daily_service, app.providers.aktools_client, app.models, app.config

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware

from app.config import DEFAULT_LIMIT, MAX_LIMIT
from app.models import DailyResponse
from app.providers.aktools_client import AktoolsClient
from app.providers.canghai_client import CanghaiClient
from app.services.daily_service import DailyService

app = FastAPI(
    title="FirstSpot DataFetcher",
    description="Independent proxy service for stock daily data with source fallback.",
    version="0.1.0",
)

# Allows browser-based frontend debugging from localhost.
# 允许浏览器前端本地调试时的跨域访问。
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

_daily_service = DailyService(client=AktoolsClient(), canghai_client=CanghaiClient())


@app.get("/health")
def health() -> dict[str, str]:
    """Simple health endpoint for service checks.
    服务健康检查接口。
    """
    return {"status": "ok"}


@app.get("/api/v1/stocks/{symbol}/daily", response_model=DailyResponse)
def get_stock_daily(
    symbol: str,
    limit: int = Query(default=DEFAULT_LIMIT, ge=1, le=MAX_LIMIT),
) -> DailyResponse:
    """Returns latest daily bars for one stock.
    返回单只股票最近日线数据。
    """
    try:
        return _daily_service.get_latest_daily(symbol=symbol, limit=limit)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except RuntimeError as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc
