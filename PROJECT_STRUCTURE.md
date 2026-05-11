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
├── 毕业论文_Tempo/            # 毕业论文过程材料、任务书、开题/中期资料与论文批注修改稿
├── developer_maintenance/    # 代码维护说明（按模块拆分的 .md）
├── .cursor/                  # Cursor 规则、技能、计划
├── README.md                 # 项目简介
├── LICENSE                   # 开源协议
├── .gitignore                # 根目录临时验证产物忽略规则
└── PROJECT_STRUCTURE.md      # 本文档
```

---

## 2. 各顶层目录详解

### 2.1 `datafetcher/` — 后端

```text
datafetcher/
├── app/                      # FastAPI 应用主体（路由 / 服务 / 模型）
│   ├── main.py               #   HTTP 入口：健康检查、日线接口、个股洞察聚合接口
│   ├── models.py             #   Pydantic 响应模型：日线与 StockInsightResponse
│   ├── providers/            #   AKTools / Canghai 第三方数据源客户端
│   └── services/             #   DailyService 与 StockInsightService
├── tests/                    # 后端单元测试 / 集成测试；含 stock insight 聚合服务测试
├── requirements.txt          # Python 依赖清单
├── README.md                 # 后端启动与开发说明
└── aktools_log.log           # akshare 运行日志（应加入 .gitignore）
```

职责：行情 / 新闻 / 基本面数据的抓取、清洗、缓存、对外 API 推送。

### 2.2 `testapp/` — 前端 Flutter

```text
testapp/
├── lib/                      # Dart 源代码（应用主体）
│   └── features/             #   按业务模块切分
│       ├── finance_micro_widgets/ # 金融工具：持有成本估算器与复利收益模拟器
│       │   ├── pages/        #     两个工具的独立页面入口
│       │   ├── widgets/      #     两个工具的独立交互组件
│       │   └── domain/       #     持有成本与复利收益公式模型
│       ├── learning_guidance/ #     投资者教育 12 章课程、题库、Myo 练习反馈与收藏状态
│       ├── onboarding/       #     首开引导与首页
│       └── stock_insight/    #     个股信息页
├── test/                     # Flutter 测试；含 finance_micro_widgets_test.dart 与 stock_insight_template_page_test.dart
├── assets/audio/             # App 内音效；含 onboarding 与 learning_guidance 音频
├── assets/images/characters/myo/ # Myo 表情与装饰素材，供学习讲解、反馈和金融小组件复用
├── assets/images/guidance_cards/ # 投资者教育 12 章线条风格卡片图
├── assets/images/learning_guidance/ # 投资者教育章末练习背景与通过/重练插画
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
│   ├── first-open-onboarding.md            # V1 首开引导结构层（页面列表 / 元素清单）
│   ├── Gamified_Onboarding_Design.md       # V1 游戏化设计（Duolingo-style，面向 Z 世代 16-28）
│   ├── stock-detail-page-design.md         # V1 个股/基金详情页极简 UX 设计文档
│   ├── finance-micro-widgets-figma-prototype.md # V1 金融小组件 Figma 原型入口、节点与交互维护文档
│   └── long-term-holding-compound-confidence-figma-prototype.md # V1 长期持仓复利信心页 Figma 原型维护文档
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
    ├── 12_搭建你的稳健组合.md
    ├── 13_12章练习交互细化与素材清单.md #   12 章 Myo 对话、题库审计与素材提示词
    ├── 14_先教育再小测学习闭环与素材补全记录.md # V1.2 学习闭环与素材缺口维护记录
    ├── 15_12章概念聊天对话与首章实装.md # 12 章概念路径图方法论、50 轮上限与全章概念聊天脚本记录
    ├── 16_12章概念对话文本与术语维护稿.md # 12 章概念对话文本稿与专业术语独立维护板块
    └── 17_12章节奖励节点与美术提示词.md # 12 章奖励节点、奖励内容与 Myo 专属徽章缺口提示词
```

职责：产品设计文档、用户流程、交互草案、版本迭代记录。新版本开 `V2/`、`V3/` 子目录。
`guidance/` 用于投资者教育学习内容框架（章节脚本 + UX 流程 + 重要概念卡片设计），每章独立一个 `.md` 文件，文件命名格式 `<章节序号>_<章节标题>.md`。

### 2.4 `Design_Resource/` — 美术与音频资源

```text
Design_Resource/
├── UI_design_resource/       # UI 美术资源
│   ├── characters/myo/       #   Myo 角色插画成品；含金融小组件底部装饰图
│   ├── guidance_cards/       #   投资者教育 12 章线条风格主视觉与预览拼图
│   ├── learning_guidance/    #   投资者教育章末练习背景图、通过页与重练页插画
│   ├── guidance_rewards/     #   投资者教育收藏奖励规则与历史素材提示词归档
│   └── reference/            #   创意参考图 / 灵感板
└── Sound_design_resource/    # 音效 / 音频资源
    ├── guidance_*.wav        # 投资者教育学习闭环实装音效
    └── guidance_learning_audio_prompts.md # 投资者教育学习闭环缺失音效提示词
