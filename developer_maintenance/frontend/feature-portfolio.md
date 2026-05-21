# frontend/feature-portfolio — 我的持仓

## 模块职责

`portfolio` 实现手动录入站外成交、本地持久化、组合总览（大类占比条、集中度、排序列表）与单条详情/编辑/删除。对齐 `UX-Product-Design/V1/持仓设计.md` 与 Figma 页面「Portfolio 持仓 V1」。V1 不接券商、不在 App 内下单；行情未接入时最新价默认等于成本价。

## 关键文件

| 文件 | 作用 |
|---|---|
| `testapp/lib/features/portfolio/domain/portfolio_models.dart` | `PortfolioHolding`、`PortfolioAssetType`、`PortfolioSummary` |
| `testapp/lib/features/portfolio/domain/portfolio_calculator.dart` | 权重、大类占比、集中度、排序与添加预览占比 |
| `testapp/lib/features/portfolio/data/portfolio_repository.dart` | `SharedPreferences` JSON 持久化（key: `portfolio.holdings_json_v1`）；首次空列表注入演示持仓 |
| `testapp/lib/features/portfolio/data/portfolio_demo_seed.dart` | 录屏演示：3 股 + 3 ETF，备注富途/招商 |
| `testapp/lib/features/portfolio/data/portfolio_market_data_service.dart` | 从 `assets/mock_data/*_daily.json` 读收盘价 |
| `testapp/lib/features/portfolio/data/portfolio_controller.dart` | 全局 `portfolioController`（`ChangeNotifier`） |
| `testapp/lib/features/portfolio/pages/portfolio_page.dart` | 入口：加载后进入总览 |
| `testapp/lib/features/portfolio/pages/portfolio_overview_page.dart` | 总览 / 空状态（中文文案） |
| `testapp/lib/features/portfolio/pages/portfolio_add_flow_page.dart` | 四步录入/编辑向导 |
| `testapp/lib/features/portfolio/widgets/portfolio_detail_sheet.dart` | 详情底部弹层（含备注与走势折线） |
| `testapp/lib/features/portfolio/widgets/portfolio_sparkline_chart.dart` | 详情「走势示意」迷你图 |
| `testapp/assets/mock_data/*_daily.json` | 六标的 mock 日线（录屏/走势） |
| `developer_maintenance/frontend/portfolio-demo-recording.md` | 录屏演示数据与重置说明 |
| `testapp/lib/features/portfolio/widgets/portfolio_*.dart` | 主题、堆叠条、环形图、列表行、集中度 |
| `testapp/lib/features/portfolio/utils/portfolio_format.dart` | 人民币与百分比格式化 |
| `testapp/test/portfolio_test.dart` | 计算器与仓储单元测试 |

## 对外接口 / 调用方式

| 符号 | 调用方 | 说明 |
|---|---|---|
| `PortfolioPage` | `HomeDashboardPage` 底部「持仓」 | 进入持仓功能 |
| `portfolioController` | 各 portfolio 页面 | `load()` / `upsert()` / `remove()` / `summary` |
| `PortfolioCalculator.summarize` | 总览、测试 | 组合汇总 |
| `showPortfolioDetailSheet` | 总览列表行点击 | 详情 + 编辑/删除 |

## 依赖关系

- 依赖 `shared_preferences` 本地存储。
- 被 `testapp/lib/features/onboarding/pages/home_dashboard_page.dart` 引用。
- UI 色板对齐 Figma `Jb5m5oWDmydGzAOcqeRAB4` 中 `FS_Portfolio_*` 帧；涨跌色采用 **A 股红涨绿跌**（`PortfolioTheme.priceUp` / `priceDown`）。
- 走势：`PortfolioMarketDataService` + `portfolio_sparkline_chart`（mock 资产 JSON）；后续可改接 `datafetcher` 日线 API。
- 录屏：见 `portfolio-demo-recording.md`；演示种子键 `portfolio.demo_seeded_v1`。

## 变更日志

- 2026-05-21: 录屏演示默认种子（3 股 + 3 ETF）、6 份 mock 日线、详情走势折线图、`portfolio-demo-recording.md`。
- 2026-05-19: 新增 portfolio feature（领域模型、本地仓储、总览/空状态/四步录入/详情弹层、首页底部入口）与 `portfolio_test.dart`。
