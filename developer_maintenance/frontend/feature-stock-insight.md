# frontend/feature-stock-insight - 个股信息页

## 模块职责

`stock_insight` 负责承载新手首页进入的个股信息窗口，展示证券名称、当前价格、阶段涨跌、价格走势、核心统计卡片、分析师评级、财务健康和公司简介。页面不承担荐股或交易引导，只提供面向新手的观察与理解入口。

## 关键文件


| 文件                                                                           | 作用                                            |
| ---------------------------------------------------------------------------- | --------------------------------------------- |
| `testapp/lib/features/stock_insight/pages/stock_insight_template_page.dart`  | 个股窗口页面入口，负责顶部返回、证券名称切换、价格走势时间窗口、长周期平滑显示和信息区布局 |
| `testapp/lib/features/stock_insight/data/stock_insight_data_service.dart`    | UI 与后端/模拟数据之间的数据中间层，加载 `StockInsightViewData` |
| `testapp/lib/features/stock_insight/domain/stock_insight_models.dart`        | 证券档案、价格点、公司分类与术语解释模型                          |
| `testapp/lib/features/stock_insight/widgets/price_fluctuation_chart.dart`    | 第一版可复用价格波动图组件                                 |
| `testapp/lib/features/stock_insight/widgets/price_fluctuation_chart_v2.dart` | 支持自适应时间窗口、横向平移和纵向密度调整的价格波动图组件                 |
| `testapp/test/stock_insight_template_page_test.dart`                         | 个股窗口返回、时间窗口切换和长周期平滑图表的 widget 测试              |
| `UX-Product-Design/V1/stock-detail-page-design.md`                           | 个股/基金详情页 UX 设计来源                              |


## 对外接口 / 调用方式


| 类型 / 方法                                      | 调用方式                                                      | 说明                                                     |
| -------------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------ |
| `StockInsightTemplatePage`                   | `HomeDashboardPage` 中“了解你的第一只关注个股”任务卡 `Navigator.push` 进入 | 展示默认 `600519` 个股窗口，也可通过构造参数传入 `ticker` 和 `dataService` |
| `StockInsightDataService.loadPageData()`     | 页面初始化时调用                                                  | 根据 `ticker` 加载页面可直接渲染的数据                               |
| `StockInsightBackendApi.fetchStockInsight()` | 由数据服务调用                                                   | 后端聚合接口契约；当前开发阶段可使用 `MockStockInsightBackendApi`        |


## 依赖关系

- UI 依赖 Flutter `material.dart`、`fl_chart` 和 `dart:math`。
- 页面数据依赖 `stock_insight_data_service.dart` 与 `stock_insight_models.dart`。
- 首页入口位于 `testapp/lib/features/onboarding/pages/home_dashboard_page.dart`。
- Mock 数据优先读取 `testapp/assets/mock_data/600519_daily.json`，读取失败时回退到本地生成曲线。
- 价格走势图遵循 `stock-detail-page-design.md` 的平滑折线规范：不同时间窗口共享同一套时间筛选与显示降采样策略，长窗口最多渲染 64 个点，并保留 `isCurved` 与 `preventCurveOverShooting`。

## 真实数据接入分析

### 当前页面数据来源判断

`HomeDashboardPage` 中“了解你的第一只关注个股”任务卡直接打开 `const StockInsightTemplatePage()`，页面构造函数默认 `ticker = '600519'`。`StockInsightTemplatePage` 在未传入 `dataService` 时会创建 `StockInsightDataService(backendApi: MockStockInsightBackendApi())`，因此当前运行路径不是调用真实后端，而是走前端 mock。

`MockStockInsightBackendApi` 对 `600519` 优先读取 `testapp/assets/mock_data/600519_daily.json`；其它 ticker 使用本地随机曲线和虚构公司“星焰互动”。所以当前页面虽然能展示贵州茅台，但数据契约尚未接入真实 `datafetcher` HTTP 服务。

### 页面需要的数据 / 属性清单


