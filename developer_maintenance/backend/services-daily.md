# backend/services-daily — 日线服务

## 模块职责

日线数据的**端到端编排**：

1. 代码规范化（6 位、带市场前缀）
2. 多源降级拉取
3. 字段标准化为 `DailyBar`
4. 按日期升序排序
5. 按 `limit` 截断末 N 条
6. 填装 `DailyResponse`（含 `source_used` 元信息）

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
| `get_latest_daily(symbol, limit)` | 任意形态股票代码 + 条数上限 | `DailyResponse` | 非法 symbol → `ValueError`；所有源失败 → `RuntimeError` |

### 降级序列（固定顺序）

```text
1. Eastmoney   (AktoolsClient.fetch_hist_daily, 6 位代码)
     失败/空 ↓
2. Sina        (AktoolsClient.fetch_sina_daily, 市场前缀代码)
     失败/空 ↓
3. Canghai     (CanghaiClient.fetch_canghai_daily, 交易所代码 + 6 位代码)
     失败/空 ↓
4. 抛 RuntimeError，拼接三层错误信息
```

### 模块级工具函数

| 函数 | 作用 |
|---|---|
| `normalize_six_digit_symbol(symbol)` | 去前缀，校验 6 位数字 |
| `normalize_market_prefixed_symbol(symbol)` | 加 `sh`/`sz`/`bj` 前缀（新浪需要） |
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

被依赖：`app.main`（通过 `DailyService` 实例）

## 扩展流程

- **新增数据源**：在 `get_latest_daily` 的降级序列中追加一段 `if not normalized_rows: try: ...`，同步加 `normalize_<source>_rows()`
- **改变降级顺序**：只改 `get_latest_daily` 内部逻辑，不影响其它模块
- **字段扩展（如复权、涨跌幅）**：先改 `models.py.DailyBar`，再改三处 `normalize_*_rows`

## 变更日志

- 2026-04-20: 初始化文档；当前降级序列为 东财 → 新浪 → 沧海。
