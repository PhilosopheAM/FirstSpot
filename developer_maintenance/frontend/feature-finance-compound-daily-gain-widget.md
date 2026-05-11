# frontend/feature-finance-compound-daily-gain-widget — 复利日均收益模拟器

## 模块职责

复利日均收益模拟器帮助用户把年化收益率、持有年限、复利终值和日均收益金额拆开理解。组件保持独立状态，不依赖基金持有成本估算器。

## 关键文件

| 文件 | 作用 |
|---|---|
| `testapp/lib/features/finance_micro_widgets/pages/compound_daily_gain_page.dart` | 复利日均收益模拟器独立页面 |
| `testapp/lib/features/finance_micro_widgets/widgets/compound_daily_gain_widget.dart` | 组件 UI、本金 / 年化 / 年限连续滑杆、手动输入弹窗、复利曲线和收益拆解卡 |
| `testapp/lib/features/finance_micro_widgets/widgets/finance_micro_widget_decoration.dart` | 页面底部 Myo 毛线球装饰插画，和基金真实持有成本页面共用 |
| `testapp/lib/features/finance_micro_widgets/domain/finance_micro_widget_models.dart` | `CompoundReturnInput` 与 `CompoundReturnResult`，负责全部复利收益数学计算 |
| `testapp/test/finance_micro_widgets_test.dart` | 覆盖复利计算器手动输入弹窗关闭时的控制器生命周期问题 |
| `UX-Product-Design/V1/finance-micro-widgets-figma-prototype.md` | Figma 原型入口、节点、专业术语与设计语言记录 |

## 对外接口 / 调用方式

| 类型 / 方法 | 调用方式 | 说明 |
|---|---|---|
| `CompoundDailyGainPage` | 由首页“工具”抽屉进入 | 独立承载复利日均收益模拟器 |
| `CompoundDailyGainWidget` | 被 `CompoundDailyGainPage` 直接组合 | 对外暴露的 Flutter Widget，内部自维护本金、年化收益率、年限和手动输入状态 |
| `CompoundReturnInput.calculate()` | `CompoundReturnInput(...).calculate()` | 传入本金、预期年化收益率和 double 年限，返回复利终值、总收益、日均收益与等效日收益率 |

## 依赖关系

- UI 依赖 Flutter `Slider`、`AlertDialog`、`TextField`、`CustomPaint` 和基础布局组件。
- 公式依赖 `finance_micro_widget_models.dart`，曲线绘制单独使用 `dart:math` 根据同一参数生成视觉曲线。
- 前端设计素材来自 Figma 文件 `TlIipLw5VVIDDtvYwuHDSR`：默认总览节点 `5:2`、复利拆解状态节点 `5:86`。
- Figma 中复利曲线图片被转译为 Flutter `CustomPainter` 自绘曲线，避免依赖 7 天有效期的 Figma 临时资产 URL；页面底部使用 `myo_playing_ball_yarn.png` 作为本地装饰图。

## 前端设计素材与交互说明

- 本金、预期年化收益率、持有年限均为连续滑杆；点击每行右侧 `✎` 数值可弹出输入窗口手动输入。
- 年限由 `int` 升级为 `double`，支持 0.1 年到 30 年之间的连续情景测算。
- 顶部胶囊标签只展示当前参数快照，不再作为离散选择入口。
- 页面滚动内容底部展示 Myo 毛线球装饰插画，用于降低单页工具的空白感。

## 计算公式说明

- 复利终值：`futureValue = principal * (1 + annualReturnRate) ^ years`。
- 总收益：`totalGain = futureValue - principal`。
- 预计持有天数：`totalDays = years * 365`，其中 `years` 支持小数年限。
- 日均收益金额：`averageDailyGain = totalGain / totalDays`。
- 等效日收益率：`equivalentDailyReturnRate = (1 + annualReturnRate) ^ (1 / 365) - 1`。
- 原型核验：`本金 ¥10,000、年化 6%、5 年` 时，复利终值约 `¥13,382.26`，总收益约 `¥3,382.26`，`3,382.26 / 1,825 ≈ ¥1.85 / 天`，等效日收益率精确约 `0.01597%`；Figma 标注 `0.01595%` 为轻微显示误差，不影响核心复利终值与日均收益金额。

## 变更日志

- 2026-04-29: 修复复利计算器手动输入本金后 `TextEditingController` 在弹窗退出动画期间被提前释放的问题；输入弹窗改为 StatefulWidget 自管理 controller 生命周期，并新增 widget 测试覆盖。
- 2026-04-29: 独立页面底部加入共享 Myo 毛线球装饰插画。
- 2026-04-29: 本金、年化收益率和持有年限改为连续滑杆并支持点击数值弹窗手动输入；年限模型从 `int` 升级为 `double`。
- 2026-04-29: 新增复利日均收益模拟器维护文档，登记代码实现、Figma 设计来源、素材转译方式与公式核验结论。
