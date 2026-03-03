"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: DataFetcher runtime configuration.
模块: DataFetcher 运行时配置。

Dependencies: os
依赖: os

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

import os


def _int_env(key: str, default: int) -> int:
    value = os.getenv(key, "")
    if not value:
        return default
    try:
        return int(value)
    except ValueError as exc:
        raise ValueError(f"Invalid integer env '{key}': {value}") from exc


AKTOOLS_BASE_URL = os.getenv("AKTOOLS_BASE_URL", "http://127.0.0.1:8080")
REQUEST_TIMEOUT_SECONDS = _int_env("REQUEST_TIMEOUT_SECONDS", 20)
DEFAULT_LIMIT = _int_env("DEFAULT_LIMIT", 120)
MAX_LIMIT = _int_env("MAX_LIMIT", 240)
