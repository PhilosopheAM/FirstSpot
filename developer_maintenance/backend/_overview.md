# 后端总览 (datafetcher)

## 模块职责

`datafetcher/` 是一个独立的 Python + FastAPI 服务，负责将 Flutter 前端请求转发给上游数据源（AKTools / 沧海），并统一字段、多源降级、截断返回。**不做本地缓存**。

## 架构分层

```text
Flutter (testapp)
      │  HTTP
      ▼
┌────────────────────────────────────────────────┐
│  FastAPI 入口  (app/main.py)                    │
│  └─ 路由 /api/v1/stocks/{symbol}/daily          │
│     ↓ 调用                                      │
│  Service 层 (app/services/daily_service.py)    │
│  └─ 多源降级：东财 → 新浪 → 沧海                 │
│  └─ 字段标准化、日期规范化、按 limit 截断        │
│     ↓ 调用                                      │
│  Provider 层 (app/providers/*.py)              │
│  ├─ AktoolsClient    (本地 AKTools 8080)        │
│  └─ CanghaiClient    (Tsanghi 云端)             │
└────────────────────────────────────────────────┘
```

## 模块关系

| 模块 | 职责 | 依赖 | 文档 |
|---|---|---|---|
| `main.py` | FastAPI 应用与路由装配 | config, models, services, providers | `main.md` |
| `config.py` | 环境变量配置 | `os` | `config.md` |
| `models.py` | Pydantic 响应模型 | `pydantic` | `models.md` |
| `providers/` | 第三方数据源 HTTP 客户端 | config | `providers.md` |
| `services/daily_service.py` | 日线降级、标准化、截断 | models, providers | `services-daily.md` |
| `tests/` | pytest 测试 | app 所有模块 | `tests.md` |

## 启动方式

```bash
cd datafetcher
pip install -r requirements.txt
python -m aktools --host 127.0.0.1 --port 8080         # 先启动 AKTools
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

## 扩展点

新增第三方数据源时：
1. 在 `app/providers/` 新增 `<source>_client.py`
2. 在 `app/services/daily_service.py` 的降级序列中加一层 `try/except`
3. 在 `normalize_<source>_rows()` 实现字段映射
4. 其它模块（`models.py`、`main.py`）不动，保持 Flutter 无感升级
5. 更新 `providers.md` 和 `services-daily.md`

## 变更日志

- 2026-04-20: 初始化文档。现有模块：main / config / models / providers(AKTools, Canghai) / services(daily) / tests。
