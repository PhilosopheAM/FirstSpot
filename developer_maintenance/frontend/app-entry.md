# frontend/app-entry — 应用入口与首开分流

## 模块职责

- 装配 `MaterialApp`（主题、调试开关）
- 执行**首开检测**：第一次打开 → 引导流程；否则 → 主仪表盘
- 首开检测期间展示极简 Loading

## 关键文件

| 路径 | 作用 |
|---|---|
| `testapp/lib/main.dart` | `main()` 入口；`MyApp` 根部件；`home: FirstOpenGatePage()` |
| `testapp/lib/features/onboarding/pages/first_open_gate_page.dart` | 首开判断分流页，根据 `OnboardingPreferencesService.shouldShowOnboarding()` 决定走 `OnboardingFlowPage` 还是 `HomeDashboardPage` |

## 路由决策

```text
启动
  └─ FirstOpenGatePage.initState()
       └─ OnboardingPreferencesService.shouldShowOnboarding()
            ├─ true  → OnboardingFlowPage
            └─ false → HomeDashboardPage
```

Loading 态：`CircularProgressIndicator` + 绿色 `#1FA95B`，背景 `#F7FAF8`。

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
