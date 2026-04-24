# Myo Expression Set

这组资产用于 FirstSpot 向导猫 `Myo / 喵` 的基础表情库，补齐了 `Gamified_Onboarding_Design.md` 中要求的 12 套基础表情。

目录位置：

- 设计资源目录：`Design_Resource/UI_design_resource/characters/myo/`

基础风格约束：

- 以现有小猫 avatar 为角色基底
- 粗黑手绘线条
- 米白底 + 薄荷绿背景块
- 统一 1:1 构图
- 面向 onboarding、日常任务卡、奖励弹层、推送头像等 UI 场景

命名规则：

```text
myo_<expression>.png
```

例如：

- `myo_default_smile.png`
- `myo_angry_scam_alert.png`
- `myo_birthday_hat.png`

## 12 套表情清单

| 中文名 | 文件名 | 主要场景 | 备注 |
|---|---|---|---|
| 默认微笑 | `myo_default_smile.png` | 欢迎页、首页常驻、普通陪伴状态 | 默认安全态 |
| 眨眼 | `myo_wink.png` | 轻反馈、彩蛋、按钮点击后 | 更俏皮 |
| 欢呼 | `myo_cheer.png` | 通关、升级、连击奖励 | 高兴奋度 |
| 鼓掌 | `myo_clap.png` | 答对题、小任务完成、卡片入库 | 中强度正反馈 |
| 托腮思考 | `myo_thinking.png` | 引导提问、概念解释、用户犹豫时 | 认知型反馈 |
| 偷偷瞄 | `myo_sneak_peek.png` | 轻吐槽、侧边提示、低存在感提醒 | 调皮但不打扰 |
| 装死躺平 | `myo_flat_deadpan.png` | 用户答错、疲劳状态、轻度失败反馈 | 搞笑，不羞辱 |
| 流泪 | `myo_crying.png` | 丢 streak、错过里程碑、情绪共鸣 | 软性失落 |
| 愤怒 | `myo_angry_scam_alert.png` | 骗局识别、风险警示、危险内容提示 | 保护性愤怒 |
| 睡觉 | `myo_sleeping.png` | 7 天未打开、夜间静默、休眠状态 | 低活跃状态 |
| 戴墨镜 | `myo_sunglasses.png` | 金卡章节、稀有奖励、里程碑炫耀 | achievement 态 |
| 戴生日帽 | `myo_birthday_hat.png` | 周年、纪念日、生日活动 | 节庆态 |

## 设计说明

这套表情不是把同一张头像机械换嘴型，而是按 UI 使用频率拆成三层：

1. 常驻基础态：
   - 默认微笑
   - 眨眼
   - 思考
   - 偷瞄

2. 反馈态：
   - 欢呼
   - 鼓掌
   - 装死躺平
   - 流泪
   - 愤怒
   - 睡觉

3. 里程碑/节日态：
   - 戴墨镜
   - 戴生日帽

这样接到产品里时，既能覆盖日常交互，也能支持成就与纪念节点，不需要临时再补图。

## 来源记录

- 角色参考图：`创意参考图/小猫app-avatar-v1.png`
- 生成方式：基于现有小猫形象，用图像生成方式扩展表情变体
- 保存格式：PNG

## 后续建议

- 如果要进 Flutter 资源目录，建议复制到 `testapp/assets/images/characters/myo/`
- 如果后续做 Rive/Lottie，可以以这 12 张作为 key pose 参考，而不是直接逐帧使用
- 如果推送头像需要更小尺寸版本，可以从这组基础图再导出 256px / 512px 版本
