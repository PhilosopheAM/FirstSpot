# backend/services-stock-insight — 个股洞察聚合服务

## 模块职责

`StockInsightService` 负责为前端个股信息页聚合页面级数据：核心日线、证券档案、估值指标、分析师评级、季度营收/净利润和可选概念标签。日线数据是必需数据；其它信息源按 best-effort 拉取，失败时写入 `source_errors`，不阻断页面加载。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/app/services/stock_insight_service.py` | 聚合 `DailyService`、`AktoolsClient` 与 `CanghaiClient`，输出 `StockInsightResponse` |

## 对外接口

### 类 `StockInsightService`

| 方法 | 入参 | 返回 | 说明 |
|---|---|---|---|
| `__init__(daily_service, aktools_client, canghai_client)` | 日线服务 + AKTools 客户端 + Canghai 客户端 | — | 复用 `main.py` 中的同一组 provider 实例 |
| `get_stock_insight(symbol, daily_limit, include_concepts=False, max_concept_boards=80)` | 股票代码/名称、日线条数、是否扫描概念板块、概念扫描上限 | `StockInsightResponse` | 核心日线失败则抛错；估值/资料/评级/财务/概念源失败则记录 `source_errors` |

### 聚合来源

| 数据块 | 来源 | 字段 |
|---|---|---|
| 核心日线 | `DailyService.get_latest_daily()` | `DailyResponse.data[]` |
| 基础资料 / 行业 / 市值 | AKTools `stock_individual_info_em` | `股票简称`、`总市值`、`流通市值`、`行业` |
| PE / 股息率 / 52 周高低 | AKTools `stock_individual_spot_xq` | `市盈率(动)`、`市盈率(TTM)`、`股息(TTM)`、`股息率(TTM)`、`52周最高/最低` |
| 公司简介 / 主营业务 / 英文简称 | AKTools `stock_individual_basic_info_xq` | `org_short_name_en`、`main_operation_business`、`org_cn_introduction` |
| 分析师评级 | AKTools `stock_institute_recommend_detail` | `最新评级`，聚合为 buy / hold / sell 计数 |
| 季度财务 | Canghai `/income/statement/quarterly` | `total_operating_revenue`、`net_profit`、`net_profit_parent_company_owners` |
| 概念标签 | AKTools `stock_board_concept_name_em` + `stock_board_concept_cons_em` | 仅 `include_concepts=true` 时扫描 |

## 依赖关系

依赖：`app.models.StockInsightResponse` 及其子模型、`app.services.daily_service.DailyService`、`app.providers.aktools_client.AktoolsClient`、`app.providers.canghai_client.CanghaiClient`

被依赖：`app.main` 的 `/api/v1/stocks/{symbol}/insight` 路由

## 变更日志

- 2026-04-30: 新增 `StockInsightService`，聚合日线、估值、公司资料、评级、季度财务和可选概念标签，非核心源失败时返回 `source_errors`。