| 页面区域   | 当前展示字段                                        | 当前实现状态                                         | 真实数据接入要求                                                                                    |
| ------ | --------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 顶部证券信息 | 中文名、英文名/副标题、ticker                            | `SecurityProfile` 提供；默认固定 `600519`，名称由 mock 填充 | 至少需要 `symbol`、`stock_name`、可选英文名/拼音名；A 股真实接口通常只能稳定拿到中文简称，英文名可先为空或由本地映射补充                    |
| 价格主视觉  | 最新价、上一交易日涨跌额、涨跌幅                              | 从 `dayLineSeries.last` 与倒数第二个点计算；只用 close      | `datafetcher` 已可提供日线 close，可计算最新价、涨跌额、涨跌幅；若要盘中实时价，需要新增实时行情接口                                |
| 走势折线   | 1D / 1W / 1M / 3M / 1Y / ALL 时间窗口             | 使用同一组 `dayLineSeries` 按时间过滤；mock JSON 有日线 OHLC | `datafetcher` 已可提供最近 N 条日线，但当前 `MAX_LIMIT=240`，无法真正覆盖多年 `ALL`；1D 也不是分时线，只是最近一个日线点           |
| 核心统计卡片 | Market Cap、P/E Ratio、Div Yield、52W Range、状态标签 | 全部硬编码在 UI                                      | `datafetcher` 当前不能直接提供总市值、市盈率、股息率；52W Range 可由日线 high/low 计算，但现有接口上限 240 条，不足完整 52 周交易日时会偏差 |
| 分析师评级  | Buy / Hold / Sell 占比、总推荐比例                    | 全部硬编码                                          | `datafetcher` 当前不能提供券商评级/一致预期；需要新增数据源，或改为“教学型解释卡”而非真实评级                                     |
| 财务健康   | 最近四季度 Revenue、Net Income 柱状图                  | 全部硬编码                                          | `datafetcher` 当前不能提供季度营收/归母净利润；需要新增财务报表/指标接口                                                |
| 公司介绍   | 简介文本、行业/主题标签                                  | 简介和标签硬编码；`CompanyInfoCategory` 模型有预留但页面未使用     | 当前后端只能反查股票简称，不能提供主营业务、行业、概念标签；需要新增公司概况/行业分类接口                                               |
| 新手解释内容 | `companyCategories`、`glossaryItems`           | 模型与 mock 预留，但当前页面未实际渲染                         | 若未来做教育型分析，需要后端返回结构化解释，或前端根据财务/行情字段生成固定解释                                                    |


### `datafetcher` 当前可覆盖能力

当前后端只暴露两类 HTTP 能力：


| 能力        | 现有接口 / 模块                                                                                   | 可支撑页面字段                                                         | 覆盖结论                                  |
| --------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | ------------------------------------- |
| 健康检查      | `GET /health`                                                                               | 无页面数据                                                           | 仅用于连通性                                |
| 单股票日线     | `GET /api/v1/stocks/{symbol}/daily?limit=N` → `DailyResponse`                               | 日线日期、open/high/low/close、volume、amount、股票代码、尽力返回股票名、source_used | 能支撑价格走势、最新收盘价、日涨跌、部分 52W Range        |
| 代码 / 名称匹配 | `StockIdentityResolver` 内部通过 `stock_zh_a_spot_em`、`stock_info_a_code_name`、local akshare 降级 | 支持输入“贵州茅台”或 `600519`，返回 `stock_name`                            | 能解决不只展示贵州茅台的问题，但前端还没接真实 HTTP 客户端和选股入口 |
| 多源降级      | 东财 → 新浪 → local akshare → 沧海                                                                | 提高日线成功率                                                         | 只覆盖日线；不覆盖基本面、财务、评级、公司介绍               |


`DailyResponse` 当前字段为：`symbol`、`stock_name`、`requested_limit`、`actual_count`、`insufficient_history`、`source_used`、`data[]`；其中 `data[]` 每条包含 `date/open/high/low/close/volume/amount`。

### 不能直接覆盖的缺口

