---
name: skill-dispatcher
description: Analyzes user tasks and dispatches to appropriate skills. Use when user gives any implementation task, modification request, or feature request (e.g. 修改、实现、帮我做、添加功能、改颜色、加动画、设计、测试、创建). Applies FIRST before other skills to orchestrate task execution.
---

# Skill Dispatcher

When the user gives a task, analyze it, match to relevant skills, then execute using those skills. Do not skip this step—always run the analysis before executing.

## Workflow

1. **Parse task** (目标、涉及文件、技术栈 Flutter/Python)
2. **Match to skills** using the mapping table below
3. **List matched skills** with brief rationale
4. **Execute** by reading each matched skill and applying it to the task
5. **Report** what was done

## Task Type → Skill Mapping

| Task Type | Keywords | Skills |
|-----------|----------|--------|
| UI 修改（颜色、动画、布局、样式） | 改颜色、加动画、抖动、样式、主题 | frontend-design, theme-factory |
| 按钮/组件/控件 | 按钮、输入框、列表 | frontend-design |
| 新建页面/组件 | 创建、设计、实现 | frontend-design, web-artifacts-builder |
| 测试、验证 | 测试、验证、调试 | webapp-testing |
| 文档处理 | Word、PDF、Excel、PPT | docx, pdf, pptx, xlsx |
| 创建新 Skill | skill、规则 | skill-creator |
| MCP 相关 | MCP、服务器 | mcp-builder |
| 品牌/设计规范 | 品牌、规范 | brand-guidelines |

## Execution Steps

1. For each matched skill, read `.cursor/skills/<skill-name>/SKILL.md`
2. Follow that skill's instructions
3. Apply `.cursor/rules/firstspot-coding-standards.mdc` for code output

## Example

**User:** 修改一个按钮的颜色、加抖动效果

**Analysis:**
- Task: UI modification (color + animation)
- Matched: frontend-design (styling, animations)
- Files: Likely Flutter/Dart

**Action:** Read frontend-design, then implement color change and shake animation in the target file, following FirstSpot coding standards.
