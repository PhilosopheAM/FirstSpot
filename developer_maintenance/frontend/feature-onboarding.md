# frontend/feature-onboarding — 首开引导

## 模块职责

首次打开时引导用户完成：欢迎页 → 轻量画像问卷（身份 / 储蓄 / 波动情绪） → 第一课微讲解 → 启动计划选择 → 进入主仪表盘。完成后通过偏好持久化，下次启动直接跳过。

## 关键文件

```text
testapp/lib/features/onboarding/
├── pages/
│   ├── first_open_gate_page.dart          # 首开分流（见 app-entry.md）
│   ├── onboarding_flow_page.dart          # 引导流程宿主页（多步骤 stepper）
│   └── home_dashboard_page.dart           # 引导完成后进入的主仪表盘
├── widgets/
│   ├── onboarding_welcome_step.dart       # 欢迎步骤
│   ├── onboarding_profile_step.dart       # 画像问卷步骤（三题：身份/储蓄/波动）
│   ├── onboarding_lesson_step.dart        # 第一课微讲解步骤
│   ├── onboarding_starter_plan_step.dart  # 起始计划选择步骤
│   └── task_card.dart                     # 通用任务卡片（主仪表盘复用）
├── domain/
│   └── onboarding_models.dart             # 枚举 + OnboardingProfileAnswers
└── data/
    └── onboarding_preferences_service.dart # SharedPreferences 封装
```

## 对外接口

### 顶级页面

| 页面 | 入口 | 说明 |
|---|---|---|
| `FirstOpenGatePage` | `main.dart` 的 `home` | 根据偏好决定后续路由 |
| `OnboardingFlowPage` | Gate 页判定为首开 | 多步骤引导容器 |
| `HomeDashboardPage` | 引导完成 / 非首开 | 主仪表盘 |

### 领域模型（`onboarding_models.dart`）

| 类型 | 值 | 用途 |
|---|---|---|
| `enum UserIdentityType` | `student / newWorker / experiencedWorker / other` | 用户身份（带 label + feedback 文案） |
| `enum SavingsRange` | `<200 / 200-500 / 500-1000 / >1000` | 月储蓄区间 |
| `enum VolatilityFeeling` | `scared / acceptSmall / acceptLarge` | 面对波动的情绪（带 emoji） |
| `class OnboardingProfileAnswers` | `{identity, savings, volatility}` | 问卷答案聚合；`isComplete` 判全 |

### 数据层（`onboarding_preferences_service.dart`）

| 方法 | 作用 |
|---|---|
| `shouldShowOnboarding()` | 查询是否首开 |
| （持久化 `OnboardingProfileAnswers` / 完成标记的其它方法详见源码） | 引导完成时写入 |

> 具体持久化字段与 key 命名在 `onboarding_preferences_service.dart` 中，修改时同步更新此表。

## 依赖关系

- 本 feature **不依赖**后端（当前版本纯本地）
- 依赖 `shared_preferences`（见 `testapp/pubspec.yaml`）
- 被 `lib/main.dart` 通过 `FirstOpenGatePage` 挂载

## 交互参考

UX 草案见 `UX-Product-Design/V1/first-open-onboarding.md` 与 `UX-Product-Design/V1/Scratch_List/onboarding_*.md`。

## 扩展注意

- **新增一个引导步骤**：
  1. 在 `widgets/` 新建 `onboarding_<step>_step.dart`
  2. 在 `onboarding_flow_page.dart` 的 step 列表中插入
  3. 如涉及新的答案字段 → 更新 `onboarding_models.dart` 的 `OnboardingProfileAnswers`
  4. 如需持久化 → 更新 `onboarding_preferences_service.dart`
  5. 更新本文档「关键文件」表格

- **接入后端画像上传**：新增 `data/onboarding_api.dart`（参考 `stock_insight` 的 `StockInsightBackendApi` 契约模式），不要在 widgets 里直接发请求。

## 变更日志

- 2026-04-20: 初始化文档；当前 4 步引导 + 主仪表盘 + 3 个枚举 + 1 个答案聚合类。
