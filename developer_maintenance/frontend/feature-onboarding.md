# frontend/feature-onboarding — 首开引导

## 模块职责

`onboarding` 负责 FirstSpot 首次打开体验、轻量画像收集、游戏化迷你教学、起始计划生成、奖励揭示，以及完成首开后的首页仪表盘承载。

首页 `HomeDashboardPage` 暂仍位于本 feature，因此首页任务卡、开发调试重置入口和学习路径入口的路由维护也记录在本文档中。投资者教育课程本体由 `frontend/feature-learning-guidance.md` 维护。

## 关键文件

| 文件 | 作用 |
|---|---|
| `testapp/lib/features/onboarding/pages/first_open_gate_page.dart` | 首开分流页，读取本地偏好决定进入引导或首页 |
| `testapp/lib/features/onboarding/pages/onboarding_flow_page.dart` | 首开引导流程容器，串联 welcome/profile/lesson/starter/reward |
| `testapp/lib/features/onboarding/pages/home_dashboard_page.dart` | 引导完成后的首页仪表盘，含个股信息入口、学习课程入口、底部工具 / 金库入口和 debug 重置 |
| `testapp/lib/features/onboarding/pages/vault_page.dart` | 金库页面，展示用户当前已获得的章节卡片和成就徽章，底部可切换“卡片 / 徽章”并支持左右滑动浏览 |
| `testapp/lib/features/onboarding/data/onboarding_preferences_service.dart` | `SharedPreferences` 封装，记录首开完成状态与 Myo 彩蛋状态 |
| `testapp/lib/features/onboarding/domain/onboarding_models.dart` | 首开画像枚举和 `OnboardingProfileAnswers` |
| `testapp/lib/features/onboarding/widgets/bouncy_button.dart` | 统一弹性按钮组件 |
| `testapp/lib/features/onboarding/widgets/onboarding_welcome_step.dart` | Welcome 步骤，承载 Myo 视频、点击音效、彩蛋提示与跳过确认 |
| `testapp/lib/features/onboarding/widgets/onboarding_profile_step.dart` | 轻量画像收集，聊天式问答、撤回/重选、Myo 延迟回复 |
| `testapp/lib/features/onboarding/widgets/onboarding_lesson_step.dart` | 迷你教学，三关农事类比与连续聊天流交互 |
| `testapp/lib/features/onboarding/widgets/onboarding_starter_plan_step.dart` | 根据画像生成 First Pot 起步计划 |
| `testapp/lib/features/onboarding/widgets/onboarding_reward_reveal_step.dart` | 奖励揭示，概念卡翻转与“点击收下卡片”仪式 |
| `testapp/lib/features/onboarding/widgets/task_card.dart` | 首页任务卡片组件 |
| `testapp/lib/features/onboarding/widgets/xp_flyup.dart` | 右上角 `+N XP` 向上飘动反馈，替代底部 SnackBar 奖励提示 |

已删除 / 废弃：

| 文件 / 资源 | 状态 |
|---|---|
| `testapp/lib/features/onboarding/pages/avatar_launch_page.dart` | 已删除，首开不再有独立启动动效页 |
| `testapp/assets/animations/myo_wave_frames/` | 已删除，旧透明 PNG 序列帧方案废弃 |
| `testapp/assets/animations/cat_wave_transparent_2s.webm` | 已删除，旧透明视频方案废弃 |
| `tools/generate_myo_wave_frames.ps1` | 已删除，序列帧生成脚本废弃 |

## 对外接口 / 调用方式

### 顶级页面

| 页面 | 调用方 | 说明 |
|---|---|---|
| `FirstOpenGatePage` | `testapp/lib/main.dart` | 根页面，执行首开判断 |
| `OnboardingFlowPage` | `FirstOpenGatePage` | 首开用户进入的引导容器 |
| `HomeDashboardPage` | `FirstOpenGatePage` / onboarding 完成回调 | 返回用户和完成引导后的首页 |
| `VaultPage` | `HomeDashboardPage` 底部“金库”按钮 | 已获得概念卡收藏浏览页 |

