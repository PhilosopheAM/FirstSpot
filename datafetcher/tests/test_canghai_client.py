"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: Manual test script for CanghaiClient daily API.
模块: CanghaiClient 日线接口的手工测试脚本。

Dependencies: app.providers.canghai_client
依赖: app.providers.canghai_client

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from pprint import pprint

from app.providers.canghai_client import CanghaiClient


def main() -> None:
    """Runs a simple manual fetch against Canghai daily API.
    运行一次简单的沧海日线接口手工拉取。

    Notes:
        Requires TSANGHI_API_TOKEN (and optionally TSANGHI_BASE_URL) to be set
        in environment before running.
        运行前需要在环境变量中设置 TSANGHI_API_TOKEN（以及可选的 TSANGHI_BASE_URL）。
    """
    client = CanghaiClient()

    # Example: 300059 (东方财富)，深交所 XSHE。
    # 示例: 300059 (东方财富)，对应深交所 XSHE。
    rows = client.fetch_canghai_daily(
        exchange_code="XSHE",
        ticker="300059",
        start_date="2024-01-01",
        end_date="2024-12-31",
    )

    print(f"Fetched rows: {len(rows)}")
    print("All rows:")
    pprint(rows)


if __name__ == "__main__":
    main()

