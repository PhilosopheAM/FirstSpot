import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/learning_guidance/data/guidance_concept_dialogues.dart';
import 'package:testapp/features/learning_guidance/data/guidance_lessons.dart';
import 'package:testapp/features/learning_guidance/data/guidance_rewards.dart';
import 'package:testapp/features/learning_guidance/data/guidance_user_progress.dart';
import 'package:testapp/features/learning_guidance/domain/guidance_models.dart';
import 'package:testapp/features/learning_guidance/pages/guidance_learning_page.dart';
import 'package:testapp/features/onboarding/pages/vault_page.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    guidanceUserProgress.resetForTesting();
  });

  testWidgets('Guidance learning page renders all 12 chapters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    expect(guidanceLessons, hasLength(12));
    expect(guidanceConceptDialogues, hasLength(12));
    for (final MapEntry<int, GuidanceConceptDialogue> entry
        in guidanceConceptDialogues.entries) {
      expect(entry.value.turns, hasLength(7));
      expect(entry.value.turns.length * 2, lessThanOrEqualTo(50));
    }
    expect(find.text('新手村课程'), findsOneWidget);
    expect(find.textContaining('什么是二级市场'), findsOneWidget);
  });

  test('Concept dialogues use seven guided nodes within 50 turns', () {
    for (final GuidanceConceptDialogue dialogue
        in guidanceConceptDialogues.values) {
      expect(dialogue.turns, hasLength(7));
      expect(dialogue.turns.length * 2, lessThanOrEqualTo(50));
      for (final GuidanceConceptTurn turn in dialogue.turns) {
        expect(turn.options, hasLength(3));
      }
    }
  });

  test('Guidance collectibles split chapter cards from milestone badges', () {
    expect(guidanceLessons, hasLength(12));
    expect(guidanceBadgeRewards, hasLength(5));

    expect(
      guidanceBadgeRewards.map(
        (GuidanceBadgeReward reward) => reward.assetPath,
      ),
      containsAll(<String>[
        'assets/images/badges/achievement_learning_onboarding_start_round_bunny.png',
        'assets/images/badges/achievement_practice_drill_master_card_hamster.png',
        'assets/images/badges/achievement_progress_halfway_card_turtle.png',
        'assets/images/badges/achievement_review_recap_master_card_panda.png',
        'assets/images/badges/achievement_level_scholar_max_card_lion.png',
      ]),
    );
    for (final GuidanceLesson lesson in guidanceLessons) {
      expect(lesson.heroAsset, startsWith('assets/images/guidance_cards/'));
    }
  });

  test('Guidance user progress grants cards and first-time badges once', () {
    final GuidanceLesson chapterOne = guidanceLessons.first;
    final GuidanceLesson chapterSix = guidanceLessons[5];

    expect(guidanceUserProgress.earnedCards, isEmpty);
    expect(guidanceUserProgress.earnedBadges, isEmpty);

    expect(
      guidanceUserProgress.markLessonLearningCompleted(chapterOne),
      isTrue,
    );
    expect(
      guidanceUserProgress.markLessonLearningCompleted(chapterOne),
      isFalse,
    );
    expect(guidanceUserProgress.earnedCards, contains(chapterOne));
    expect(
      guidanceUserProgress.hasEarnedBadge('learning_onboarding_start'),
      isTrue,
    );

    expect(guidanceUserProgress.markQuizPassed(chapterOne), isTrue);
    expect(guidanceUserProgress.markQuizPassed(chapterOne), isFalse);
    expect(
      guidanceUserProgress.hasEarnedBadge('practice_drill_master'),
      isTrue,
    );

    guidanceUserProgress.markLessonLearningCompleted(chapterSix);
    expect(guidanceUserProgress.hasEarnedBadge('progress_halfway'), isTrue);

    guidanceUserProgress.markConceptReviewOpenedAfterCompletion();
    expect(guidanceUserProgress.hasEarnedBadge('review_recap_master'), isTrue);

    for (final GuidanceLesson lesson in guidanceLessons) {
      guidanceUserProgress.markLessonLearningCompleted(lesson);
    }
    expect(guidanceUserProgress.earnedCards, hasLength(12));
    expect(guidanceUserProgress.hasEarnedBadge('level_scholar_max'), isTrue);
  });

  testWidgets('Vault page switches between card and badge collections', (
    WidgetTester tester,
  ) async {
    guidanceUserProgress.markLessonLearningCompleted(guidanceLessons.first);
    guidanceUserProgress.markQuizPassed(guidanceLessons.first);

    await tester.pumpWidget(const MaterialApp(home: VaultPage()));
    await tester.pumpAndSettle();

    expect(find.text('卡片'), findsOneWidget);
    expect(find.text('徽章'), findsOneWidget);
    expect(find.textContaining('CARD-01'), findsWidgets);

    await tester.tap(find.text('徽章'));
    await tester.pumpAndSettle();

    expect(find.text('小测通关徽章'), findsOneWidget);
  });

  testWidgets('Chapter one concept card opens Myo chat from saved progress', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('进入概念对话'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('第 1 章 · 概念对话'), findsOneWidget);
    expect(find.textContaining('Myo 先拆开一个常见误会'), findsOneWidget);

    await tester.tap(find.text('所以更像二手转让？'));
    await tester.pump();
    expect(find.text('...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 8));
    expect(find.textContaining('演唱会票'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('继续概念对话'), findsOneWidget);

    await tester.tap(find.text('继续概念对话'));
    await tester.pumpAndSettle();

    expect(find.text('所以更像二手转让？'), findsOneWidget);
    expect(find.textContaining('官方售票'), findsOneWidget);
  });

  testWidgets('Guidance lesson detail teaches before passport quiz', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();

    expect(find.text('什么是二级市场'), findsOneWidget);
    expect(find.text('先学：概念、案例、互动'), findsOneWidget);
    expect(find.text('进入概念对话'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('章末通行证先锁住'), 260);
    expect(find.textContaining('章末通行证先锁住'), findsOneWidget);
  });

  testWidgets('Later chapters stay locked until previous learning completes', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('认识沪深北交易所'));
    await tester.pumpAndSettle();

    expect(find.text('新手村课程'), findsOneWidget);
    expect(find.textContaining('先完成第 1 章学习内容'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await _completeChapterOneConceptChat(tester);

    await _completeChapterOneCaseAndInteraction(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('认识沪深北交易所'));
    await tester.pumpAndSettle();

    expect(find.text('认识沪深北交易所与主要板块'), findsOneWidget);
  });

  testWidgets('Glossary only shows terms unlocked by completed lessons', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.text('词汇表'));
    await tester.pumpAndSettle();

    expect(find.textContaining('先完成第 1 章的学习卡片'), findsOneWidget);

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await _completeChapterOneConceptChat(tester);

    await _completeChapterOneCaseAndInteraction(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('已解锁'), findsOneWidget);

    await tester.tap(find.text('词汇表'));
    await tester.pumpAndSettle();

    expect(find.text('二级市场'), findsWidgets);
    expect(find.text('股票'), findsWidgets);
  });

  testWidgets('Completing learning steps unlocks passport quiz', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await _completeChapterOneConceptChat(tester);

    await _completeChapterOneCaseAndInteraction(tester);

    await tester.scrollUntilVisible(find.text('章末通行证小测'), 260);
    expect(find.text('章末通行证小测'), findsOneWidget);
    expect(find.textContaining('你在二级市场买入'), findsOneWidget);
  });

  testWidgets('Chapter one case opens scrolling Myo IPO explanation', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('进入案例讲解'),
      260,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text('进入案例讲解'));
    await tester.pumpAndSettle();

    expect(find.text('案例 · IPO 股份旅程'), findsOneWidget);
    expect(find.textContaining('Myo：跟我从公司出发'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('ipo_case_drag_card_1')),
      findsOneWidget,
    );

    for (int i = 1; i < 6; i += 1) {
      await _dragCaseParticipant(
        tester,
        dragCardIndex: i,
        dropTargetIndex: i - 1,
      );
      await tester.pumpAndSettle();
    }

    expect(find.textContaining('案例点亮', findRichText: true), findsOneWidget);
    await tester.tap(find.text('返回章节'));
    await tester.pumpAndSettle();

    expect(find.text('复习案例讲解'), findsOneWidget);
  });

  testWidgets('Finance glossary opens a closable explanation dialog in chat', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('进入概念对话'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('二级市场').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('已经发行出来的股票'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('已经发行出来的股票'), findsNothing);
  });

  testWidgets('Completed concept chat praises user and returns to lesson', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GuidanceLearningPage()));
    await tester.pump();

    await tester.tap(find.textContaining('什么是二级市场'));
    await tester.pumpAndSettle();
    await _completeChapterOneConceptChat(tester, closeAfterComplete: false);

    expect(find.textContaining('太棒了，你已经了解了第 1 章'), findsOneWidget);
    expect(find.text('返回章节'), findsOneWidget);

    await tester.tap(find.text('返回章节'));
    await tester.pumpAndSettle();

    expect(find.text('复习概念对话'), findsOneWidget);
  });
}

