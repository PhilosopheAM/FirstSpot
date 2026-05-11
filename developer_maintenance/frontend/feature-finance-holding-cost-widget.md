# frontend/feature-finance-holding-cost-widget — 基金真实持有成本估算器

## 模块职责

基金真实持有成本估算器帮助用户理解管理费、托管费、销售服务费等持续性费率会随持有天数累积成真实成本。组件保持独立状态，不依赖复利收益模拟器。

## 关键文件

| 文件 | 作用 |
|---|---|
| `testapp/lib/features/finance_micro_widgets/pages/effective_holding_cost_page.dart` | 基金真实持有成本估算器独立页面 |
| `testapp/lib/features/finance_micro_widgets/widgets/effective_holding_cost_widget.dart` | 组件 UI、四个连续滑杆、手动输入弹窗、费用占比可视化、Myo 风险提示与复位按钮 |
| `testapp/lib/features/finance_micro_widgets/widgets/finance_micro_widget_decoration.dart` | 页面底部 Myo 毛线球装饰插画，和复利日均收益页面共用 |
| `testapp/lib/features/finance_micro_widgets/domain/finance_micro_widget_models.dart` | `HoldingCostInput` 与 `HoldingCostResult`，负责全部持有成本数学计算 |
| `UX-Product-Design/V1/finance-micro-widgets-figma-prototype.md` | Figma 原型入口、节点、专业术语与设计语言记录 |

## 对外接口 / 调用方式

| 类型 / 方法 | 调用方式 | 说明 |
|---|---|---|
| `EffectiveHoldingCostPage` | 由首页“工具”抽屉进入 | 独立承载基金真实持有成本估算器 |
| `EffectiveHoldingCostWidget` | 被 `EffectiveHoldingCostPage` 直接组合 | 对外暴露的 Flutter Widget，内部自维护滑杆和手动输入状态 |
| `HoldingCostInput.calculate()` | `HoldingCostInput(...).calculate()` | 传入本金、三类年化费率和持有天数，返回费用拆分与总费用 |

## 依赖关系

- UI 依赖 Flutter `Slider`、`SliderTheme`、`AlertDialog`、`TextField`、`Container`、`TextButton` 和 `Row/Column`。
- 公式依赖 `finance_micro_widget_models.dart`，UI 不直接手写成本公式。
- 前端设计素材来自 Figma 文件 `TlIipLw5VVIDDtvYwuHDSR`：默认总览节点 `5:2`、成本敏感状态节点 `5:51`。
- Figma 中滑杆手柄等远程临时资产被转译为 Flutter 原生滑杆、文字 Myo 提示框和费用堆叠条；页面底部使用 `myo_playing_ball_yarn.png` 作为本地装饰图。

## 前端设计素材与交互说明

- 三类费率与持有期均为连续滑杆；点击每行右侧 `✎` 数值可弹出输入窗口手动输入。
- 手动输入弹窗由内部 `StatefulWidget` 持有 `TextEditingController`，确保键盘收起和弹窗退出动画期间不会访问已释放的输入控制器。
- 页面滚动内容底部展示 Myo 毛线球装饰插画，用于降低单页工具的空白感。
- 费用占比可视化使用一条彩色横向比例条：管理费为绿 / 高成本红、托管费为蓝、销售服务费为橙，并在下方显示各自占总费用百分比。
- 高成本状态继续展示 Myo 风险提示，不制造收益承诺或交易引导。

## 计算公式说明

- 持续性费率：`ongoingChargeRate = managementFeeRate + custodianFeeRate + salesServiceFeeRate`。
- 持有期总费用：`totalCost = principal * ongoingChargeRate * holdingDays / 365`。
- 单项费用：`itemCost = principal * itemRate * holdingDays / 365`。
- 持有期折算成本率：`holdingPeriodRate = ongoingChargeRate * holdingDays / 365`。
- 原型核验：默认 `¥35.51` 在 `本金 ¥10,000、持续性费率 1.80%、持有 72 天` 下成立；成本敏感状态里 `2.60% 年化、180 天、¥10,000` 应为约 `¥128.22`，Figma 红色结果 `¥49.31` 与公式不一致，代码按公式修正。

## 变更日志

- 2026-04-29: 独立页面底部加入共享 Myo 毛线球装饰插画。
- 2026-04-29: 修复手动输入费率弹窗关闭时提前释放 `TextEditingController` 导致的 Flutter widget 断言崩溃。
- 2026-04-29: 完善费用占比可视化，三类费率和持有期改为连续滑杆，并支持点击数值弹窗手动输入。
- 2026-04-29: 新增基金真实持有成本估算器维护文档，登记代码实现、Figma 设计来源、素材转译方式与公式核验结论。
