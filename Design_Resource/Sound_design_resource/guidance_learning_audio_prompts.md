# FirstSpot 投资者教育学习闭环音频提示词与映射记录

> 更新时间：2026-04-28
> 用途：记录 12 章投资者教育“先教育、再小测、奖励通行证”闭环中所需的音频提示词，以及前端映射状态。

## 1. 学习闭环音频提示词（已生成并接入）

以下 6 个音效已生成，并作为 `testapp/assets/audio/` 资源接入到 `GuidanceLearningPage` 和 `MyoPracticeBlock` 中。

| 音效 ID | 场景 | 时长 | 特征 | Prompt |
|---|---|---:|---|---|
| `guidance_concept_reveal.wav` | 概念卡进入/翻开 | 0.45s | 柔和纸卡翻开 + 轻微提示亮点，-18dB | Create a short UI sound effect for revealing a learning concept card in a finance education app. Mood: warm, focused, calm. Texture: soft paper-card flip with a tiny clean chime at the end. Timing: 0.45 seconds. Loudness target: -18dB. Avoid casino reward sounds, harsh high frequencies, and dramatic magic whooshes. |
| `guidance_case_slide.wav` | 案例卡片横滑切换 | 0.35s | 轻滑动、纸卡质感、无强奖励，-20dB | Create a short swipe transition sound for moving from concept explanation to case example. Mood: smooth, gentle, modern. Texture: soft card slide, light air movement, minimal transient. Timing: 0.35 seconds. Loudness target: -20dB. Avoid mechanical clicks, game menu whooshes, and heavy impacts. |
| `guidance_interaction_ready.wav` | 轻量互动出现 | 0.30s | Myo 提醒用户可以试一试，-18dB | Create a tiny mascot-friendly prompt sound for an interactive learning task appearing. Mood: curious and encouraging. Texture: two-note soft marimba or rounded synth chirp. Timing: 0.30 seconds. Loudness target: -18dB. Avoid alarm feeling, childish toy sounds, and sharp beeps. |
| `guidance_passport_stamp.wav` | 小测通过/通行证盖章 | 0.75s | 轻印章 + 暖色确认音，-14dB | Create a restrained pass-complete sound for stamping a chapter passport after a quiz. Mood: satisfying, warm, earned. Texture: soft rubber stamp tap followed by a small golden chime. Timing: 0.75 seconds. Loudness target: -14dB. Avoid jackpot, slot machine, casino coins, and loud fanfare. |
| `guidance_next_unlock.wav` | 下一章入口点亮 | 0.90s | 上升粒子、门轻轻打开，-16dB | Create a gentle unlock sound for opening the next investor education chapter. Mood: hopeful and calm. Texture: soft ascending particles, tiny door latch, clean final sparkle. Timing: 0.90 seconds. Loudness target: -16dB. Avoid aggressive game level-up sounds, EDM risers, or urgency. |
| `guidance_finale_12_cards.wav` | CH12 终章 12 卡环形展示 | 1.80s | 克制毕业仪式、温暖收束，-14dB | Create a short finale sound for completing a 12-chapter investor education path. Mood: warm, mature, proud but restrained. Texture: layered soft chimes, subtle card assembly, gentle low pad, no vocals. Timing: 1.80 seconds. Loudness target: -14dB. Avoid casino, triumphal military fanfare, and exaggerated mobile game victory sounds. |

| `quiz_correct_soft_chime_01.wav` | 答对音效 | 0.35s | 柔和木琴与轻铃答对音效，明亮但不刺耳 | Create a short 0.35s UI sound effect for a correct quiz answer in a finance education app. Texture: soft marimba or wooden xylophone followed by a light, clean chime. Mood: bright but not piercing, encouraging and restrained. Loudness target: -16dB. Avoid casino jackpot sounds or overly loud gaming fanfare. |
| `quiz_retry_warm_pop_01.wav` | 答错重试音效 | 0.45s | 温柔提示音，轻微 pop 加软木敲击，不制造失败感 | Create a gentle 0.45s prompt sound for a wrong quiz answer that needs a retry. Texture: soft cork tap or warm pop sound. Mood: low-stimulation, gentle, patient, no failure or shame feeling. Loudness target: -18dB. Avoid harsh buzzers, sharp beeps, or heavy impact sounds. |
| `card_unlock_gentle.wav` | 概念卡解锁 | 1.20s | 卡片翻转加柔光展开音效，克制、温暖、无老虎机感 | Create a 1.2s UI sound effect for unlocking and revealing a concept card. Texture: soft paper card flip followed by a gentle, warm glowing synth reveal. Mood: restrained, warm, satisfying. Loudness target: -14dB. Avoid slot machine sounds, heavy magic whooshes, or overly dramatic effects. |
| `myo_hint_chirp_01.wav` | Myo 提示气泡 | 0.20s | 短促可爱提示音，像小助手出现，不幼稚、不尖锐 | Create a very short 0.2s mascot prompt sound for a hint bubble appearing. Texture: short, cute, rounded electronic chirp. Mood: helpful, friendly, like a tiny assistant popping up. Loudness target: -18dB. Avoid childish toy sounds, sharp bird chirps, or alarm-like beeps. |

## 2. 待补全的交互音频提示词（尚未生成）

（目前所有规划的音频均已生成并接入）

## 3. 前端映射记录

- `guidance_concept_reveal.wav` -> `GuidanceLearningPage` (进入章节/点亮概念卡)
- `guidance_case_slide.wav` -> `GuidanceLearningPage` (点亮案例卡)
- `guidance_interaction_ready.wav` -> `GuidanceLearningPage` (点亮互动卡)
- `guidance_next_unlock.wav` -> `GuidanceLearningPage` (三步完成解锁小测)
- `guidance_passport_stamp.wav` -> `MyoPracticeBlock` (CH01–CH11 小测通过)
- `guidance_finale_12_cards.wav` -> `MyoPracticeBlock` (CH12 终章通过)
- `card_unlock_gentle.wav` -> `OnboardingRewardRevealStep` (首开引导奖励揭示)
- `quiz_correct_soft_chime_01.wav` -> `MyoPracticeBlock` (小测单题答对反馈)
- `quiz_retry_warm_pop_01.wav` -> `MyoPracticeBlock` (小测单题答错反馈)
- `myo_hint_chirp_01.wav` -> `OnboardingProfileLiteStep` (Myo 气泡出现反馈)
