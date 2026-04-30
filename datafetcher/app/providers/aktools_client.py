"""
Last Updated: 2026-04-30
最后更新: 2026-04-30

Module: AKTools HTTP client for DataFetcher market, profile, and rating sources.
模块: DataFetcher 的 AKTools HTTP 客户端（行情、资料与评级数据源）。

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

    def fetch_spot_code_name_rows(self) -> list[dict[str, Any]]:
        """Fetches stock code-name rows from Eastmoney spot endpoint.
        从东财实时行情接口拉取股票代码-名称行数据。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_zh_a_spot_em"
        return _request_rows(url, params={})

    def fetch_basic_code_name_rows(self) -> list[dict[str, Any]]:
        """Fetches stock code-name rows from basic info endpoint.
        从基础信息接口拉取股票代码-名称行数据。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_info_a_code_name"
        return _request_rows(url, params={})

    def fetch_individual_info_rows(self, symbol: str) -> list[dict[str, Any]]:
        """Fetches Eastmoney individual stock info rows.
        从东方财富个股信息接口拉取基础资料行。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_individual_info_em"
        return _request_rows(url, params={"symbol": symbol})

    def fetch_xueqiu_spot_rows(self, symbol: str) -> list[dict[str, Any]]:
        """Fetches Xueqiu valuation snapshot rows.
        从雪球个股快照接口拉取估值指标行。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_individual_spot_xq"
        return _request_rows(url, params={"symbol": symbol})

    def fetch_xueqiu_basic_info_rows(self, symbol: str) -> list[dict[str, Any]]:
        """Fetches Xueqiu company profile rows.
        从雪球公司概况接口拉取公司简介行。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_individual_basic_info_xq"
        return _request_rows(url, params={"symbol": symbol})

    def fetch_institute_rating_rows(self, symbol: str) -> list[dict[str, Any]]:
        """Fetches Sina institute rating records for one stock.
        从新浪机构推荐池拉取单只股票评级记录。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_institute_recommend_detail"
        return _request_rows(url, params={"symbol": symbol})

    def fetch_concept_board_rows(self) -> list[dict[str, Any]]:
        """Fetches Eastmoney concept board list.
        从东方财富拉取概念板块列表。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_board_concept_name_em"
        return _request_rows(url, params={})

    def fetch_concept_constituent_rows(self, concept_name: str) -> list[dict[str, Any]]:
        """Fetches constituent stocks for one concept board.
        拉取单个概念板块的成分股列表。
        """
        url = f"{AKTOOLS_BASE_URL}/api/public/stock_board_concept_cons_em"
        return _request_rows(url, params={"symbol": concept_name})


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