```

- `**UI_design_resource/**`：所有通过图像生成模型（Nano Banana、Midjourney 等）产出的 UI 资源统一放这里。代码中引用 UI 图片一律指向此目录。
- `**Sound_design_resource/**`：软件内所有音效、BGM、语音片段。前端 `testapp/` 加载音频时从此处引用或拷贝到 `assets/`。
- `**reference/**`：非成品的创意参考图 / 灵感板（不直接进入产品）。

### 2.5 `Reading_Material/` — 参考文献

存放论文 / 专著 PDF，以及与论文配套的阅读笔记（Markdown），供产品与技术决策参考。当前收录：

- `designing-user-experience-a-guide-to-hci-ux-and-interaction-design.pdf`
- `Internet of Gamification A Review of Literature on IoT enabled Gamification for User Engagement.pdf`
- `游戏化实战.pdf`
- `投资者教育App_游戏化交互设计原则与方法.md`

### 2.6 `毕业论文_Tempo/` — 毕业论文材料

存放本科毕业设计（论文）过程材料，包括任务书、开题报告、中期材料、指导老师批注版论文、批注修改建议稿与后续论文修订过程文件。当前重点子目录：

```text
毕业论文_Tempo/
└── Bachelor_Graduation/      # 本科毕业论文任务书、开题/中期材料、论文初稿与批注修改建议
```

新增论文修订辅助文档：

- `Bachelor_Graduation/论文批注修改建议与插入稿.md`：基于指导老师 Word 批注生成的 Markdown 修改建议，包含插入位置、建议文本、图示文字描述与参考文献二次审查记录。

### 2.7 `developer_maintenance/` — 代码维护说明

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
│   ├── services-stock-insight.md
│   └── tests.md
└── frontend/                 # 前端功能文档（按 feature 划分）
    ├── _overview.md
    ├── app-entry.md
    ├── feature-finance-compound-daily-gain-widget.md
    ├── feature-finance-holding-cost-widget.md
    ├── feature-finance-micro-widgets.md
    ├── feature-learning-guidance.md
    ├── feature-onboarding.md
    └── feature-stock-insight.md
```

职责：每个 `.md` 记录一个模块的职责、关键文件、对外接口、依赖关系和变更日志。**每次改代码都要同步更新对应文档**（由 `.cursor/rules/firstspot-developer-maintenance.mdc` 强制）。

### 2.8 `.cursor/` — Cursor 配置

```text
.cursor/
├── rules/                    # 项目规则（.mdc 文件，本文档由规则同步）
├── skills/                   # 技能脚本 / 工具
└── plans/                    # AI 协作计划文档
```

---

## 3. 根目录文件清单


| 文件                     | 用途            | 是否入 Git |
| ---------------------- | ------------- | ------- |
| `README.md`            | 项目简介          | 是       |
| `LICENSE`              | 开源协议          | 是       |
| `.gitignore`           | 根目录临时验证产物忽略规则 | 是       |
| `PROJECT_STRUCTURE.md` | 本文档           | 是       |


根目录**不允许**存放：临时测试文件、运行日志、个人 dump、散落图片 / 音频。若发现违规，按第 4 节规则归位后更新本文档。

---

## 4. 新产物归属决策表


| 新产物类型                      | 必须放入                                     |
| -------------------------- | ---------------------------------------- |
| 图像生成模型输出（PNG/JPG/SVG）      | `Design_Resource/UI_design_resource/`    |
| 音效 / BGM / 语音（MP3/WAV/OGG） | `Design_Resource/Sound_design_resource/` |
| Python 后端代码                | `datafetcher/app/`                       |
| Flutter 前端代码               | `testapp/lib/features/<feature>/`        |
| UX 设计文档                    | `UX-Product-Design/V<N>/`                |
| 参考文献 PDF                   | `Reading_Material/`                      |
| Cursor 规则 `.mdc`           | `.cursor/rules/`                         |


---

## 5. 变更日志

追加格式：`YYYY-MM-DD: <简要描述>`

- 2026-04-20: 初始化 `PROJECT_STRUCTURE.md`，规范顶层目录职责。
- 2026-04-20: 清理根目录：删除 `test.md`、`docx_dump.json`、根目录 `aktools_log.log`；将 `创意参考图/` 合并到 `Design_Resource/UI_design_resource/reference/`。
- 2026-04-20: 新增 `.cursor/rules/firstspot-structure-maintenance.mdc` 强制结构维护规则。
- 2026-04-20: 新增 `developer_maintenance/` 代码维护文档体系（backend/ + frontend/ 共 12 个 .md），并新增 `.cursor/rules/firstspot-developer-maintenance.mdc` 强制每次代码改动同步更新对应模块文档。
- 2026-04-20: 新增 `UX-Product-Design/guidance/` 投资者教育学习框架目录，含 1 份总览 + 12 章内容脚本（配套重要概念卡片 CARD-01 ~ CARD-12，按白/蓝/紫/金四级稀有度分布）。
- 2026-04-21: 新增 `UX-Product-Design/V1/Gamified_Onboarding_Design.md` 游戏化首开引导设计文档（Duolingo-inspired，Gen Z 16-28 目标人群，定义 Myo（喵）IP / FP-XP / Streak / 耐心值 / 双货币 / 成长小组 / 成就墙 / 小金库路径 / Myo 推送人格 共 10 大机制 + 6 步首开流程）。
- 2026-04-24: 首开启动动效改为 `testapp/assets/animations/myo_wave_frames/` 透明 PNG 序列帧逐帧播放方案；生成脚本位于 `tools/generate_myo_wave_frames.ps1`，详细维护说明见 `developer_maintenance/frontend/feature-onboarding.md` 与 `developer_maintenance/frontend/app-entry.md`。
- 2026-04-28: 导入并处理了缺失的 `myo_quiz_correct_micro.png`、`myo_quiz_retry_micro.png` 图像及 `quiz_correct_soft_chime_01.wav` 等音频素材，存放在 `Design_Resource/` 并同步至 `testapp/assets/`。在 `MyoPracticeBlock` 和首开引导中实装了答对/答错反馈音效与头像。
- 2026-04-25: 导入并处理了缺失的音效和图像素材（去底透明化），存放在 `Design_Resource/` 并同步至 `testapp/assets/`。更新了 `onboarding_lesson_step.dart` 以使用真实素材。重构了 `onboarding_lesson_step.dart`，将其全部 3 个关卡的交互统一为类似微信的连续聊天流（Chat Flow）形式，增强了交互反馈感。
- 2026-04-25: 新增 `UX-Product-Design/guidance/13_12章练习交互细化与素材清单.md`，集中维护 12 章 Myo 对话叙事、章末练习固定交互、48 道题库审计与缺失素材提示词。
- 2026-04-25: 新增 `testapp/lib/features/learning_guidance/` 投资者教育课程模块，接入 12 章内容、48 道练习与 `assets/images/guidance_cards/` 线条风格素材；新增 `developer_maintenance/frontend/feature-learning-guidance.md`。
- 2026-04-25: 新增根目录 `.gitignore`，忽略 Dart/Flutter 沙箱验证产生的 `.dart_appdata/` 临时目录。
- 2026-04-25: 更新 `.cursor/rules/firstspot-developer-maintenance.mdc`，强化“所有代码路径必须定位模块文档并同步维护”的规则；清理根目录临时素材处理脚本 `process_assets.py`。
- 2026-04-25: 新增 `testapp/lib/features/onboarding/widgets/xp_flyup.dart`，统一 onboarding 内 `+N XP` 右上角向上飘动奖励反馈，替代底部 SnackBar。
- 2026-04-25: 新增 `UX-Product-Design/guidance/14_先教育再小测学习闭环与素材补全记录.md` 与 `Design_Resource/Sound_design_resource/guidance_learning_audio_prompts.md`，记录 12 章投资者教育“先教育、再小测、奖励通行证”闭环、缺失美术提示词和音频提示词。
- 2026-04-25: 复制 Myo 表情素材到 `testapp/assets/images/characters/myo/`，新增学习页金融术语高亮解释组件与术语表文件。
- 2026-04-25: 从 `T:\Tempo_Files\FirstSpot_Assets` 导入 6 个 `guidance_*.wav` 投资者教育学习闭环音效，归档到 `Design_Resource/Sound_design_resource/` 并同步到 `testapp/assets/audio/` 接入前端播放。
- 2026-04-25: 从 `T:\Tempo_Files\FirstSpot_Assets` 导入 8 张投资者教育章末练习图片，归档到 `Design_Resource/UI_design_resource/learning_guidance/` 并同步到 `testapp/assets/images/learning_guidance/`。
- 2026-04-25: 新增 `UX-Product-Design/guidance/15_12章概念聊天对话与首章实装.md` 与 `guidance_concept_dialogues.dart`，维护 12 章概念聊天脚本，并在 CH01 概念卡实装 Myo 聊天框入口、上方飞入动画、返回续学和术语词卡解释。
- 2026-04-25: 新增 `testapp/lib/features/onboarding/pages/vault_page.dart`，在首开完成后的用户主页底部提供 `🏛️ 金库` 入口，用于左右滑动查看已获得概念卡。
- 2026-04-28: 更新 `UX-Product-Design/guidance/15_12章概念聊天对话与首章实装.md` 为 12 章概念路径图方法论文档，记录 50 轮上限和全章节概念聊天重构。
- 2026-04-28: 新增 `UX-Product-Design/guidance/16_12章概念对话文本与术语维护稿.md`，从代码中抽取 12 章概念对话脚本与专业术语词表，作为后续文本生成代码流程的维护稿。
- 2026-04-28: 更新 `testapp/lib/features/learning_guidance/` 第一章案例互动，将 CH01 “案例”改为 Myo 引导的滚动式 IPO 股份旅程讲解，并补充 IPO、承销商、打新、破发等术语解释与测试覆盖。
- 2026-04-28: 从 `G:\Tempo\FirstSpot_Tempo\myo_lay_face_smile.png` 移入 Myo 角色设计资源并同步至 Flutter 资产目录，作为 CH01 IPO 案例讲解页底部登场图。
- 2026-04-28: 新增 `Reading_Material/投资者教育App_游戏化交互设计原则与方法.md`，沉淀投资者教育 App 游戏化交互设计的体系化原则与方法笔记。

- 2026-04-28: 将 CH01 IPO 案例讲解从“点击向下箭头”改为“拖拽下一位参与方进入上一幕”的推进方式；每幕弹出后 Myo 会再次从底部滑入并顶出可长按拖拽的参与方卡片，拖拽时上一幕卡片边框脉冲高亮，放入成功后自动弹出下一幕并在完成后点亮案例步骤；同步更新 widget 测试为长按拖拽流程。
- 2026-04-28: 新增 `UX-Product-Design/guidance/17_12章节奖励节点与美术提示词.md`、`Design_Resource/UI_design_resource/guidance_rewards/README.md` 和 `guidance_rewards.dart`，为 12 章投资者教育配置奖励内容、奖赏节点、XP、替代 badge 与 Myo 专属奖励图生成提示词。
- 2026-04-29: 重构投资者教育收藏奖励为“章节完成得卡片、5 个首次里程碑得徽章”；新增 `guidance_user_progress.dart` 通过本地偏好维护首次状态，金库新增“卡片 / 徽章”底部切换并共用滑动展示逻辑。
- 2026-04-28: 新增 `UX-Product-Design/V1/stock-detail-page-design.md`，定义了面向小白用户的极简个股/基金详情页 UX 设计（包含价格走势、核心统计卡片、分析师评级仪表盘、财务柱状图等）。
- 2026-04-29: 新增 `UX-Product-Design/V1/finance-micro-widgets-figma-prototype.md`，记录金融小组件 Figma 原型链接、文件 Key、可播放节点、组件术语与下次继续编辑步骤。
- 2026-04-29: 新增 `testapp/lib/features/finance_micro_widgets/` 金融小组件 feature，并新增对应入口与两个组件级维护文档。
- 2026-04-29: `finance_micro_widgets` 移除双组件总览页，新增 `effective_holding_cost_page.dart` 与 `compound_daily_gain_page.dart` 两个独立工具页面。
- 2026-04-29: 导入 `myo_playing_ball_yarn.png` 到 `Design_Resource/UI_design_resource/characters/myo/` 并同步到 `testapp/assets/images/characters/myo/`，用于金融小组件页面底部装饰。
- 2026-04-29: 新增 `testapp/test/stock_insight_template_page_test.dart`，覆盖个股窗口返回按钮与时间窗口切换；同步修复个股窗口返回和时间筛选交互。
- 2026-04-29: 新增 `testapp/test/finance_micro_widgets_test.dart`，覆盖复利计算器本金手动输入弹窗关闭流程；同步修复弹窗 `TextEditingController` 生命周期。
- 2026-04-30: 新增 `datafetcher/app/services/stock_insight_service.py` 与 `datafetcher/tests/test_stock_insight_service.py`，后端提供 `/api/v1/stocks/{symbol}/insight` 个股洞察聚合接口；同步新增 `developer_maintenance/backend/services-stock-insight.md`。
- 2026-04-30: 新增 `UX-Product-Design/V1/long-term-holding-compound-confidence-figma-prototype.md`，记录长期持仓复利信心页 Figma 原型入口、节点、计算口径与后续交互方向。
- 2026-05-11: 新增 `毕业论文_Tempo/Bachelor_Graduation/论文批注修改建议与插入稿.md`，整理指导老师论文批注对应的正文插入稿、图示文字描述与参考文献二次审查记录，并补充 `毕业论文_Tempo/` 目录职责说明。
