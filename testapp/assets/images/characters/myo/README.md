# Myo Character Assets

本目录存放 Flutter 应用内直接使用的 Myo 角色素材。

## 文件清单

- `myo_default_smile.png`: 默认微笑，用于常规陪伴状态。
- `myo_thinking.png`: 思考状态，用于解释和提示。
- `myo_sneak_peek.png`: 偷偷观察状态，用于轻提示。
- `myo_clap.png`: 鼓掌状态，用于小任务完成反馈。
- `myo_sunglasses.png`: 墨镜状态，用于成就或稀有奖励。
- `myo_angry_scam_alert.png`: 风险提醒状态。
- `myo_celebrate_greatly.png`: 大型庆祝状态，用于“秋天收获”完成体验后的全屏庆祝层。

## `myo_celebrate_greatly.png`

- 来源：用户生成素材，原路径为 `G:\Tempo\FirstSpot_Tempo\myo_celebrate_greatly.png`。
- 接入位置：`assets/images/characters/myo/myo_celebrate_greatly.png`。
- 格式检查：PNG，`1024 x 1536`，`Format32bppArgb`，包含 alpha 透明通道。
- 使用场景：点击“完成体验”后，彩带出现并播放猫叫，随后 Myo 从屏幕底部弹出，占据约 2/3 屏幕，再进入“首次关卡全通”说明页。

## Flutter 资源注册

`pubspec.yaml` 已注册整个目录：

```yaml
assets:
  - assets/images/characters/myo/
```

因此新增同目录 PNG 不需要额外逐个登记。
