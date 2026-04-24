# frontend/app-entry — 应用入口与首开分流

## 模块职责

- 装配 `MaterialApp`（主题、调试开关）
- 执行**首开检测**：第一次打开 → 引导流程；否则 → 主仪表盘
- 首开检测期间展示极简 Loading

## 关键文件

| 路径 | 作用 |
|---|---|
| `testapp/lib/main.dart` | `main()` 入口；`MyApp` 根部件；`home: FirstOpenGatePage()` |
| `testapp/lib/features/onboarding/pages/first_open_gate_page.dart` | 首开判断分流页；先播放启动动效，再根据 `OnboardingPreferencesService.shouldShowOnboarding()` 决定走 `OnboardingFlowPage` 还是 `HomeDashboardPage` |
| `testapp/lib/features/onboarding/pages/avatar_launch_page.dart` | 启动动效页；播放透明 PNG 序列帧版 Myo 招手动画 |

## 路由决策

```text
启动
  └─ FirstOpenGatePage.initState()
       ├─ 显示 AvatarLaunchPage（Myo 招手启动动效）
       └─ OnboardingPreferencesService.shouldShowOnboarding()
            ├─ true  → OnboardingFlowPage
            └─ false → HomeDashboardPage
```

Loading 态：`CircularProgressIndicator` + 绿色 `#1FA95B`，背景 `#F7FAF8`。

## 启动动效约定

- 当前动效不是透明视频，而是“透明 PNG 序列帧逐帧播放”
- 动效资源位于 `testapp/assets/animations/myo_wave_frames/`
- 动效生成脚本位于 `tools/generate_myo_wave_frames.ps1`
- 这样做的原因是 Flutter / Android 对透明 `.webm` 的 alpha 通道支持不稳定，曾出现黑底方块
- 后续若需要调整招手动作，优先改脚本和帧资源，不要先改路由层逻辑

## 主题

- 主色种子：`#1FA95B`（品牌绿），Material 3 生成的 `ColorScheme`
- `debugShowCheckedModeBanner: false`

## 依赖关系

依赖：`flutter/material.dart`、`features/onboarding/data/onboarding_preferences_service.dart`、`features/onboarding/pages/onboarding_flow_page.dart`、`features/onboarding/pages/home_dashboard_page.dart`

被依赖：Flutter 启动时由 `main()` 调用

## 扩展注意

- 今后如需接入路由库（`go_router` 等），在 `MyApp.build()` 内替换 `home:`，`FirstOpenGatePage` 仍作为根路由 `/`
- 主题色若要随品牌升级变化，统一改 `seedColor`，避免散落的硬编码 `Color(0xFF1FA95B)`

## 变更日志

- 2026-04-20: 初始化文档；当前分流逻辑由 `FirstOpenGatePage` 承担。
- 2026-04-24: 增加启动动效说明；首开分流现在会先显示 `AvatarLaunchPage`，其实现为透明 PNG 序列帧逐帧播放。