- 缺少前端真实 HTTP 实现：`StockInsightBackendApi` 目前只有 `MockStockInsightBackendApi`，没有调用 `datafetcher` 的实现类。
- 缺少聚合接口：前端需要的是 `StockInsightViewData`，后端目前返回的是 `DailyResponse`，还没有 `/api/v1/stocks/{symbol}/insight` 之类的页面聚合契约。
- 缺少基础资料：公司简介、行业、概念标签、英文名不在现有 `datafetcher` 响应里。
- 缺少估值指标：市值、PE、股息率等统计卡片无法由现有日线接口稳定得到。
- 缺少财报指标：季度营收、净利润、利润率等“Financial Health”数据未接入。
- 缺少评级数据：分析师 Buy/Hold/Sell 占比当前无数据源，且在新手教育场景中需要谨慎处理，避免形成荐股暗示。
- 历史窗口限制：`MAX_LIMIT=240` 对 1Y 基本够用，但不足以支撑真正“ALL”；如果保留 ALL，需要扩展 limit 上限或新增按日期区间查询。

### 三个现有信息来源接口的 API 文档复查

这里的“三个接口”按当前 `datafetcher` 实际降级路径理解为：

1. 东方财富日线：AKTools / AKShare `stock_zh_a_hist`
2. 新浪日线：AKTools / AKShare `stock_zh_a_daily`
3. 沧海日线：Tsanghi `/api/fin/stock/{exchange}/daily`


| 目标属性       | 东财 `stock_zh_a_hist` | 新浪 `stock_zh_a_daily`                     | 沧海 `/daily`                                                                                                                   | 结论                                                                                     |
| ---------- | -------------------- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| 市值         | 不直接返回                | 不直接返回总市值；有 `outstanding_share` 时可粗略计算流通市值 | 不返回                                                                                                                           | 不能由三条已接入日线接口稳定获得；应接 `stock_individual_info_em` 或 `stock_zh_a_spot_em`                  |
| PE         | 不返回                  | 不返回                                       | 不返回                                                                                                                           | 不能由三条已接入日线接口获得；可接东财实时行情/雪球快照/乐咕估值类接口                                                   |
| 股息率        | 不返回                  | 不返回                                       | 不返回                                                                                                                           | 不能由三条已接入日线接口获得；可接 `stock_individual_spot_xq`、`stock_a_gxl_lg` 或 `stock_a_lg_indicator` |
| 分析师评级      | 不返回                  | 不返回                                       | 不返回                                                                                                                           | 不能由三条已接入日线接口获得；AKShare 另有新浪机构推荐与巨潮投资评级接口，但需自行汇总为 Buy/Hold/Sell                         |
| 季度营收 / 净利润 | 不返回                  | 不返回                                       | `/daily` 不返回；沧海另有 `/income/statement/quarterly` 可返回 `total_operating_revenue`、`net_profit`、`net_profit_parent_company_owners` | 当前已接入接口不能；沧海扩展端点和 AKShare 东财利润表单季度接口可以                                                 |
| 公司简介       | 不返回                  | 不返回                                       | 不返回                                                                                                                           | 不能由三条已接入日线接口获得；AKShare 雪球公司概况可返回 `org_cn_introduction` 和 `main_operation_business`     |
| 行业         | 不返回                  | 不返回                                       | 不返回                                                                                                                           | 三条日线接口不返回；AKShare 东财 `stock_individual_info_em` 可返回行业                                  |
| 概念标签       | 不返回                  | 不返回                                       | 不返回                                                                                                                           | 三条日线接口不返回；需要额外接概念板块/成分股映射接口，再反查个股所属概念                                                  |


文档依据：

- AKShare `stock_zh_a_hist` 文档输出字段仅包含 `日期/股票代码/开盘/收盘/最高/最低/成交量/成交额/振幅/涨跌幅/涨跌额/换手率`。
- AKShare `stock_zh_a_daily` 文档输出字段包含 `date/open/high/low/close/volume/amount/outstanding_share/turnover`，比东财多流动股本和换手率，但没有总市值、PE、股息率、评级、财务报表或公司简介。
- Tsanghi `/api/fin/stock/XSHG/daily` 实测与公开文档一致，返回 `ticker/date/open/high/low/close/volume`。
- AKShare 文档还显示可用扩展接口：`stock_individual_info_em` 返回总市值、流通市值、行业；`stock_individual_spot_xq` 样例含 `市盈率(TTM)`、`股息率(TTM)`、52 周高低；`stock_individual_basic_info_xq` 返回公司简介和主营业务；`stock_profit_sheet_by_quarterly_em` 返回单季度利润表；`stock_institute_recommend_detail` 与 `stock_rank_forecast_cninfo` 可作为评级来源。
- Tsanghi 扩展端点实测 `/api/fin/stock/XSHG/income/statement/quarterly?token=demo&ticker=600519&order=2` 可返回 `total_operating_revenue`、`net_profit` 和 `net_profit_parent_company_owners`，适合支撑“Financial Health”的季度营收/净利润柱状图。

