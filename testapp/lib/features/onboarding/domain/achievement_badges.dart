enum AchievementBadgeCategory {
  learning,
  habit,
  streak,
  focus,
  practice,
  review,
  progress,
  level,
}

enum AchievementBadgeStyle { round, card }

enum AchievementBadgeRarity { common, rare, epic, legendary }

class AchievementBadgeAsset {
  const AchievementBadgeAsset({
    required this.id,
    required this.titleZh,
    required this.category,
    required this.style,
    required this.rarity,
    required this.assetPath,
    required this.triggerDescription,
  });

  final String id;
  final String titleZh;
  final AchievementBadgeCategory category;
  final AchievementBadgeStyle style;
  final AchievementBadgeRarity rarity;
  final String assetPath;
  final String triggerDescription;
}

const achievementBadgeAssets = <AchievementBadgeAsset>[
  AchievementBadgeAsset(
    id: 'learning_onboarding_start',
    titleZh: '学习启程',
    category: AchievementBadgeCategory.learning,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.common,
    assetPath:
        'assets/images/badges/achievement_learning_onboarding_start_round_bunny.png',
    triggerDescription: '完成首开引导的学习承诺卡',
  ),
  AchievementBadgeAsset(
    id: 'habit_daily_checkin',
    titleZh: '今日打卡',
    category: AchievementBadgeCategory.habit,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.common,
    assetPath:
        'assets/images/badges/achievement_habit_daily_checkin_round_bear.png',
    triggerDescription: '完成当天第一项学习任务',
  ),
  AchievementBadgeAsset(
    id: 'streak_3_day_combo',
    titleZh: '三日连击',
    category: AchievementBadgeCategory.streak,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_streak_3_day_combo_round_penguin.png',
    triggerDescription: '连续学习 3 天',
  ),
  AchievementBadgeAsset(
    id: 'streak_7_day_persist',
    titleZh: '七日坚持',
    category: AchievementBadgeCategory.streak,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.epic,
    assetPath:
        'assets/images/badges/achievement_streak_7_day_persist_round_shiba.png',
    triggerDescription: '连续学习 7 天',
  ),
  AchievementBadgeAsset(
    id: 'focus_30_min_session',
    titleZh: '专注 30 分',
    category: AchievementBadgeCategory.focus,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_focus_30_min_session_round_cat.png',
    triggerDescription: '单次专注学习达到 30 分钟',
  ),
  AchievementBadgeAsset(
    id: 'learning_reading_master',
    titleZh: '阅读达人',
    category: AchievementBadgeCategory.learning,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.epic,
    assetPath:
        'assets/images/badges/achievement_learning_reading_master_round_owl.png',
    triggerDescription: '完成指定章节的深度阅读',
  ),
  AchievementBadgeAsset(
    id: 'practice_drill_master',
    titleZh: '练习高手',
    category: AchievementBadgeCategory.practice,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_practice_drill_master_round_hamster.png',
    triggerDescription: '完成一组练习清单',
  ),
  AchievementBadgeAsset(
    id: 'review_recap_master',
    titleZh: '复习能手',
    category: AchievementBadgeCategory.review,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_review_recap_master_round_panda.png',
    triggerDescription: '完成错题或知识点复盘',
  ),
  AchievementBadgeAsset(
    id: 'progress_halfway',
    titleZh: '进度过半',
    category: AchievementBadgeCategory.progress,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.epic,
    assetPath:
        'assets/images/badges/achievement_progress_halfway_round_turtle.png',
    triggerDescription: '学习路径总进度达到 50%',
  ),
  AchievementBadgeAsset(
    id: 'level_scholar_max',
    titleZh: '满级学霸',
    category: AchievementBadgeCategory.level,
    style: AchievementBadgeStyle.round,
    rarity: AchievementBadgeRarity.legendary,
    assetPath:
        'assets/images/badges/achievement_level_scholar_max_round_lion.png',
    triggerDescription: '达到 V1 学习等级上限',
  ),
  AchievementBadgeAsset(
    id: 'learning_onboarding_start',
    titleZh: '学习启程',
    category: AchievementBadgeCategory.learning,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.common,
    assetPath:
        'assets/images/badges/achievement_learning_onboarding_start_card_bunny.png',
    triggerDescription: '完成首开引导的学习承诺卡',
  ),
  AchievementBadgeAsset(
    id: 'habit_daily_checkin',
    titleZh: '今日打卡',
    category: AchievementBadgeCategory.habit,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.common,
    assetPath:
        'assets/images/badges/achievement_habit_daily_checkin_card_bear.png',
    triggerDescription: '完成当天第一项学习任务',
  ),
  AchievementBadgeAsset(
    id: 'streak_3_day_combo',
    titleZh: '三日连击',
    category: AchievementBadgeCategory.streak,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_streak_3_day_combo_card_penguin.png',
    triggerDescription: '连续学习 3 天',
  ),
  AchievementBadgeAsset(
    id: 'streak_7_day_persist',
    titleZh: '七日坚持',
    category: AchievementBadgeCategory.streak,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.epic,
    assetPath:
        'assets/images/badges/achievement_streak_7_day_persist_card_shiba.png',
    triggerDescription: '连续学习 7 天',
  ),
  AchievementBadgeAsset(
    id: 'focus_30_min_session',
    titleZh: '专注 30 分',
    category: AchievementBadgeCategory.focus,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_focus_30_min_session_card_cat.png',
    triggerDescription: '单次专注学习达到 30 分钟',
  ),
  AchievementBadgeAsset(
    id: 'learning_reading_master',
    titleZh: '阅读达人',
    category: AchievementBadgeCategory.learning,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.epic,
    assetPath:
        'assets/images/badges/achievement_learning_reading_master_card_owl.png',
    triggerDescription: '完成指定章节的深度阅读',
  ),
  AchievementBadgeAsset(
    id: 'practice_drill_master',
    titleZh: '练习高手',
    category: AchievementBadgeCategory.practice,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_practice_drill_master_card_hamster.png',
    triggerDescription: '完成一组练习清单',
  ),
  AchievementBadgeAsset(
    id: 'review_recap_master',
    titleZh: '复习能手',
    category: AchievementBadgeCategory.review,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.rare,
    assetPath:
        'assets/images/badges/achievement_review_recap_master_card_panda.png',
    triggerDescription: '完成错题或知识点复盘',
  ),
  AchievementBadgeAsset(
    id: 'progress_halfway',
    titleZh: '进度过半',
    category: AchievementBadgeCategory.progress,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.epic,
    assetPath:
        'assets/images/badges/achievement_progress_halfway_card_turtle.png',
    triggerDescription: '学习路径总进度达到 50%',
  ),
  AchievementBadgeAsset(
    id: 'level_scholar_max',
    titleZh: '满级学霸',
    category: AchievementBadgeCategory.level,
    style: AchievementBadgeStyle.card,
    rarity: AchievementBadgeRarity.legendary,
    assetPath:
        'assets/images/badges/achievement_level_scholar_max_card_lion.png',
    triggerDescription: '达到 V1 学习等级上限',
  ),
];

AchievementBadgeAsset? achievementBadgeAssetById(
  String id, {
  AchievementBadgeStyle style = AchievementBadgeStyle.round,
}) {
  for (final badge in achievementBadgeAssets) {
    if (badge.id == id && badge.style == style) {
      return badge;
    }
  }
  return null;
}
