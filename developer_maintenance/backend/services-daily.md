# backend/services-daily — 日线服务

## 模块职责

日线数据的**端到端编排**：

1. 输入解析（支持股票代码或股票名称）
2. 代码规范化（6 位、带市场前缀）
3. 代码-名称匹配缓存（主源+降级源）
4. 多源降级拉取
5. 字段标准化为 `DailyBar`
6. 按日期升序排序
7. 按 `limit` 截断末 N 条
8. 填装 `DailyResponse`（含 `source_used` 元信息）

## 关键结构

`daily_service.py` 已按职责拆分为三层：

1. `StockIdentityResolver`：输入解析 + 代码名称匹配缓存
2. `DailyService`：日线拉取编排与四层降级
3. 纯函数工具：字段映射、交易所映射、日期/类型转换

其中代码-名称映射加载策略：

```text
1. stock_zh_a_spot_em（主源）
     失败/空 ↓
2. stock_info_a_code_name（降级）
     失败/空 ↓
3. local akshare: stock_info_a_code_name（本地直连降级）
     失败/空 ↓
4. 抛 RuntimeError（仅在名称匹配或显式反查名称时触发）
```

日线窗口不再固定 420 天，而是按 `limit` 动态估算：

`lookback_days = max(420, limit * 4)`

用于覆盖“较大 limit（如上市至今）”请求。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/app/services/__init__.py` | 空模块声明 |
| `datafetcher/app/services/daily_service.py` | `DailyService` 类 + 一组纯函数工具 |

## 对外接口

### 类 `DailyService`

| 方法 | 入参 | 返回 | 说明 |
|---|---|---|---|
| `__init__(client, canghai_client=None)` | Aktools 客户端 + 可选 Canghai 客户端 | — | 如不传 canghai，默认 `CanghaiClient()` |
| `get_latest_daily(symbol, limit)` | 股票代码或股票名称 + 条数上限 | `DailyResponse` | 非法输入/未知名称 → `ValueError`；所有日线源失败 → `RuntimeError` |

### 类 `StockIdentityResolver`

| 方法 | 入参 | 返回 | 说明 |
|---|---|---|---|
| `resolve(user_input)` | 股票代码或股票名称 | `StockIdentity` | 统一输出 `six_digit_symbol/prefixed_symbol/stock_name` |

### 降级序列（固定顺序）

```text
1. Eastmoney   (AktoolsClient.fetch_hist_daily, 6 位代码)
     失败/空 ↓
2. Sina        (AktoolsClient.fetch_sina_daily, 市场前缀代码)
     失败/空 ↓
3. Local Akshare (stock_zh_a_hist, 6 位代码)
     失败/空 ↓
4. Canghai     (CanghaiClient.fetch_canghai_daily, 交易所代码 + 6 位代码)
     失败/空 ↓
5. 抛 RuntimeError，拼接四层错误信息
```

### 模块级工具函数

| 函数 | 作用 |
|---|---|
| `normalize_six_digit_symbol(symbol)` | 去前缀，校验 6 位数字 |
| `normalize_market_prefixed_symbol(symbol)` | 加 `sh`/`sz`/`bj` 前缀（新浪需要） |
| `normalize_stock_name(stock_name)` | 名称标准化（去空白+小写） |
| `extract_symbol_name_pair(row)` | 从上游行数据提取 `(symbol, stock_name)` |
| `estimate_calendar_days_for_limit(limit)` | 按 limit 估算自然日窗口 |
| `normalize_hist_rows(rows)` | 东财字段 → `DailyBar` |
| `normalize_sina_rows(rows)` | 新浪字段 → `DailyBar` |
| `normalize_canghai_rows(rows)` | 沧海字段 → `DailyBar`（`amount=None`） |
| `to_tsanghi_exchange_code(prefixed)` | sh/sz/bj + B股前缀 → `XSHG/XSHGB/XSHE/XSHEB/BJSE` |
| `to_iso_date(value)` | 兼容 `YYYYMMDD` / `YYYY-MM-DD` / ISO8601 |
| `to_iso_yyyy_mm_dd(compact)` | `YYYYMMDD` → `YYYY-MM-DD` |
| `require_field` / `to_float` / `to_float_or_none` | 通用取值 & 类型转换 |

## 关键规则

- **空结果也算失败**：任何一层只要 `normalized_rows` 仍为空，就继续降级
- **异常捕获是宽泛的**（`except Exception`）：上游 HTTP 各种毛病都应该触发下一级降级，而不是冒泡
- **B 股处理**：上海 900xxx → XSHGB，深圳 200xxx → XSHEB（见 `to_tsanghi_exchange_code`）
- **insufficient_history**：截断后 `len < limit` 时置 `True`，前端可据此提示新股

## 依赖关系

依赖：`app.models.DailyBar / DailyResponse`、`app.providers.aktools_client`、`app.providers.canghai_client`

被依赖：`app.main`（通过 `DailyService` 实例）、`app.services.stock_insight_service`（作为个股洞察聚合的核心日线来源）

## 扩展流程

- **新增数据源**：在 `get_latest_daily` 的降级序列中追加一段 `if not normalized_rows: try: ...`，同步加 `normalize_<source>_rows()`
- **改变降级顺序**：只改 `get_latest_daily` 内部逻辑，不影响其它模块
- **字段扩展（如复权、涨跌幅）**：先改 `models.py.DailyBar`，再改三处 `normalize_*_rows`

## 变更日志

- 2026-04-30: `DailyService` 被 `StockInsightService` 复用为个股洞察聚合接口的核心日线数据来源；本文件无业务逻辑变更。
- 2026-04-20: 初始化文档；当前降级序列为 东财 → 新浪 → 沧海。
- 2026-04-21: 重构为 `StockIdentityResolver + DailyService` 分层；新增名称匹配（含端点降级）；日线窗口改为随 limit 动态扩展。
- 2026-04-21: 日线与名称匹配各增加一层 local akshare 本地直连降级，降低对 AKTools/Canghai 运行态依赖。
