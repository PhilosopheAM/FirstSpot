"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: Manual test script for DailyService.get_latest_daily.
模块: DailyService.get_latest_daily 的手工测试脚本。

Dependencies: app.services.daily_service, app.providers.aktools_client, app.providers.canghai_client
依赖: app.services.daily_service, app.providers.aktools_client, app.providers.canghai_client

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from pprint import pprint

from app.providers.aktools_client import AktoolsClient
from app.providers.canghai_client import CanghaiClient
from app.services.daily_service import DailyService


def main() -> None:
    """Runs a manual end-to-end test for DailyService.get_latest_daily.
    运行一次 DailyService.get_latest_daily 的端到端手工测试。

    Notes:
        Requires upstream AKTools and Canghai to be available:
        - AKTOOLS_BASE_URL 指向 AKTools 服务
        - TSANGHI_API_TOKEN（以及可选 TSANGHI_BASE_URL）配置正确
        需要上游 AKTools 和沧海数据服务可用。
    """
    service = DailyService(client=AktoolsClient(), canghai_client=CanghaiClient())

    # Example: 300059 (东方财富)，最近 12 个交易日。
    # 示例: 300059 (东方财富)，最近 12 个交易日。
    response = service.get_latest_daily(symbol="300059", limit=12)

    print("DailyService.get_latest_daily response (300059, limit=12):")
    pprint(response.model_dump(), sort_dicts=False)


if __name__ == "__main__":
    main()

