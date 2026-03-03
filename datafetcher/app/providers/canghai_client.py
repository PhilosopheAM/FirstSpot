"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: Canghai (Tsanghi) HTTP client for DataFetcher fallback source.
模块: DataFetcher 的沧海数据 (Tsanghi) HTTP 客户端，作为数据源降级的一部分。

Dependencies: urllib, json, app.config
依赖: urllib, json, app.config

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

import json
from typing import Any
from urllib.parse import urlencode
from urllib.request import urlopen

from app.config import REQUEST_TIMEOUT_SECONDS, TSANGHI_API_TOKEN, TSANGHI_BASE_URL


class CanghaiClient:
    """Encapsulates Canghai (Tsanghi) stock daily API calls.
    封装沧海数据(日线行情) API 调用细节。
    """

    def fetch_canghai_daily(
        self,
        exchange_code: str,
        ticker: str,
        start_date: str | None = None,
        end_date: str | None = None,
    ) -> list[dict[str, Any]]:
        """Fetches historical daily bars from Canghai.
        通过沧海历史日线接口拉取日线数据。

        Args:
            exchange_code: Exchange code such as "XSHG" or "XSHE".
            exchange_code: 交易所代码，如 "XSHG" 或 "XSHE"。
            ticker: Stock ticker without exchange prefix, e.g. "600000".
            ticker: 不含交易所前缀的股票代码，例如 "600000"。
            start_date: Optional start date in "YYYY-MM-DD" format.
            start_date: 可选的起始日期，格式为 "YYYY-MM-DD"。
            end_date: Optional end date in "YYYY-MM-DD" format.
            end_date: 可选的结束日期，格式为 "YYYY-MM-DD"。

        Returns:
            List of raw row dicts returned by Canghai API.
            返回沧海 API 返回的原始行字典列表。
        """
        if not TSANGHI_API_TOKEN:
            raise RuntimeError(
                "TSANGHI_API_TOKEN is not configured for Canghai upstream. "
                "必须在环境变量中配置 TSANGHI_API_TOKEN 才能调用沧海数据接口。"
            )

        url = f"{TSANGHI_BASE_URL}/api/fin/stock/{exchange_code}/daily"
        params: dict[str, Any] = {
            "token": TSANGHI_API_TOKEN,
            "ticker": ticker,
        }
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
        return _request_rows(url, params)


def _request_rows(url: str, params: dict[str, Any]) -> list[dict[str, Any]]:
    """Issues HTTP request to Canghai and parses JSON list payload.
    发送 HTTP 请求到沧海数据并解析返回的 JSON 列表。
    """
    query = urlencode(params)
    full_url = f"{url}?{query}"
    with urlopen(full_url, timeout=REQUEST_TIMEOUT_SECONDS) as response:
        status = response.status
        raw = response.read().decode("utf-8")
    if status >= 400:
        raise RuntimeError(f"Canghai upstream failed with status {status}: {full_url}")

    payload = json.loads(raw)

    if isinstance(payload, list):
        return payload

    if isinstance(payload, dict):
        # Normal success responses from some endpoints may wrap rows in "data".
        # 某些成功响应会将行数据包在 "data" 字段中返回。
        data = payload.get("data")
        if isinstance(data, list):
            return data

        # Otherwise treat it as an error-style payload and surface message.
        # 否则视为错误响应，尽量把错误信息透传出来。
        message = (
            payload.get("msg")
            or payload.get("message")
            or payload.get("error")
            or str(payload)
        )
        raise RuntimeError(f"Canghai upstream returned error payload: {message}")

    raise RuntimeError(f"Unexpected Canghai payload type: {type(payload)}")

