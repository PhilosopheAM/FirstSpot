# Badge Asset Naming

这些资源是从 `创意参考图/badge_reference/` 里的 badge 参考图微调后输出的产品候选资产。

## 命名规则

```text
achievement_<category>_<purpose>_<style>_<mascot>.png
```

- `category`：用途分类，例如 `learning`、`streak`、`focus`、`review`。
- `purpose`：触发场景，例如 `onboarding_start`、`7_day_persist`、`halfway`。
- `style`：视觉版式，`round` 表示圆形印章徽章，`card` 表示成就卡/分享卡版式。
- `mascot`：主视觉角色，方便美术和工程快速定位同名徽章的变体。

## 使用建议

- App 内成就墙优先使用 `round`。
- 解锁弹窗、分享海报、收藏册详情可使用 `card`。
- Flutter 侧资产清单在 `testapp/lib/features/onboarding/domain/achievement_badges.dart`。
- 完整来源映射和触发说明见 `badge_manifest.json`。

## 处理说明

- 统一输出为 1024 x 1024 PNG。
- 裁掉多余白边，并将外部纯白背景转为透明。
- 轻微提升饱和度、对比度与清晰度，保留原始手绘水彩质感。
