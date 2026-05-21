// Last Updated: 2026-05-21
// 最后更新: 2026-05-21
//
// Module: Guidance user progress - session reward and collectible state
// 模块: 投资者教育用户进度 - 会话内奖励与收藏状态
//
// Dependencies: flutter/foundation.dart, shared_preferences, guidance_lessons, guidance_rewards, guidance_models, guidance_demo_seed
// 依赖: flutter/foundation.dart, shared_preferences, guidance_lessons, guidance_rewards, guidance_models, guidance_demo_seed
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/guidance_models.dart';
import 'guidance_demo_seed.dart';
import 'guidance_lessons.dart';
import 'guidance_rewards.dart';

final GuidanceUserProgress guidanceUserProgress = GuidanceUserProgress();

/// When true, first empty learning progress seeds vault demo cards/badges.
/// 为 true 时，首次无学习进度会注入金库演示卡牌与徽章。

const String _completedLearningKey =
    'learning_guidance.completed_learning_lessons';
const String _passedQuizKey = 'learning_guidance.passed_quiz_lessons';
const String _earnedBadgeKey = 'learning_guidance.earned_badge_rewards';

class GuidanceUserProgress extends ChangeNotifier {
  GuidanceUserProgress({this.seedVaultDemoOnFirstEmpty = true});

  final bool seedVaultDemoOnFirstEmpty;

  final Set<String> _completedLearningLessonIds = <String>{};
  final Set<String> _passedQuizLessonIds = <String>{};
  final Set<String> _earnedBadgeRewardIds = <String>{};
  bool _hasLoaded = false;
  bool _isLoading = false;

  List<GuidanceLesson> get earnedCards {
    return guidanceLessons
        .where(
          (GuidanceLesson lesson) =>
              _completedLearningLessonIds.contains(lesson.id),
        )
        .toList(growable: false);
  }

  List<GuidanceBadgeReward> get earnedBadges {
    return guidanceBadgeRewards
        .where(
          (GuidanceBadgeReward reward) =>
              _earnedBadgeRewardIds.contains(reward.id),
        )
        .toList(growable: false);
  }

  bool hasCompletedLearning(GuidanceLesson lesson) {
    return _completedLearningLessonIds.contains(lesson.id);
  }

  bool hasPassedQuiz(GuidanceLesson lesson) {
    return _passedQuizLessonIds.contains(lesson.id);
  }

  bool hasEarnedBadge(String rewardId) {
    return _earnedBadgeRewardIds.contains(rewardId);
  }

  Future<void> load() async {
    if (_hasLoaded || _isLoading) {
      return;
    }
    _isLoading = true;
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      _completedLearningLessonIds.addAll(
        preferences.getStringList(_completedLearningKey) ?? <String>[],
      );
      _passedQuizLessonIds.addAll(
        preferences.getStringList(_passedQuizKey) ?? <String>[],
      );
      _earnedBadgeRewardIds.addAll(
        preferences.getStringList(_earnedBadgeKey) ?? <String>[],
      );
      await _maybeSeedVaultDemo(preferences);
      _hasLoaded = true;
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }

  bool markLessonLearningCompleted(GuidanceLesson lesson) {
    final bool newlyCompleted = _completedLearningLessonIds.add(lesson.id);
    bool changed = newlyCompleted;

    if (newlyCompleted && lesson.chapterNumber == 1) {
      changed = _earnBadge('learning_onboarding_start') || changed;
    }
    if (newlyCompleted && lesson.chapterNumber == 6) {
      changed = _earnBadge('progress_halfway') || changed;
    }
    if (newlyCompleted &&
        _completedLearningLessonIds.length >= guidanceLessons.length) {
      changed = _earnBadge('level_scholar_max') || changed;
    }

    if (changed) {
      notifyListeners();
      unawaited(_save());
    }
    return newlyCompleted;
  }

  bool markQuizPassed(GuidanceLesson lesson) {
    final bool newlyPassed = _passedQuizLessonIds.add(lesson.id);
    bool changed = newlyPassed;

    if (newlyPassed && lesson.chapterNumber == 1) {
      changed = _earnBadge('practice_drill_master') || changed;
    }

    if (changed) {
      notifyListeners();
      unawaited(_save());
    }
    return newlyPassed;
  }

  bool markConceptReviewOpenedAfterCompletion() {
    final bool changed = _earnBadge('review_recap_master');
    if (changed) {
      notifyListeners();
      unawaited(_save());
    }
    return changed;
  }

  void resetForTesting() {
    _completedLearningLessonIds.clear();
    _passedQuizLessonIds.clear();
    _earnedBadgeRewardIds.clear();
    _hasLoaded = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Clears in-memory progress and reloads from SharedPreferences (tests).
  /// 清空内存进度并从 SharedPreferences 重新加载（测试用）。
  Future<void> reloadFromPrefsForTesting() async {
    _completedLearningLessonIds.clear();
    _passedQuizLessonIds.clear();
    _earnedBadgeRewardIds.clear();
    _hasLoaded = false;
    _isLoading = false;
    await load();
  }

  /// Clears all learning progress and vault demo seed flag.
  /// 清空全部学习进度与金库演示种子标记。
  Future<void> clearAllProgress() async {
    _completedLearningLessonIds.clear();
    _passedQuizLessonIds.clear();
    _earnedBadgeRewardIds.clear();
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await Future.wait(<Future<bool>>[
      preferences.remove(_completedLearningKey),
      preferences.remove(_passedQuizKey),
      preferences.remove(_earnedBadgeKey),
      preferences.remove(vaultDemoSeededPrefKey),
    ]);
    _hasLoaded = true;
    notifyListeners();
  }

  Future<void> _maybeSeedVaultDemo(SharedPreferences preferences) async {
    if (!seedVaultDemoOnFirstEmpty) {
      return;
    }
    if (preferences.getBool(vaultDemoSeededPrefKey) == true) {
      return;
    }
    if (_completedLearningLessonIds.isNotEmpty) {
      return;
    }
    _completedLearningLessonIds.addAll(vaultDemoCompletedLessonIds);
    _passedQuizLessonIds.addAll(vaultDemoPassedQuizLessonIds);
    _earnedBadgeRewardIds.addAll(vaultDemoBadgeIds);
    await preferences.setBool(vaultDemoSeededPrefKey, true);
    await _save();
  }

  bool _earnBadge(String rewardId) {
    return _earnedBadgeRewardIds.add(rewardId);
  }

  Future<void> _save() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await Future.wait(<Future<bool>>[
      preferences.setStringList(
        _completedLearningKey,
        _completedLearningLessonIds.toList(growable: false),
      ),
      preferences.setStringList(
        _passedQuizKey,
        _passedQuizLessonIds.toList(growable: false),
      ),
      preferences.setStringList(
        _earnedBadgeKey,
        _earnedBadgeRewardIds.toList(growable: false),
      ),
    ]);
  }
}
