# backend/models — 响应模型

## 模块职责

定义 FastAPI 对 Flutter 的**统一响应契约**。所有上游数据都要被归一化为这里的模型再返回，保证前端只面向单一数据形态。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/app/models.py` | 定义 Pydantic 模型 `DailyBar`、`DailyResponse` 与个股洞察聚合响应模型 |

## 对外接口

### `DailyBar`

标准化的单条日线 OHLC。

| 字段 | 类型 | 说明 |
|---|---|---|
| `date` | `str` | 交易日，格式 `YYYY-MM-DD` |
| `open` | `float` | 开盘价 |
| `high` | `float` | 最高价 |
| `low` | `float` | 最低价 |
| `close` | `float` | 收盘价 |
| `volume` | `float` | 成交量 |
| `amount` | `float \| None` | 成交额（沧海源无此字段，返回 `None`） |

### `DailyResponse`

Flutter 消费的顶层响应结构。

| 字段 | 类型 | 说明 |
|---|---|---|
| `symbol` | `str` | 标准化后的 6 位股票代码 |
| `stock_name` | `str \| None` | 若能识别则返回股票名称（如按名称输入会原样回填） |
| `requested_limit` | `int` | 前端请求的 limit |
| `actual_count` | `int` | 实际返回的日线条数 |
| `insufficient_history` | `bool` | 是否不足 limit（新股等） |
| `source_used` | `str` | 最终实际命中的源，取值：`eastmoney:stock_zh_a_hist` / `sina:stock_zh_a_daily` / `canghai:stock_daily` |
| `data` | `list[DailyBar]` | 日线列表，按日期升序 |

### `StockInsightResponse`

个股信息页使用的页面级聚合响应。

| 字段 | 类型 | 说明 |
|---|---|---|
| `symbol` | `str` | 标准化后的 6 位股票代码 |
| `profile` | `StockInsightProfile` | 证券名称、英文名、交易所、行业、概念标签、公司简介、主营业务 |
| `metrics` | `StockInsightMetrics` | 市值、流通市值、PE、股息/股息率、52 周高低 |
| `analyst_rating` | `StockInsightAnalystRating` | 评级总数、buy/hold/sell 计数、最新评级与来源 |
| `financial_quarters` | `list[StockInsightFinancialQuarter]` | 最近季度营收、净利润、归母净利润摘要 |
| `daily` | `DailyResponse` | 核心日线响应 |
| `source_used` | `list[str]` | 成功命中的数据源列表 |
| `source_errors` | `dict[str, str]` | 非核心数据源失败原因 |

## 依赖关系

依赖：`pydantic`

被依赖：`app.main`、`app.services.daily_service`、`app.services.stock_insight_service`（以及 Flutter 端对应的解码结构）

## 变更日志

- 2026-04-30: 新增 `StockInsightProfile`、`StockInsightMetrics`、`StockInsightFinancialQuarter`、`StockInsightAnalystRating` 与 `StockInsightResponse`，支撑个股洞察聚合接口。
- 2026-04-20: 初始化文档；当前 2 个模型，`DailyBar.amount` 为可空。
- 2026-04-21: `DailyResponse` 新增 `stock_name` 字段，支持代码名称匹配结果回传。
