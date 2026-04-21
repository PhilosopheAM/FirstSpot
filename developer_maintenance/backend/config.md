# backend/config — 运行时配置

## 模块职责

从环境变量读取运行时配置；提供合法性校验与默认值。所有下游模块通过 `from app.config import <X>` 取值。

## 关键文件

| 路径 | 作用 |
|---|---|
| `datafetcher/app/config.py` | 解析环境变量，导出常量；内部函数 `_int_env()` 提供类型校验 |

## 对外接口（导出常量）

| 常量 | 环境变量 | 默认值 | 用途 |
|---|---|---|---|
| `AKTOOLS_BASE_URL` | `AKTOOLS_BASE_URL` | `http://127.0.0.1:8080` | AKTools 本地服务地址 |
| `REQUEST_TIMEOUT_SECONDS` | `REQUEST_TIMEOUT_SECONDS` | `20` | HTTP 请求超时（秒） |
| `DEFAULT_LIMIT` | `DEFAULT_LIMIT` | `120` | 日线默认返回条数 |
| `MAX_LIMIT` | `MAX_LIMIT` | `240` | 日线单次请求上限 |
| `TSANGHI_BASE_URL` | `TSANGHI_BASE_URL` | `https://tsanghi.com` | 沧海数据服务地址 |
| `TSANGHI_API_TOKEN` | `TSANGHI_API_TOKEN` | 硬编码兜底 token | 沧海 API 鉴权 |

> **安全提示**：`TSANGHI_API_TOKEN` 当前有硬编码默认值，生产环境必须通过环境变量覆盖。建议后续迁移到 `.env` + `pydantic-settings`。

## 依赖关系

依赖：仅 `os`

被依赖：`app.main`、`app.providers.aktools_client`、`app.providers.canghai_client`

## 变更日志

- 2026-04-20: 初始化文档；当前共 6 个配置项，其中 2 项用于 AKTools，4 项用于沧海 / 通用。
