# FirstSpot 项目结构说明

> 本文档是 FirstSpot 项目**目录结构的单一真相来源**。
> 每次新增 / 删除 / 重命名 / 移动文件或目录，都必须在同一次改动中同步更新本文档（参见底部「变更日志」）。
> 规则由 `.cursor/rules/firstspot-structure-maintenance.mdc` 强制执行。

---

## 1. 顶层布局

```text
FirstSpot/
├── datafetcher/              # 后端：数据拉取与推送 (Python + FastAPI + akshare)
├── testapp/                  # 前端：Flutter 移动端应用
├── UX-Product-Design/        # UX 产品设计资料（文档、流程、版本迭代）
├── Design_Resource/          # 美术 / 音频资源总入口
│   ├── UI_design_resource/   #   UI 美术资源（图像生成模型输出全部进入此处）
│   └── Sound_design_resource/#   音效 / 音频资源（软件内音效全部进入此处）
├── Reading_Material/         # 学术与理论参考 PDF
├── developer_maintenance/    # 代码维护说明（按模块拆分的 .md）
├── .cursor/                  # Cursor 规则、技能、计划
├── README.md                 # 项目简介
├── LICENSE                   # 开源协议
└── PROJECT_STRUCTURE.md      # 本文档
```

---

## 2. 各顶层目录详解

### 2.1 `datafetcher/` — 后端

```text
datafetcher/
├── app/                      # FastAPI 应用主体（路由 / 服务 / 模型）
├── tests/                    # 后端单元测试 / 集成测试
├── requirements.txt          # Python 依赖清单
├── README.md                 # 后端启动与开发说明
└── aktools_log.log           # akshare 运行日志（应加入 .gitignore）
```

职责：行情 / 新闻 / 基本面数据的抓取、清洗、缓存、对外 API 推送。

### 2.2 `testapp/` — 前端 Flutter

```text
testapp/
├── lib/                      # Dart 源代码（应用主体）
│   └── features/             #   按业务模块切分（如 onboarding/）
├── test/                     # Flutter 测试
├── android/ ios/ web/ windows/ macos/ linux/   # 各平台工程
├── pubspec.yaml              # Flutter 依赖声明
└── README.md                 # 前端启动说明
```

职责：FirstSpot 移动端全部 UI 与交互。新增业务模块统一放 `lib/features/<feature_name>/`。

### 2.3 `UX-Product-Design/` — UX 设计资料

```text
UX-Product-Design/
├── UX-产品分析.md             # 顶层产品分析文档
├── V1/                       # 版本 V1 设计资料
│   ├── Scratch_List/         #   各界面的草图 / 交互草案 markdown
│   └── first-open-onboarding.md
└── guidance/                 # 投资者教育学习框架（12 章 + 总览）
    ├── 00_学习框架总览.md     #   索引与收藏卡片系统总览
    ├── 01_什么是二级市场.md
    ├── 02_认识沪深北交易所与主要板块.md
    ├── 03_交易账户与基本规则.md
    ├── 04_读懂行情与基础K线.md
    ├── 05_估值入门贵和便宜怎么看.md
    ├── 06_认识一家上市公司.md
    ├── 07_风险从哪里来.md
    ├── 08_指数基金与ETF入门.md
    ├── 09_固收与现金管理.md
    ├── 10_情绪陷阱与行为偏差.md
    ├── 11_定投与长期主义.md
    └── 12_搭建你的稳健组合.md
```

职责：产品设计文档、用户流程、交互草案、版本迭代记录。新版本开 `V2/`、`V3/` 子目录。
`guidance/` 用于投资者教育学习内容框架（章节脚本 + UX 流程 + 重要概念卡片设计），每章独立一个 `.md` 文件，文件命名格式 `<章节序号>_<章节标题>.md`。

### 2.4 `Design_Resource/` — 美术与音频资源

```text
Design_Resource/
├── UI_design_resource/       # UI 美术资源
│   └── reference/            #   创意参考图 / 灵感板
└── Sound_design_resource/    # 音效 / 音频资源
```

