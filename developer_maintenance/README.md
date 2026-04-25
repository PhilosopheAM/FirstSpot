# FirstSpot 代码维护说明（developer_maintenance）

本目录是 **FirstSpot 代码库的可维护性文档**，按功能模块拆分。
每个 `.md` 对应一个模块（前端 feature 或后端 module），说明其职责、关键文件、对外接口、依赖关系与变更日志。

## 目录组织

```text
developer_maintenance/
├── README.md                 # 本文件：索引 + 维护规则
├── backend/                  # 后端 (datafetcher) 模块文档
│   ├── _overview.md          #   后端整体架构
│   ├── main.md               #   FastAPI 入口 (app/main.py)
│   ├── config.md             #   运行时配置 (app/config.py)
│   ├── models.md             #   响应模型 (app/models.py)
│   ├── providers.md          #   第三方数据客户端 (app/providers/*)
│   ├── services-daily.md     #   日线数据服务 (app/services/daily_service.py)
│   └── tests.md              #   测试说明 (tests/*)
└── frontend/                 # 前端 (testapp) 功能文档
    ├── _overview.md          #   前端整体架构
    ├── app-entry.md          #   main.dart 与首开分流
    ├── feature-learning-guidance.md # 投资者教育 12 章课程
    ├── feature-onboarding.md #   首开引导功能
    └── feature-stock-insight.md # 个股信息页功能
```

## 命名约定

- **后端**：按**代码文件**划分。一个 `app/<path>/<file>.py` 对应一个 `backend/<name>.md`
- **前端**：按**功能模块（feature）**划分，而非单文件。一个 `testapp/lib/features/<feature>/` 对应一个 `frontend/feature-<name>.md`
- 总览文件以 `_overview.md` 命名（下划线前缀使其在排序中置顶）
- 基础设施 / 入口文件独立成文（如 `backend/main.md`、`frontend/app-entry.md`）

## 每个模块文档的固定结构

每个模块文档必须包含以下小节（顺序固定）：

1. **模块职责** — 一句话 + 简短段落
2. **关键文件** — 文件路径表格 + 每个文件的核心作用
3. **对外接口 / 调用方式** — HTTP API / Dart 类接口 / 导出符号
4. **依赖关系** — 本模块依赖谁、被谁依赖
5. **变更日志** — `YYYY-MM-DD: <改动摘要>`（倒序追加）

## 维护规则（强制）

**每次修改代码，必须在同一次改动中同步更新对应的模块文档。**

- 修改 `app/services/daily_service.py` → 必须更新 `backend/services-daily.md`
- 修改 `testapp/lib/features/onboarding/**` → 必须更新 `frontend/feature-onboarding.md`
- 新增模块文件 → 在对应 `.md` 的「关键文件」表中添加行
- 新增整个模块 → 新建 `.md` 并在本 README 的目录中登记
- 即使只是小修，也要在该文档的「变更日志」追加一行

完整规则见 `.cursor/rules/firstspot-developer-maintenance.mdc`。

## 变更日志

- 2026-04-20: 建立 `developer_maintenance/` 文档体系与配套规则。
- 2026-04-25: 新增 `frontend/feature-learning-guidance.md`，登记投资者教育 12 章课程模块。
