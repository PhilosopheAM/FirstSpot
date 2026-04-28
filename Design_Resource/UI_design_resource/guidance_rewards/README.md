# Guidance Rewards - Collectible Rules

> Last Updated: 2026-04-29  
> 用途: 记录投资者教育收藏奖励的美术资源边界和历史提示词归档状态。

## 当前规则

- 每完成一个章节学习，用户获得对应章节卡片。卡片使用 `Design_Resource/UI_design_resource/guidance_cards/` 的 12 张章节主视觉。
- 徽章不是每章奖励，只在 5 个首次里程碑发放。
- 当前 5 个徽章资源都已经存在于 `Design_Resource/UI_design_resource/badges/`，运行时同步路径为 `testapp/assets/images/badges/`。
- 本目录不再作为“12 章专属徽章缺口素材”目录使用；保留 README 是为了说明此前规划已被新的卡片/徽章拆分规则替代。

## 当前使用的徽章资源

| 首次任务节点 | 设计资源 |
| --- | --- |
| 首次完成第 1 章学习 | `../badges/achievement_learning_onboarding_start_round_bunny.png` |
| 首次完成第 1 章小测 | `../badges/achievement_practice_drill_master_card_hamster.png` |
| 首次完成第 6 章学习 | `../badges/achievement_progress_halfway_card_turtle.png` |
| 首次在完成概念对话后再次进入复习 | `../badges/achievement_review_recap_master_card_panda.png` |
| 首次完成全部 12 章学习 | `../badges/achievement_level_scholar_max_card_lion.png` |

## 后续新增素材约束

如果未来新增徽章或卡片衍生图，仍需参考 `Design_Resource/UI_design_resource/characters/myo/` 的 Myo 风格:

- 粗黑手绘线条、米白角色主体、薄荷绿辅助色、轻量金融学习陪伴感。
- 文案只使用简体中文和数字。
- 不出现真实股票、基金、券商、Logo、收益承诺或买卖建议。
- 奖励表达为学习记录，不表达投资能力认证或收益等级。
