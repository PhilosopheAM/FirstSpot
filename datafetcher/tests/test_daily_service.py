"""
Last Updated: 2026-04-21
最后更新: 2026-04-21

Module: Manual test script for DailyService code-name matching and full-history daily fetch.
模块: DailyService 股票代码/名称匹配与全历史日线拉取的手工测试脚本。

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

    # Example: 贵州茅台（600519），按名称输入并尝试覆盖上市至今。
    # 示例: 输入“贵州茅台”，验证名称匹配与全历史拉取（使用较大 limit）。
    response = service.get_latest_daily(symbol="贵州茅台", limit=6000)

    payload = response.model_dump()
    print("DailyService.get_latest_daily response (贵州茅台, limit=6000):")
    print(
        "symbol={symbol}, stock_name={stock_name}, source_used={source_used}, actual_count={actual_count}".format(
            **payload
        )
    )
    if payload["data"]:
        print(f"first_date={payload['data'][0]['date']}, last_date={payload['data'][-1]['date']}")
    pprint(payload, sort_dicts=False)


if __name__ == "__main__":
    main()

