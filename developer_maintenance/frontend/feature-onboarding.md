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

## 启动动效实现

当前首开动效采用“多张透明 PNG 序列帧逐帧播放”方案，而不是直接播放 `.webm` 或让整张方图整体晃动。

### 设计目标

- 只保留 Myo 本体的黑色线稿与粉色舌头
- 去掉米白底和绿色背景形状，避免与首页背景冲突
- 只让右手区域轻微摆动，营造“招呼用户跟上它”的感觉
- 在 Flutter 端稳定运行，不依赖透明视频 alpha 通道兼容性

### 关键文件与资源

| 路径 | 作用 |
|---|---|
| `testapp/lib/features/onboarding/pages/avatar_launch_page.dart` | 启动页动画播放器；预加载透明帧并按时间逐帧切换 |
| `testapp/assets/animations/myo_wave_frames/frame_00.png` ~ `frame_09.png` | 启动页使用的透明序列帧 |
| `tools/generate_myo_wave_frames.ps1` | 本地重新生成透明序列帧的脚本 |
| `remotion-avatar/public/cat-avatar-transparent.png` | 透明底原始角色图，用于生成序列帧 |

### 播放机制

- `AvatarLaunchPage` 内维护 `_frameAssets`，显式列出 10 张透明帧
- 在 `didChangeDependencies()` 中通过 `precacheImage()` 预加载所有帧，降低启动时闪烁风险
- 用一个 `AnimationController(duration: 2200ms)` 驱动播放
- 播放时按当前进度计算 `sequenceIndex`，将 10 帧循环两轮显示
- 同时叠加入场缩放、轻微上下浮动、淡入淡出效果
- 动画结束后执行 `widget.onFinished()`，回到 `FirstOpenGatePage` 的后续路由判断

### 为什么不用透明 `.webm`

- 仓库中保留了 `assets/animations/cat_wave_transparent_2s.webm`
- 但在 Flutter / Android 实际播放链路中，透明区域曾被显示为黑底方块
- 因此当前稳定方案是透明 PNG 序列帧；除非后续明确验证 alpha 视频在目标平台完全可靠，否则不要恢复为默认实现

### 如何调节动画

- 如果想让“手摆动更大 / 更快 / 更自然”，优先修改 `tools/generate_myo_wave_frames.ps1`
- 重点参数：
  - `$angles`：控制每一帧手部旋转角度
  - `$offsetYs`：控制手部上下微移
  - `$cropRect` / `$pivot` / `$eraseRect`：控制被切出来并重新旋转的右手区域
  - 招手线坐标：控制右上角两条 motion line 的位置
- 修改脚本后重新执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\generate_myo_wave_frames.ps1
```

- 重新生成后，如有新增或删减帧数量，需要同步更新 `avatar_launch_page.dart` 中的 `_frameAssets`

### 维护约束

- 不要把调试预览图放进 `testapp/assets/animations/myo_wave_frames/`，避免被一起打包进 app
- 优先维护透明帧方案；除非有明确需求，不要把 `avatar_launch_page.dart` 改回“整张头像整体晃动”
- 若未来改为美术同学提供的正式多帧资源，保持“透明背景 + 逐帧播放”的集成方式不变即可

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
- 2026-04-24: 启动页动效改为“透明 PNG 序列帧逐帧播放”方案；新增 `avatar_launch_page.dart`、`testapp/assets/animations/myo_wave_frames/` 与 `tools/generate_myo_wave_frames.ps1` 的维护说明。
