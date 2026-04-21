# backend/main — FastAPI 入口

## 模块职责

装配 FastAPI 应用，注册 CORS 中间件，暴露健康检查与日线接口。**不含业务逻辑**，仅做依赖注入与 HTTP 协议适配。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/app/main.py` | 唯一入口；创建 `app = FastAPI(...)`；装配 `DailyService(AktoolsClient(), CanghaiClient())`；注册两条路由 |

## 对外接口

| 方法 | 路径 | 查询参数 | 返回 |
|---|---|---|---|
| GET | `/health` | — | `{"status": "ok"}` |
| GET | `/api/v1/stocks/{symbol}/daily` | `limit` (int，默认 `DEFAULT_LIMIT`，上限 `MAX_LIMIT`) | `DailyResponse`（`symbol` 可传 6 位代码或股票名称） |

### 错误映射

| 业务异常 | HTTP 状态码 |
|---|---|
| `ValueError`（如非法 symbol） | 400 |
| `RuntimeError`（所有上游都失败） | 503 |

## 依赖关系

依赖：`fastapi`、`app.config.DEFAULT_LIMIT / MAX_LIMIT`、`app.models.DailyResponse`、`app.providers.aktools_client.AktoolsClient`、`app.providers.canghai_client.CanghaiClient`、`app.services.daily_service.DailyService`

被依赖：`uvicorn` 启动命令 `app.main:app`；前端（`testapp`）的 `StockInsightBackendApi` 最终实现

## 变更日志

- 2026-04-20: 初始化文档；当前实现注入了 Aktools + Canghai 两客户端，路由两个 endpoint。
- 2026-04-21: 日线接口支持 `symbol` 使用股票名称输入（如“贵州茅台”），由 service 层做代码匹配。
