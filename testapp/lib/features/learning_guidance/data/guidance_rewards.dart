// Last Updated: 2026-04-29
// 最后更新: 2026-04-29
//
// Module: Guidance badge reward data - first-time milestone badge content
// 模块: 投资者教育徽章奖励数据 - 首次里程碑徽章内容
//
// Dependencies: guidance_models
// 依赖: guidance_models
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

import '../domain/guidance_models.dart';

const String _badgeAssetBase = 'assets/images/badges';
const String _badgeDesignBase = 'Design_Resource/UI_design_resource/badges';

const List<GuidanceBadgeReward> guidanceBadgeRewards = <GuidanceBadgeReward>[
  GuidanceBadgeReward(
    id: 'learning_onboarding_start',
    title: '学习启程徽章',
    subtitle: '第一次完成第 1 章学习',
    trigger: GuidanceBadgeRewardTrigger.firstChapterOneLearningComplete,
    triggerLabel: '首次完成第 1 章学习',
    assetPath:
        '$_badgeAssetBase/achievement_learning_onboarding_start_round_bunny.png',
    designResourcePath:
        '$_badgeDesignBase/achievement_learning_onboarding_start_round_bunny.png',
  ),
  GuidanceBadgeReward(
    id: 'practice_drill_master',
    title: '小测通关徽章',
    subtitle: '第一次完成第 1 章小测',
    trigger: GuidanceBadgeRewardTrigger.firstChapterOneQuizPass,
    triggerLabel: '首次通过第 1 章章末小测',
    assetPath:
        '$_badgeAssetBase/achievement_practice_drill_master_card_hamster.png',
    designResourcePath:
        '$_badgeDesignBase/achievement_practice_drill_master_card_hamster.png',
  ),
  GuidanceBadgeReward(
    id: 'progress_halfway',
    title: '半程进度徽章',
    subtitle: '第一次完成第 6 章学习',
    trigger: GuidanceBadgeRewardTrigger.firstChapterSixLearningComplete,
    triggerLabel: '首次完成第 6 章学习',
    assetPath: '$_badgeAssetBase/achievement_progress_halfway_card_turtle.png',
    designResourcePath:
        '$_badgeDesignBase/achievement_progress_halfway_card_turtle.png',
  ),
  GuidanceBadgeReward(
    id: 'review_recap_master',
    title: '复习回顾徽章',
    subtitle: '第一次进入已完成概念对话的复习',
    trigger: GuidanceBadgeRewardTrigger.firstConceptReviewAfterCompletion,
    triggerLabel: '首次在完成概念对话后再次进入复习',
    assetPath:
        '$_badgeAssetBase/achievement_review_recap_master_card_panda.png',
    designResourcePath:
        '$_badgeDesignBase/achievement_review_recap_master_card_panda.png',
  ),
  GuidanceBadgeReward(
    id: 'level_scholar_max',
    title: '新手村学者徽章',
    subtitle: '第一次完成全部 12 章学习',
    trigger: GuidanceBadgeRewardTrigger.firstAllChaptersLearningComplete,
    triggerLabel: '首次完成全部 12 章学习',
    assetPath: '$_badgeAssetBase/achievement_level_scholar_max_card_lion.png',
    designResourcePath:
        '$_badgeDesignBase/achievement_level_scholar_max_card_lion.png',
  ),
];

final Map<String, GuidanceBadgeReward> guidanceBadgeRewardById =
    <String, GuidanceBadgeReward>{
      for (final GuidanceBadgeReward reward in guidanceBadgeRewards)
        reward.id: reward,
    };
