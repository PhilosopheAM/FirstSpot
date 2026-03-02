# FirstSpot 项目 Skills

本目录包含从 [anthropics/skills](https://github.com/anthropics/skills) 引入的 Agent Skills，供 Cursor AI 在 FirstSpot 项目中按需调用。

## 技能列表

| 技能 | 用途 |
|------|------|
| **skill-dispatcher** | 任务分析、技能匹配与指派（隐式触发） |
| **flutter-guide** | Flutter 学习指导（guide: 或 提问 开头触发） |
| **frontend-design** | 前端 UI 设计与实现 |
| **webapp-testing** | Web/Flutter 应用测试 |
| **theme-factory** | 主题与配色方案生成 |
| **web-artifacts-builder** | Web 组件与页面构建 |
| **mcp-builder** | MCP 服务器生成 |
| **skill-creator** | 创建自定义 Skills |
| **docx** | Word 文档创建与编辑 |
| **pdf** | PDF 处理 |
| **pptx** | PowerPoint 创建与编辑 |
| **xlsx** | Excel 表格处理 |
| **doc-coauthoring** | 文档协作 |
| **brand-guidelines** | 品牌规范 |
| **canvas-design** | Canvas 设计 |
| **algorithmic-art** | 算法艺术 |
| **internal-comms** | 内部沟通 |
| **slack-gif-creator** | Slack GIF 创建 |

## FirstSpot 推荐技能

- **skill-dispatcher**：布置任务时自动触发，分析任务并指派到合适技能（无需显式调用）
- **flutter-guide**：以 `guide:` 或 `提问` 开头提问时触发，先给简洁回答，追问时给详细新手向讲解

针对 Flutter + FastAPI 技术栈，建议优先使用：

- **frontend-design**：Flutter UI 设计与实现
- **webapp-testing**：应用测试
- **theme-factory**：主题与配色
- **skill-creator**：创建项目专用 Skills（如新建模块流程）

## 与 Rules 配合

- **firstspot-coding-standards.mdc**：代码规范
- **skill-dispatcher-trigger.mdc**：布置任务时隐式触发 skill-dispatcher
- **flutter-guide-trigger.mdc**：`guide:` 或 `提问` 开头时触发 flutter-guide

## 来源

- 仓库：https://github.com/anthropics/skills
- 许可：Apache 2.0（部分文档类技能为 source-available）
