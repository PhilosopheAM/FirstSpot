# frontend/feature-finance-micro-widgets — 金融小组件入口

## 模块职责

`finance_micro_widgets` 负责承载面向新手投资者的轻量金融计算工具。当前包含基金真实持有成本估算器与复利日均收益模拟器，入口由首页底部“工具”按钮打开抽屉式选择器，每个工具进入独立页面。

## 关键文件

| 文件 | 作用 |
|---|---|
| `testapp/lib/features/finance_micro_widgets/pages/effective_holding_cost_page.dart` | 基金真实持有成本估算器独立页面 |
| `testapp/lib/features/finance_micro_widgets/pages/compound_daily_gain_page.dart` | 复利日均收益模拟器独立页面 |
| `testapp/lib/features/finance_micro_widgets/domain/finance_micro_widget_models.dart` | 纯 Dart 公式模型，集中维护持有成本与复利收益计算 |
| `testapp/lib/features/finance_micro_widgets/widgets/effective_holding_cost_widget.dart` | 基金真实持有成本估算器 UI 与滑杆交互 |
| `testapp/lib/features/finance_micro_widgets/widgets/compound_daily_gain_widget.dart` | 复利日均收益模拟器 UI、年限标签、收益率滑杆与曲线绘制 |
| `testapp/lib/features/finance_micro_widgets/widgets/finance_micro_widget_decoration.dart` | 两个工具独立页面底部共用的 Myo 装饰插画 |
| `testapp/test/finance_micro_widgets_test.dart` | 金融小组件 widget 测试，当前覆盖复利计算器手动输入弹窗 |

## 对外接口 / 调用方式

| 页面 / 类型 | 调用方 | 说明 |
|---|---|---|
| `EffectiveHoldingCostPage` | `HomeDashboardPage` 底部“工具”抽屉 | 打开基金真实持有成本估算器独立页 |
| `CompoundDailyGainPage` | `HomeDashboardPage` 底部“工具”抽屉 | 打开复利日均收益模拟器独立页 |
| `HoldingCostInput.calculate()` | `EffectiveHoldingCostWidget` | 返回管理费、托管费、销售服务费、总费用与持有期折算成本率 |
| `CompoundReturnInput.calculate()` | `CompoundDailyGainWidget` | 返回复利终值、总收益、总天数、日均收益与等效日收益率 |

## 依赖关系

- 依赖 Flutter `material.dart` 实现页面、卡片、滑杆、标签与自绘曲线。
- 依赖 `dart:math` 计算复利终值与等效日收益率。
- 被 `testapp/lib/features/onboarding/pages/home_dashboard_page.dart` 的抽屉式工具选择器引用。
- 设计来源为 `UX-Product-Design/V1/finance-micro-widgets-figma-prototype.md` 中登记的 Figma 文件 `TlIipLw5VVIDDtvYwuHDSR`。
- Myo 底部装饰图归档在 `Design_Resource/UI_design_resource/characters/myo/myo_playing_ball_yarn.png`，并同步到 Flutter 运行资产 `testapp/assets/images/characters/myo/myo_playing_ball_yarn.png`。
- 组件级实现、前端设计素材与计算公式分别见 `feature-finance-holding-cost-widget.md` 与 `feature-finance-compound-daily-gain-widget.md`。

## 变更日志

- 2026-04-29: 新增 `finance_micro_widgets_test.dart` 覆盖复利计算器本金手动输入弹窗关闭流程，并修复弹窗 controller 生命周期问题。
- 2026-04-29: 两个独立工具页面底部加入共享 Myo 装饰插画，并登记对应 UI 资源与 Flutter 资产路径。
- 2026-04-29: 首页“工具”入口改为底部抽屉选择器，基金持有成本和复利日均收益拆为两个独立页面；删除原双组件总览页。
- 2026-04-29: 新增金融小组件 feature，总览页承载基金持有成本估算器与复利日均收益模拟器，并接入首页底部“小工具”入口。
