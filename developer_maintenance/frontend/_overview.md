# 前端总览 (testapp)

## 模块职责

`testapp/` 是 FirstSpot 的 Flutter 移动端，面向 Z 世代新手投资者。代码按 **feature 切片**组织：每个业务模块独立目录，包含自己的 `pages/ / widgets/ / domain/ / data/`。

## 目录约定

```text
testapp/lib/
├── main.dart                       # 应用入口，装配 MaterialApp
└── features/
    ├── learning_guidance/          # 投资者教育 12 章课程
    │   ├── pages/                  #   章节列表 / 详情页
    │   ├── widgets/                #   Myo 练习组件
    │   ├── domain/                 #   章节 / 题库模型
    │   └── data/                   #   12 章静态内容与题库
    ├── onboarding/                 # 首开引导
    │   ├── pages/                  #   顶级路由页
    │   ├── widgets/                #   仅本 feature 使用的组件
    │   ├── domain/                 #   领域模型、枚举
    │   └── data/                   #   偏好存储 / 持久化
    └── stock_insight/              # 个股信息页
        ├── pages/
        ├── widgets/
        ├── domain/
        └── data/
```

### 分层规则

| 层 | 职责 | 可以依赖 |
|---|---|---|
| `domain/` | 纯数据类、枚举、不可变模型 | 无（纯 Dart） |
| `data/` | 持久化、网络适配器、后端协议 | `domain/` |
| `widgets/` | 无状态 / 轻状态 UI 组件 | `domain/` |
| `pages/` | 顶层页面 + 路由 | `domain/` `data/` `widgets/` |

**禁止**跨 feature 相互 import（如 `stock_insight/` 不得 import `onboarding/`）。共享逻辑应下沉到未来的 `lib/core/` 或 `lib/shared/`（目前还没必要建立）。

## 现有 feature

| Feature | 目录 | 文档 |
|---|---|---|
| 应用入口 & 首开分流 | `lib/main.dart` + `features/onboarding/pages/first_open_gate_page.dart` | `app-entry.md` |
| 首开引导 | `features/onboarding/` | `feature-onboarding.md` |
| 投资者教育课程 | `features/learning_guidance/` | `feature-learning-guidance.md` |
| 个股信息页 | `features/stock_insight/` | `feature-stock-insight.md` (内含 [Figma 原型链接](https://www.figma.com/design/Jb5m5oWDmydGzAOcqeRAB4)) |

## 新增 feature 的流程

1. 新建 `lib/features/<feature_name>/{pages,widgets,domain,data}/`
2. 顶级页面放 `pages/`，对外导出 `<feature>_page.dart`
3. 在 `lib/main.dart` 或上级路由中挂载
4. 在 `developer_maintenance/frontend/` 新建 `feature-<name>.md`
5. 在本文件和 `developer_maintenance/README.md` 登记

## 变更日志

- 2026-04-20: 初始化文档；当前两个 feature：onboarding、stock_insight。
- 2026-04-25: 新增 `learning_guidance` feature，用于承载 12 章投资者教育课程、题库与 Myo 反馈练习。
- 2026-04-29: 在 `stock_insight` feature 的文档条目中补充了 Figma 原型链接。