Future<void> _completeChapterOneConceptChat(
  WidgetTester tester, {
  bool closeAfterComplete = true,
}) async {
  await tester.tap(find.text('进入概念对话'));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));

  for (final String optionText in <String>[
    '所以更像二手转让？',
    '第一次卖出时，钱才主要进发行人那里。',
    '买方付钱，卖方交出股票。',
    '那我是不是就买不到或卖不掉？',
    '流动性好不等于收益高。',
    '价格是在买卖拉扯中形成的。',
    '我能总结为“投资者之间转让”。',
  ]) {
    final Finder option = find.text(optionText);
    for (int i = 0; i < 8 && option.evaluate().isEmpty; i += 1) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.ensureVisible(option);
    await tester.pump();
    await tester.tap(option);
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
  }

  final Finder completePraise = find.textContaining('太棒了，你已经了解了第 1 章');
  await tester.scrollUntilVisible(
    completePraise,
    260,
    scrollable: find.byType(Scrollable).last,
  );
  expect(completePraise, findsOneWidget);
  if (closeAfterComplete) {
    await tester.tap(find.text('返回章节'));
    await tester.pumpAndSettle();
  }
}

Future<void> _completeChapterOneCaseAndInteraction(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('进入案例讲解'),
    260,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text('进入案例讲解'));
  await tester.pumpAndSettle();

  await tester.pump(const Duration(milliseconds: 1800));
  await tester.pumpAndSettle();

  for (int i = 1; i < 6; i += 1) {
    await _dragCaseParticipant(
      tester,
      dragCardIndex: i,
      dropTargetIndex: i - 1,
    );
    await tester.pumpAndSettle();
  }

  await tester.tap(find.text('返回章节'));
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.touch_app_rounded).first);
  await tester.pumpAndSettle();
}

Future<void> _dragCaseParticipant(
  WidgetTester tester, {
  required int dragCardIndex,
  required int dropTargetIndex,
}) async {
  final Finder dragCard = find.byKey(
    ValueKey<String>('ipo_case_drag_card_$dragCardIndex'),
  );
  final Finder dropTarget = find.byKey(
    ValueKey<String>('ipo_case_drop_target_$dropTargetIndex'),
  );

  await tester.ensureVisible(dropTarget);
  await tester.pump();

  final Offset dragStart = tester.getCenter(dragCard);
  final Offset dropCenter = tester.getCenter(dropTarget);
  final TestGesture gesture = await tester.startGesture(dragStart);
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 120));
  await gesture.moveTo(dropCenter);
  await tester.pump(const Duration(milliseconds: 180));
  await gesture.up();
  await tester.pump(const Duration(milliseconds: 260));
}
