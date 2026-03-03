"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: AKTools HTTP client for DataFetcher fallback sources.
模块: DataFetcher 的 AKTools HTTP 客户端（用于多数据源降级）。

Dependencies: urllib, json, app.config
依赖: urllib, json, app.config

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

import json
from datetime import datetime, timedelta, timezone
from typing import Any
from urllib.parse import urlencode
from urllib.request import urlopen

from app.config import AKTOOLS_BASE_URL, REQUEST_TIMEOUT_SECONDS


class AktoolsClient:
    """Encapsulates AKTools API calls.
    封装 AKTools API 调用细节。
    """

    def fetch_hist_daily(self, symbol: str, start_date: str, end_date: str) -> list[dict[str, Any]]:
        """Fetches Eastmoney daily bars via stock_zh_a_hist.
        通过 stock_zh_a_hist 拉取东方财富日线。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_zh_a_hist"
        params = {
            "symbol": symbol,
            "period": "daily",
            "start_date": start_date,
            "end_date": end_date,
            "adjust": "",
        }
        return _request_rows(url, params)

    def fetch_sina_daily(self, symbol: str, start_date: str, end_date: str) -> list[dict[str, Any]]:
        """Fetches Sina daily bars via stock_zh_a_daily.
        通过 stock_zh_a_daily 拉取新浪日线。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_zh_a_daily"
        params = {
            "symbol": symbol,
            "start_date": start_date,
            "end_date": end_date,
            "adjust": "",
        }
        return _request_rows(url, params)

    # TODO-f76eedb840224c49a83b5b5db6be8a0c 是沧浪数据的api，文档入口是 https://tsanghi.com/fin/doc


def rolling_window_for_trading(days: int = 420) -> tuple[str, str]:
    """Returns a wide date window to cover recent N trading bars.
    返回较宽日期区间，以覆盖最近 N 个交易日数据。
    """
    now_cn = datetime.now(timezone(timedelta(hours=8)))
    start = now_cn - timedelta(days=days)
    return start.strftime("%Y%m%d"), now_cn.strftime("%Y%m%d")


def _request_rows(url: str, params: dict[str, Any]) -> list[dict[str, Any]]:
    query = urlencode(params)
    full_url = f"{url}?{query}"
    with urlopen(full_url, timeout=REQUEST_TIMEOUT_SECONDS) as response:
        status = response.status
        raw = response.read().decode("utf-8")
    if status >= 400:
        raise RuntimeError(f"Upstream request failed with status {status}: {full_url}")
    payload = json.loads(raw)
    if not isinstance(payload, list):
        raise RuntimeError(f"Unexpected upstream payload type: {type(payload)}")
    return payload