因此，如果只使用当前 `datafetcher` 已封装的三条日线接口，以上目标属性大多数不能获得；如果允许在 AKTools/AKShare 与 Tsanghi 体系内新增 provider 方法，市值、PE、股息率、季度营收/净利润、公司简介、行业可以补齐，分析师评级可半结构化获取，概念标签需要额外设计反查逻辑。

### 建议的下一步数据契约

优先做一个最小真实数据版本，不一次性补齐所有硬编码模块：

1. 新增前端真实 HTTP adapter，实现 `StockInsightBackendApi.fetchStockInsight(ticker)`，先调用现有 `/api/v1/stocks/{symbol}/daily?limit=240`。
2. 前端用 `DailyResponse` 映射 `StockInsightViewData`：`stock_name` → `SecurityProfile.securityNameCn`，`data[].date/close` → `dayLineSeries`。
3. 先把真实可得区域切换为真实数据：顶部中文名、ticker、最新收盘价、涨跌额、涨跌幅、走势折线、基于返回数据计算的阶段高低。
4. 对暂不可得区域做产品降级：估值、评级、财务健康、公司介绍继续保留 mock/教学占位，或明确标记“数据源待接入”，避免混合真实行情与假基本面。
5. 第二阶段在 `datafetcher` 新增聚合能力：公司概况、行业标签、估值指标、财务摘要，并统一返回给前端页面级契约。

### 后端聚合接口落地状态

`datafetcher` 已新增 `GET /api/v1/stocks/{symbol}/insight`，返回 `StockInsightResponse`，聚合核心日线、公司资料、估值指标、分析师评级、季度营收/净利润和可选概念标签。前端下一步可优先接这个页面级接口，而不是分别调用多个数据源。

当前接口参数：


| 参数                   | 说明                                         |
| -------------------- | ------------------------------------------ |
| `daily_limit`        | 日线条数，默认 `DEFAULT_LIMIT`，受后端 `MAX_LIMIT` 限制 |
| `include_concepts`   | 是否扫描概念板块，默认 `false`；开启后会额外调用概念板块和成分股接口     |
| `max_concept_boards` | 概念扫描上限，默认 80，避免一次请求扫描过多板块                  |


## 变更日志

- 2026-04-30: 后端新增 `/api/v1/stocks/{symbol}/insight` 页面级聚合接口，前端后续可直接接入 `StockInsightResponse`。
- 2026-04-30: 复查东财日线、 新浪日线与沧海日线 API 文档，确认三条已接入日线接口不能直接覆盖市值、PE、股息率、评级、财务、公司简介、行业/概念等字段，并登记可扩展接口来源。
- 2026-04-29: 补充真实数据接入分析，梳理个股信息页字段清单、当前 mock 路径、`datafetcher` 可覆盖能力与后续聚合接口缺口。
- 2026-04-29: 根据 `stock-detail-page-design.md` 的平滑折线图规范，为 1D/1W/1M/3M/1Y/ALL 统一接入显示用降采样，长窗口最多 64 个渲染点，并保留 `isCurved` + `preventCurveOverShooting` 的平滑绘制；widget 测试覆盖 ALL 窗口的平滑线条约束。
- 2026-04-29: 修复个股窗口左上角返回图标无点击事件的问题，改为调用 `Navigator.maybePop()`；修复 `1D/1W/1M/3M/1Y/ALL` 时间窗口只更新选中态、不筛选图表数据的问题，并新增 widget 测试覆盖返回和时间窗口生效。

