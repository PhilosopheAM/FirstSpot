// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Guidance demo seed - default vault cards and badges for screen recording
// 模块: 投资者教育演示种子 - 金库录屏用默认卡牌与徽章
//
// Dependencies: (constants only)
// 依赖: （仅常量）
//
// Author: Harry Chen
// Email: 11911421@mail.sustech.edu.cn

/// SharedPreferences flag: vault demo progress was auto-seeded once.
/// 金库演示进度已自动注入一次的标记键。
const String vaultDemoSeededPrefKey = 'learning_guidance.vault_demo_seeded_v1';

/// Chapters 1–5 concept cards unlocked for vault carousel.
/// 金库卡牌：默认解锁第 1–5 章（CH01–CH05）。
const List<String> vaultDemoCompletedLessonIds = <String>[
  'CH01',
  'CH02',
  'CH03',
  'CH04',
  'CH05',
];

/// Chapter 1 quiz passed (pairs with [vaultDemoBadgeIds] practice badge).
/// 第 1 章小测已通过（配合「小测通关」徽章）。
const List<String> vaultDemoPassedQuizLessonIds = <String>['CH01'];

/// Three milestone badges shown in vault badge mode.
/// 金库徽章模式默认展示 3 枚成就徽章。
const List<String> vaultDemoBadgeIds = <String>[
  'learning_onboarding_start',
  'practice_drill_master',
  'review_recap_master',
];
