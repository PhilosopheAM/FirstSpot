# frontend/app-entry — 应用入口与首开分流

## 模块职责

应用入口负责装配 Flutter 根应用、执行首开状态判断，并将用户分流到首开引导或首页仪表盘。

当前不再使用独立的 app-level Myo splash / hatch 启动页。Myo 的欢迎视频与点击音效都由 `Onboarding_01_Welcome` 内部承载。

## 关键文件


| 文件                                                                     | 作用                                                                                         |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `testapp/lib/main.dart`                                                | Flutter 入口；创建 `MaterialApp`，根页面挂载 `FirstOpenGatePage`                                      |
| `testapp/lib/features/onboarding/pages/first_open_gate_page.dart`      | 首开分流页；读取 `OnboardingPreferencesService.shouldShowOnboarding()` 并跳转到 onboarding 或 dashboard |
| `testapp/lib/features/onboarding/pages/onboarding_flow_page.dart`      | 首开引导流程容器                                                                                   |
| `testapp/lib/features/onboarding/pages/home_dashboard_page.dart`       | 非首开或完成引导后的首页仪表盘                                                                            |
| `testapp/lib/features/onboarding/widgets/onboarding_welcome_step.dart` | 当前 Myo 欢迎视频和点击音效入口                                                                         |


已删除 / 废弃：


| 文件 / 资源                                                         | 状态                     |
| --------------------------------------------------------------- | ---------------------- |
| `testapp/lib/features/onboarding/pages/avatar_launch_page.dart` | 已删除，不再作为启动动效页          |
| `testapp/assets/animations/myo_wave_frames/`                    | 已删除，不再使用透明 PNG 序列帧启动方案 |
| `testapp/assets/animations/cat_wave_transparent_2s.webm`        | 已删除，不再使用透明 webm 启动方案   |
| `tools/generate_myo_wave_frames.ps1`                            | 已删除，不再维护序列帧生成脚本        |


## 对外接口 / 调用方式

`testapp/lib/main.dart` 通过 `home: const FirstOpenGatePage()` 进入首开分流。

```text
main()
  -> MyApp
    -> MaterialApp(home: FirstOpenGatePage)
      -> shouldShowOnboarding()
        -> true:  OnboardingFlowPage
        -> false: HomeDashboardPage
```

`FirstOpenGatePage` 对外没有构造参数。

## 依赖关系

- 依赖 `features/onboarding/data/onboarding_preferences_service.dart` 读取首开状态。
- 依赖 `features/onboarding/pages/onboarding_flow_page.dart` 作为首次打开入口。
- 依赖 `features/onboarding/pages/home_dashboard_page.dart` 作为返回用户入口。
- 被 `testapp/lib/main.dart` 作为根页面挂载。

## 变更日志

- 2026-04-25: 移除独立 `AvatarLaunchPage` 启动动效链路；首开分流改为加载态后直接进入 `OnboardingFlowPage` 或 `HomeDashboardPage`，Myo 欢迎视频和点击音效转由 `onboarding_welcome_step.dart` 维护。
- 2026-04-24: 增加启动动效说明；首开分流曾先显示 `AvatarLaunchPage`，其实现为透明 PNG 序列帧逐帧播放。
- 2026-04-20: 初始化文档；分流逻辑由 `FirstOpenGatePage` 承担。