### 领域模型

| 类型 | 当前值 / 行为 | 用途 |
|---|---|---|
| `UserIdentityType` | `student / newWorker / experiencedWorker / other` | 用户身份画像，带 label 与 Myo feedback |
| `SavingsRange` | `<500 / 500-2000 / 2000-5000 / >5000` | 每月可攒下金额区间，用于起步计划推荐 |
| `VolatilityFeeling` | `scared / acceptSmall / acceptLarge` | 面对波动的情绪画像 |
| `OnboardingProfileAnswers` | `identity / savings / volatility / isComplete` | 画像答案聚合 |

### 持久化服务

| 方法 | 作用 |
|---|---|
| `shouldShowOnboarding()` | 判断是否需要展示首开引导 |
| `markOnboardingComplete()` | 标记首开已完成 |
| `resetOnboarding()` | 开发调试重置首开状态 |
| `hasDiscoveredMyoEasterEgg()` | 查询 Myo 欢迎页点击彩蛋是否已触发 |
| `markMyoEasterEggDiscovered()` | 标记 Myo 彩蛋已触发 |

## 依赖关系

- 依赖 `shared_preferences`：首开完成状态、开发重置、Myo 彩蛋状态。
- 依赖 `video_player`：Welcome 页播放 `assets/animations/myo_waving_welcome.mp4`。
- 依赖 `audioplayers`：Welcome 点击声、mini lesson 音效反馈、以及首开各个步骤（Profile, Starter Plan, Reward Reveal）的音效反馈。
- 依赖 `fl_chart`：mini lesson 第 2 关趋势图。
- 依赖 Flutter `Overlay`：通过 `xp_flyup.dart` 在界面右上角展示非阻塞 XP 飞行动效。
- 依赖 `features/learning_guidance/data/guidance_user_progress.dart`：金库读取当前已获得章节卡片与成就徽章状态。
- 依赖 `features/learning_guidance/pages/guidance_learning_page.dart`：首页“继续新手村课程”入口。
- 依赖 `features/stock_insight/pages/stock_insight_template_page.dart`：首页个股信息入口。
- 依赖 `features/finance_micro_widgets/pages/effective_holding_cost_page.dart` 与 `features/finance_micro_widgets/pages/compound_daily_gain_page.dart`：首页底部“工具”抽屉的两个独立页面入口。
- 被 `testapp/lib/main.dart` 通过 `FirstOpenGatePage` 挂载。

## 当前流程

```text
FirstOpenGatePage
  ├─ 首开: OnboardingFlowPage
  │   ├─ OnboardingWelcomeStep
  │   ├─ OnboardingProfileLiteStep
  │   ├─ OnboardingMiniLessonStep
  │   ├─ OnboardingStarterPlanStep
  │   └─ OnboardingRewardRevealStep
  └─ 非首开: HomeDashboardPage
```

## Home dashboard entry points

- “了解你的第一只关注个股”卡片进入 `StockInsightTemplatePage`。
- “继续新手村课程”卡片进入 `GuidanceLearningPage`。
- 底部显示 `🧮 工具` 与 `🏛️ 金库` 并列入口；工具按钮弹出底部抽屉，分别进入 `EffectiveHoldingCostPage` 或 `CompoundDailyGainPage`，金库进入 `VaultPage` 查看当前已获得卡片和徽章。
- AppBar 右侧保留 `重置首开(Debug)`，用于本地开发清空 `SharedPreferences` 并回到首开分流。

## Vault page

- 章节学习完成后解锁对应章节主视觉卡片；徽章只由学习引导的首次里程碑状态发放。
- 金库底部提供“卡片 / 徽章”切换，两类收藏品都使用 `PageView` 展示，顺序为最早获得在最左，最新获得在最右。
- 滑到数组边界时使用 clamping physics，卡片和徽章不会离开屏幕。
- 左上角返回按钮回到首页。

## Welcome step

