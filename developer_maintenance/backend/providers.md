# backend/providers — 第三方数据客户端

## 模块职责

封装与第三方数据源的 HTTP 交互。**每个 provider 只负责一件事：发请求、拿原始 JSON 列表**。不做字段归一化（那是 `services` 层的事），也不做业务降级。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/app/providers/__init__.py` | 空模块声明 |
| `datafetcher/app/providers/aktools_client.py` | 封装 AKTools（东财 + 新浪）接口 |
| `datafetcher/app/providers/canghai_client.py` | 封装沧海 / Tsanghi 云端日线接口 |

## 对外接口

### `AktoolsClient`（aktools_client.py）

| 方法 | 上游端点 | 入参 | 返回 |
|---|---|---|---|
| `fetch_hist_daily(symbol, start_date, end_date)` | `AKTOOLS/api/public/stock_zh_a_hist` | 6 位代码；`YYYYMMDD` | `list[dict]`（东财字段） |
| `fetch_sina_daily(symbol, start_date, end_date)` | `AKTOOLS/api/public/stock_zh_a_daily` | 带市场前缀代码（sh/sz/bj） | `list[dict]`（新浪字段） |
| `fetch_spot_code_name_rows()` | `AKTOOLS/api/public/stock_zh_a_spot_em` | 无 | `list[dict]`（实时行情含代码/名称） |
| `fetch_basic_code_name_rows()` | `AKTOOLS/api/public/stock_info_a_code_name` | 无 | `list[dict]`（基础代码名录） |

模块级工具函数：

| 函数 | 作用 |
|---|---|
| `rolling_window_for_trading(days=420)` | 返回 `(start_yyyymmdd, end_yyyymmdd)`，默认给一个足够覆盖 ~120 交易日的宽窗口 |
| `_request_rows(url, params)` | 内部：GET 请求 + JSON 解码 + 类型校验 |

### `CanghaiClient`（canghai_client.py）

| 方法 | 上游端点 | 入参 | 返回 |
|---|---|---|---|
| `fetch_canghai_daily(exchange_code, ticker, start_date, end_date)` | `TSANGHI/api/fin/stock/{exchange_code}/daily` | 交易所代码（XSHG/XSHGB/XSHE/XSHEB/BJSE）+ 6 位代码 + `YYYY-MM-DD` | `list[dict]`（沧海字段） |

- 请求需带 `token`（取自 `app.config.TSANGHI_API_TOKEN`）。
- 沧海返回可能是裸 list，也可能是 `{"data": [...]}` 或错误体；客户端做了三分支兼容。

## 错误语义

- 上游 HTTP 状态 >= 400 → `RuntimeError("...failed with status N...")`
- 沧海返回非 list 且无 `data` → `RuntimeError("Canghai upstream returned error payload: ...")`
- 缺少 `TSANGHI_API_TOKEN` → `RuntimeError`

`services` 层会捕获这些 `RuntimeError` 做降级。

## 依赖关系

依赖：`urllib`、`json`、`app.config`

被依赖：`app.main`（装配）、`app.services.daily_service`（业务调用）

## 扩展流程

新接入一个数据源（如富途、同花顺）：
1. 在本目录新增 `<source>_client.py`，暴露 `fetch_<source>_daily(...)` 方法
2. 错误统一抛 `RuntimeError`
3. 在 `services-daily.md` 文档的降级序列中记录新顺序
4. 在本文件「关键文件」与「对外接口」追加条目

## 变更日志

- 2026-04-20: 初始化文档；当前 2 个 provider：Aktools（双子方法）+ Canghai。
- 2026-04-21: `AktoolsClient` 新增代码名录双端点（spot 主源 + basic 降级）以支撑名称匹配。