- **`UI_design_resource/`**：所有通过图像生成模型（Nano Banana、Midjourney 等）产出的 UI 资源统一放这里。代码中引用 UI 图片一律指向此目录。
- **`Sound_design_resource/`**：软件内所有音效、BGM、语音片段。前端 `testapp/` 加载音频时从此处引用或拷贝到 `assets/`。
- **`reference/`**：非成品的创意参考图 / 灵感板（不直接进入产品）。

### 2.5 `Reading_Material/` — 参考文献

存放论文 / 专著 PDF，供产品与技术决策参考。当前收录：
- `designing-user-experience-a-guide-to-hci-ux-and-interaction-design.pdf`
- `Internet of Gamification A Review of Literature on IoT enabled Gamification for User Engagement.pdf`

### 2.6 `developer_maintenance/` — 代码维护说明

```text
developer_maintenance/
├── README.md                 # 索引 + 命名约定 + 维护规则
├── backend/                  # 后端模块文档（按代码文件划分）
│   ├── _overview.md
│   ├── main.md
│   ├── config.md
│   ├── models.md
│   ├── providers.md
│   ├── services-daily.md
│   └── tests.md
└── frontend/                 # 前端功能文档（按 feature 划分）
    ├── _overview.md
    ├── app-entry.md
    ├── feature-onboarding.md
    └── feature-stock-insight.md
```

职责：每个 `.md` 记录一个模块的职责、关键文件、对外接口、依赖关系和变更日志。**每次改代码都要同步更新对应文档**（由 `.cursor/rules/firstspot-developer-maintenance.mdc` 强制）。

### 2.7 `.cursor/` — Cursor 配置

```text
.cursor/
├── rules/                    # 项目规则（.mdc 文件，本文档由规则同步）
├── skills/                   # 技能脚本 / 工具
└── plans/                    # AI 协作计划文档
```

---

## 3. 根目录文件清单

| 文件 | 用途 | 是否入 Git |
|---|---|---|
| `README.md` | 项目简介 | 是 |
| `LICENSE` | 开源协议 | 是 |
| `PROJECT_STRUCTURE.md` | 本文档 | 是 |

根目录**不允许**存放：临时测试文件、运行日志、个人 dump、散落图片 / 音频。若发现违规，按第 4 节规则归位后更新本文档。

---

## 4. 新产物归属决策表

| 新产物类型 | 必须放入 |
|---|---|
| 图像生成模型输出（PNG/JPG/SVG） | `Design_Resource/UI_design_resource/` |
| 音效 / BGM / 语音（MP3/WAV/OGG） | `Design_Resource/Sound_design_resource/` |
| Python 后端代码 | `datafetcher/app/` |
| Flutter 前端代码 | `testapp/lib/features/<feature>/` |
| UX 设计文档 | `UX-Product-Design/V<N>/` |
| 参考文献 PDF | `Reading_Material/` |
| Cursor 规则 `.mdc` | `.cursor/rules/` |

---

## 5. 变更日志

追加格式：`YYYY-MM-DD: <简要描述>`

- 2026-04-20: 初始化 `PROJECT_STRUCTURE.md`，规范顶层目录职责。
- 2026-04-20: 清理根目录：删除 `test.md`、`docx_dump.json`、根目录 `aktools_log.log`；将 `创意参考图/` 合并到 `Design_Resource/UI_design_resource/reference/`。
- 2026-04-20: 新增 `.cursor/rules/firstspot-structure-maintenance.mdc` 强制结构维护规则。
- 2026-04-20: 新增 `developer_maintenance/` 代码维护文档体系（backend/ + frontend/ 共 12 个 .md），并新增 `.cursor/rules/firstspot-developer-maintenance.mdc` 强制每次代码改动同步更新对应模块文档。
- 2026-04-20: 新增 `UX-Product-Design/guidance/` 投资者教育学习框架目录，含 1 份总览 + 12 章内容脚本（配套重要概念卡片 CARD-01 ~ CARD-12，按白/蓝/紫/金四级稀有度分布）。