- Myo 渲染在绿色圆形框内。
- 圆形框内循环播放 `testapp/assets/animations/myo_waving_welcome.mp4`。
- Welcome 主体使用响应式滚动布局，在较矮视口下会缩小标题、Myo 圆形框和垂直间距，避免 Flutter widget test 默认 800x600 视口和小屏设备出现底部溢出。
- 点击 Myo 不改变视频状态，但会播放 `testapp/assets/audio/myo_meow_short.mp3`。
- 首次点击会通过 `OnboardingPreferencesService` 解锁一次性 Myo 彩蛋状态。
- 跳过按钮需要确认，避免误跳过。

## Profile step

- 画像收集使用类微信聊天流。
- 用户回答后会出现用户气泡；气泡旁提供红色旋转返回图标，可撤回并重选同一问题。
- Myo 回复前先展示约 0.6s 的“正在输入”状态，再显示反馈。
- 月储蓄区间为 `<500 / 500-2000 / 2000-5000 / >5000`。

## Mini lesson step (`onboarding_lesson_step.dart`)

- **Metaphor**: spring seeds (principal / idle cash) → field growth (up/down vs market+underlying) → autumn harvest (P&L as multi-factor outcome).
- **Assets**: Uses `harvest_basket.png`, `idle_money_coin.png`, `planted_sprout.png` for visuals, and `basket_drop.wav`, `heart_break_soft.wav`, `seed_plant.wav` for audio feedback using `audioplayers`.
- **Level 1**: `Draggable` coins into a `DragTarget` spring field. The interaction area is fixed at the bottom, while the upper area uses a per-level chat space. Planting 1/2/3 coins appends user messages and delayed Myo replies. `就这么多` is blocked with shake/audio if 0 coins are planted.
- **Level 2**: `fl_chart` 30-day line chart (2.0–5.0 y-range), fire-red stroke + gradient fill; three `BouncyButton` choices with pulse and chat feedback. After the user chooses an option, Myo shows a 0.6s typing pause before feedback. Wrong answers deduct patience and allow retry.
- **Level 3**: `Draggable` emoji into harvest basket; after an emoji is dropped, Myo shows a 0.6s typing pause, replies in chat, and a pulsing `完成体验` button appears to let the user proceed at their own pace.
- When a pulsing transition button such as `进入夏天` or `进入秋天` is tapped, the previous level's chat messages are cleared before the next level's opening dialogue is initialized.
- XP reward feedback uses `showXpFlyup(context, amount)`: `+N XP` appears near the top-right and floats upward off-screen, avoiding bottom SnackBar overlap with the interaction area.

## Starter plan step

- Recommended amount is derived from the updated `SavingsRange` values.
- The plan copy continues to emphasize first-pot / stable-start framing, not investment advice.
- First Pot plan card uses a corrected 3D flip transform: after the card rotates past 90°, the visible face receives an inner 180° correction so text and icons are not mirrored.
- Saving the plan shows `+20 XP` via the same top-right flyup overlay before advancing.

## Reward reveal step

- Reveals `CARD-01` concept card using a flip-style ritual.
- The hidden `?` card and revealed `CARD-01` face use the same corrected 3D flip transform to avoid horizontal mirroring during and after the 180° turn.
- After `CARD-01` is revealed, the card enters a subtle floating state (`AnimationController` loop, about 2.2s per cycle, ±7px vertical movement) to make the achievement feel suspended in the air.
- Streak ignition has been removed from the onboarding completion flow.
- After `CARD-01` is revealed, the user must tap the screen again to collect the card; the card briefly scales/fades out before onboarding completes.

## 变更日志

