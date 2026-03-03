"""
Last Updated: 2026-03-03
最后更新: 2026-03-03

Module: Manual test script for DailyService Canghai-only fallback.
模块: 仅测试 DailyService 使用沧海数据作为第三层降级的数据拉取。

Dependencies: app.services.daily_service, app.providers.canghai_client
依赖: app.services.daily_service, app.providers.canghai_client

Author: Harry Chen
Email: 11911421@mail.sustech.edu.cn
"""

from __future__ import annotations

from pprint import pprint

from app.providers.canghai_client import CanghaiClient
from app.services.daily_service import DailyService


class AlwaysFailAktoolsClient:
    """Fake Aktools client that always fails to trigger Canghai fallback.
    伪造的 Aktools 客户端，总是失败以强制触发沧海降级。
    """

    def fetch_hist_daily(self, *args, **kwargs):
        raise RuntimeError("forced failure from fake AktoolsClient.fetch_hist_daily")

    def fetch_sina_daily(self, *args, **kwargs):
        raise RuntimeError("forced failure from fake AktoolsClient.fetch_sina_daily")


def main() -> None:
    """Runs DailyService.get_latest_daily but forces Canghai usage.
    运行 DailyService.get_latest_daily，并强制使用沧海数据源。

    Notes:
        - Does NOT require AKTools to be running.
        - Requires TSANGHI_API_TOKEN（以及可选 TSANGHI_BASE_URL）配置正确。
        - 不需要启动 AKTools，只需正确配置沧海相关环境变量。
    """
    service = DailyService(client=AlwaysFailAktoolsClient(), canghai_client=CanghaiClient())

    # Example: 300059 (东方财富)，最近 12 个交易日。
    # 示例: 300059 (东方财富)，最近 12 个交易日。
    response = service.get_latest_daily(symbol="300059", limit=12)

    print("DailyService.get_latest_daily response (Canghai only, 300059, limit=12):")
    pprint(response.model_dump(), sort_dicts=False)


if __name__ == "__main__":
    main()

