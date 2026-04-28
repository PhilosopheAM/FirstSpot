# Learning Guidance Practice Assets

> Last Updated: 2026-04-28  
> 用途：FirstSpot 投资者教育 12 章章末通行证小测的可复用练习背景与结果插画。

## 文件清单

| 文件 | 用途 | 前端同步位置 |
| --- | --- | --- |
| `practice_single_choice_card_bg.png` | 单选 / 场景题卡片背景版本 A | `testapp/assets/images/learning_guidance/` |
| `practice_single_choice_card_bg_02.png` | 单选 / 场景题卡片背景版本 B | `testapp/assets/images/learning_guidance/` |
| `practice_match_card_bg.png` | 匹配 / 排序题卡片背景版本 A | `testapp/assets/images/learning_guidance/` |
| `practice_match_card_bg_02.png` | 匹配 / 排序题卡片背景版本 B | `testapp/assets/images/learning_guidance/` |
| `practice_summary_pass.png` | 章末小测通过结果插画版本 A | `testapp/assets/images/learning_guidance/` |
| `practice_summary_pass_02.png` | 章末小测通过结果插画版本 B | `testapp/assets/images/learning_guidance/` |
| `practice_summary_retry.png` | 章末小测重练鼓励插画版本 A | `testapp/assets/images/learning_guidance/` |
| `practice_summary_retry_02.png` | 章末小测重练鼓励插画版本 B | `testapp/assets/images/learning_guidance/` |
| `myo_quiz_correct_micro.png` | 章末小测答对即时反馈小头像 | `testapp/assets/images/learning_guidance/` |
| `myo_quiz_retry_micro.png` | 章末小测答错重试提示小头像 | `testapp/assets/images/learning_guidance/` |

## 使用规则

- 这些图片是由用户按照 `UX-Product-Design/guidance/14_先教育再小测学习闭环与素材补全记录.md` 中的提示词生成的最终素材。
- 本目录保存设计资源归档版本；Flutter 运行时读取 `testapp/assets/images/learning_guidance/` 下的同步副本。
- 图片不包含真实股票、基金、券商 Logo、收益承诺或买卖建议，只用于投资者教育的练习氛围和反馈表达。
- 新增同类素材时，应先归档到本目录，再同步到 Flutter assets，并更新 `pubspec.yaml`、`PROJECT_STRUCTURE.md` 与 `developer_maintenance/frontend/feature-learning-guidance.md`。