- 2026-04-29: 首页底部 `🧮 小工具` 改名为 `🧮 工具`，点击后打开抽屉式工具选择器，分别进入基金持有成本和复利日均收益独立页面。
- 2026-04-25: 文档对齐本轮重构，补齐关键文件、对外接口、依赖关系和所有主要 onboarding 变更记录。
- 2026-04-29: 金库从单一概念卡列表改为“卡片 / 徽章”双收藏展示；卡片和徽章共用左右滑动逻辑，数据改由持久化的 `GuidanceUserProgress` 提供。
- 2026-04-25: 修复首页底部 `🏛️ 金库` 按钮在部分视口/emoji 字体下的 `RenderFlex` 底部溢出；图标改为固定高度 `FittedBox`，文字压低行高。
- 2026-04-25: 首页底部新增 `🏛️ 金库` 操作入口；新增 `VaultPage`，用于浏览已获得概念卡，当前首开完成后默认展示 `CARD-01`。
- 2026-04-25: Reward Reveal 中 `CARD-01` 获得后进入悬浮态，卡片在空中轻微上下浮动，直到用户点击屏幕收下卡片。
- 2026-04-25: 新增 `xp_flyup.dart`，将 `+2/+10/+20 XP` 奖励反馈从底部灰色 SnackBar 改为右上角向上飘动并淡出的非阻塞动画。
- 2026-04-25: Reward Reveal 移除 Streak 点火交互；`CARD-01` 翻开后改为用户再次点击屏幕收下卡片，再进入下一界面。
- 2026-04-25: 修复 Starter Plan 与 Reward Reveal 的 3D 翻卡镜像问题；翻转超过 90° 后对当前可见卡面做内层 180° 校正，避免文字和问号卡水平反转。
- 2026-04-28: 将 `Design_Resource/Sound_design_resource/` 下的音频素材同步至 `testapp/assets/audio/`，并更新 `pubspec.yaml` 统一声明。在 `OnboardingProfileLiteStep`、`OnboardingStarterPlanStep` 和 `OnboardingRewardRevealStep` 中接入 `AudioPlayer` 替换了原有的音频 TODO 占位符。
- 2026-04-25: Mini lesson 夏天选项与秋天 Emoji 选择后，Myo 反馈改为显式等待 0.6s 输入态，避免用户选择后反馈过快。
- 2026-04-25: Welcome 页主体改为响应式滚动布局，修复 800x600 测试视口下的底部 overflow；同步更新 onboarding 测试为当前聊天流交互，并避免对持续视频动画使用 `pumpAndSettle`。
- 2026-04-25: Mini lesson 关卡切换时清空上一关聊天记录，再初始化下一关开场对话，避免旧对话占用新环节空间。
- 2026-04-25: 修复 Welcome 页点击 Myo 绿色圆框无声反馈的问题；点击音效播放器改为低延迟模式，欢迎视频显式静音以避免压住 `myo_meow_short.mp3`。
- 2026-04-25: 首页课程卡片从锁定态改为进入 `GuidanceLearningPage`，12 章课程本体由 `feature-learning-guidance.md` 维护。
- 2026-04-25: 新增 `onboarding_reward_reveal_step.dart`，接入概念卡翻转与 Streak 点火仪式。
- 2026-04-25: `onboarding_lesson_step.dart` 重构为农事四季类比和连续聊天流，接入真实图像/音效资源、`fl_chart` 趋势图和 pulsing 下一步按钮。
- 2026-04-25: `onboarding_profile_step.dart` 改为更真实的聊天式问答，支持撤回重选、Myo 延迟回复和新版储蓄区间。
- 2026-04-25: `onboarding_welcome_step.dart` 改为 Myo 视频欢迎页，接入点击音效、彩蛋状态和跳过确认。
- 2026-04-25: `onboarding_models.dart` 将 `SavingsRange` 更新为 `<500 / 500-2000 / 2000-5000 / >5000`。
- 2026-04-25: `onboarding_preferences_service.dart` 增加 Myo 彩蛋状态读写。
- 2026-04-25: 删除独立 `avatar_launch_page.dart`、旧 `myo_wave_frames/` 序列帧、旧透明 webm 和序列帧生成脚本，启动动效职责迁移到 welcome step。
- 2026-04-20: 初始化文档；记录首开引导、首页和画像模型的初始结构。
