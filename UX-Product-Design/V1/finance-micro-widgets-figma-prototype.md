# FirstSpot 金融小组件 Figma 原型维护文档 (V1)

## 1. Figma 访问入口

- **Figma 文件**：[FirstSpot Finance Micro Widgets Prototype](https://www.figma.com/design/TlIipLw5VVIDDtvYwuHDSR)
- **文件 Key**：`TlIipLw5VVIDDtvYwuHDSR`
- **创建日期**：2026-04-29
- **用途**：维护面向新手投资者的金融计算小组件原型，包括基金持有成本估算、复利日均收益拆解与交互设计原则。

## 2. 画布结构

### 2.1 汇总展示画板

- **节点 ID**：`3:2`
- **名称**：`FirstSpot Finance Micro Widgets Prototype`
- **说明**：用于设计评审的总览画板，包含专业术语映射、三张手机状态图、交互箭头与设计原则说明。

### 2.2 可播放 Prototype 画板

Figma 原型播放时优先使用以下顶层画板：


| 场景     | 节点 ID  | Figma 层名称               | 交互说明                   |
| ------ | ------ | ----------------------- | ---------------------- |
| 双组件总览  | `5:2`  | `Playable 01 / 总览`      | 起始页，展示成本估算器与复利模拟器      |
| 成本敏感状态 | `5:51` | `Playable 02 / 拖动管理费率后` | 从管理费率滑杆触发，展示费率升高后的成本变化 |
| 复利拆解状态 | `5:86` | `Playable 03 / 复利拆解`    | 从复利卡片触发，展示复利终值与日均收益拆解  |


### 2.3 当前 Prototype 连线

- `5:20`：`Prototype drag handle / management fee`，`ON_DRAG` 跳转到 `5:51`。
- `5:36`：`Widget / Daily equivalent return`，点击跳转到 `5:86`。
- `5:84`：`Prototype click target / reset to overview`，点击返回 `5:2`。
- `5:112`：`Prototype click target / back to overview`，点击返回 `5:2`。

## 3. 组件专业命名

### 3.1 基金真实持有成本估算器

- **中文名称**：基金真实持有成本估算器 / 基金持有期总费用估算器
- **英文表达**：`Estimated Total Holding Cost` / `Effective Holding Cost`
- **核心变量**：
  - 管理费率：`Management Fee`
  - 托管费率：`Custodian Fee`
  - 销售服务费率：`Sales Service Fee`
  - 持有期：`Holding Period`
  - 持续性费率：`Ongoing Charges`
- **当前原型公式**：`持有期费用 ≈ 本金 × 持续性费率 × 持有天数 / 365`
- **可视化方式**：滑杆 + 费用堆叠条 + 即时金额结果。

### 3.2 复利日均收益模拟器

- **中文名称**：复利日均收益模拟器 / 年化收益率情景模拟器
- **英文表达**：`Average Daily Gain under Compounding` / `Expected Annualized Return Scenario`
- **核心变量**：
  - 本金：`Principal`
  - 预期年化收益率：`Expected Annualized Return`
  - 持有年限：`Investment Horizon`
  - 复利终值：`Future Value`
  - 等效日收益率：`Daily Equivalent Return`
  - 日均收益金额：`Average Daily Gain`
- **当前原型公式**：`等效日收益率 = (1 + 年化收益率)^(1/365) - 1`
- **可视化方式**：年限胶囊标签 + 复利曲线 + 终值与日均收益拆解卡。

## 4. FirstSpot 设计语言对齐

- **色彩**：沿用项目主绿 `#1FA95B`、强调绿 `#1ACC4D`、风险红 `#E53333`、奶白底 `#FFF9F0` 与浅绿信息底 `#E8F5E9`。
- **形态**：大圆角卡片、轻阴影、少网格线、卡片内强留白。
- **互动**：拖拽滑杆、点击卡片、状态切换箭头，强调“可操作的解释器”而非静态计算器。
- **角色 IP**：保留 Myo（喵）作为陪伴式解释角色，只解释成本、风险与公式，不制造交易冲动。
- **合规语气**：明确使用“情景测算，不代表承诺收益；真实收益会波动”等提示。

## 5. Flutter 实装与公式核验

- **实装入口**：首页底部 `🧮 工具` 弹出抽屉式选择器，分别进入 `effective_holding_cost_page.dart` 与 `compound_daily_gain_page.dart` 两个独立页面。
- **持有成本估算器**：`effective_holding_cost_widget.dart` + `HoldingCostInput.calculate()`。
  - 公式：`持有期费用 = 本金 × (管理费率 + 托管费率 + 销售服务费率) × 持有天数 / 365`。
  - 核验：默认 `¥35.51` 对应 `本金 ¥10,000、持续性费率 1.80%、持有 72 天`；成本敏感状态中 `2.60% 年化、180 天、¥10,000` 应为约 `¥128.22`，原型红色结果 `¥49.31` 与该公式不一致，代码按公式修正。
  - 交互修订：三类费率与持有期支持连续滑杆和点击数值手动输入；费用占比用彩色横向比例条与百分比图例展示。
- **复利日均收益模拟器**：`compound_daily_gain_widget.dart` + `CompoundReturnInput.calculate()`。
  - 公式：`复利终值 = 本金 × (1 + 年化收益率)^年数`；`日均收益金额 = (复利终值 - 本金) / (365 × 年数)`；`等效日收益率 = (1 + 年化收益率)^(1/365) - 1`。
  - 核验：`本金 ¥10,000、年化 6%、5 年` 时，终值约 `¥13,382`、日均收益约 `¥1.85/天`、等效日收益率精确约 `0.01597%`；原型标注 `0.01595%` 为轻微显示误差，核心终值与日均收益金额正确。
  - 交互修订：本金、年化收益率和持有年限均支持连续滑杆和点击数值手动输入；持有年限模型支持小数年。

## 6. 下次继续编辑步骤

1. 打开 Figma 文件：[https://www.figma.com/design/TlIipLw5VVIDDtvYwuHDSR](https://www.figma.com/design/TlIipLw5VVIDDtvYwuHDSR)
2. 若要评审整体设计，查看节点 `3:2`。
3. 若要播放原型，从顶层画板 `5:2` 开始。
4. 若要继续通过 Cursor/Figma MCP 修改，使用文件 Key `TlIipLw5VVIDDtvYwuHDSR`，并优先定位 `5:2`、`5:51`、`5:86` 三个可播放画板。
5. 若后续进入 Flutter 实装，可参考 `testapp/lib/features/stock_insight/` 的图表交互、`testapp/lib/features/onboarding/widgets/bouncy_button.dart` 的按压反馈，以及 `testapp/lib/features/learning_guidance/widgets/finance_term_text.dart` 的术语解释模式。

## 7. 变更日志

- 2026-04-29: 补充 Flutter 实装入口与公式核验；确认复利数值正确，并修正持有成本敏感状态的公式结果口径。
- 2026-04-29: 新增金融小组件 Figma 原型维护文档，记录访问链接、节点 ID、组件术语、Prototype 连线与后续编辑步骤。