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
- `myo_lay_face_smile.png`: 趴地抬头微笑状态，用于 CH01 IPO 案例讲解页的底部登场层。

## `myo_celebrate_greatly.png`

- 来源：用户生成素材，由外部导入后归档至本目录。
- 接入位置：`assets/images/characters/myo/myo_celebrate_greatly.png`。
- 格式检查：PNG，`1024 x 1536`，`Format32bppArgb`，包含 alpha 透明通道。
- 使用场景：点击“完成体验”后，彩带出现并播放猫叫，随后 Myo 从屏幕底部弹出，占据约 2/3 屏幕。
- 交互规则：Myo 只从底部弹出一次并持续停留；用户点击屏幕后，若当前彩带动画仍在播放，会等本轮彩带播放完成，再播放“引导关卡全通！”和“本金、涨跌、盈亏，你都摸过一遍啦！”的结算字幕。
- 退场规则：结算字幕播放结束后，整个庆祝界面向下滑出，并进入下一个流程；不再弹出额外的“首次关卡全通”对话框。
- 空闲规则：如果用户没有点击屏幕，彩带会每隔约 4 秒再次播放一次，Myo 始终停留在前景。

## Flutter 资源注册

`pubspec.yaml` 已注册整个目录：

```yaml
assets:
  - assets/images/characters/myo/
```

因此新增同目录 PNG 不需要额外逐个登记。

## `myo_lay_face_smile.png`

- 来源：用户提供素材，由外部导入后归档至本目录。
- 接入位置：`assets/images/characters/myo/myo_lay_face_smile.png`。
- 归档位置：`Design_Resource/UI_design_resource/characters/myo/myo_lay_face_smile.png`。
- 使用场景：投资者教育 CH01 “案例 · IPO 股份旅程”讲解页开场，Myo 从屏幕底部趴地探出，顶部字幕出现后进入滚动式案例讲解。
- 交互规则：登场层高度约占屏幕 52%，使用底部对齐裁切，保留头部和前爪亲和感；字幕消失后 Myo 向下滑出，第一段讲解自动出现。
