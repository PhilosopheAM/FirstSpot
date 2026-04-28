import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testapp/features/learning_guidance/data/guidance_concept_dialogues.dart';
import 'package:testapp/features/learning_guidance/data/guidance_lessons.dart';
import 'package:testapp/features/learning_guidance/domain/guidance_models.dart';
import 'package:testapp/features/learning_guidance/pages/guidance_learning_page.dart';

void main() {
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

    expect(find.text('第 1 章 · 概念对话'), findsOneWidget);
    expect(find.textContaining('Myo 先拆开一个常见误会'), findsOneWidget);

    await tester.tap(find.text('所以更像二手转让？'));
    await tester.pumpAndSettle();
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

    for (int i = 0; i < 2; i += 1) {
      await tester.tap(find.text('点一下，完成这步').first);
      await tester.pumpAndSettle();
    }

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

    for (int i = 0; i < 2; i += 1) {
      await tester.tap(find.text('点一下，完成这步').first);
      await tester.pumpAndSettle();
    }

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

    for (int i = 0; i < 2; i += 1) {
      await tester.tap(find.text('点一下，完成这步').first);
      await tester.pumpAndSettle();
    }

    await tester.scrollUntilVisible(find.text('章末通行证小测'), 260);
    expect(find.text('章末通行证小测'), findsOneWidget);
    expect(find.textContaining('你在二级市场买入'), findsOneWidget);
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
    await tester.tap(find.text('二级市场').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('已经发行出来的股票'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('已经发行出来的股票'), findsNothing);
  });
}

Future<void> _completeChapterOneConceptChat(WidgetTester tester) async {
  await tester.tap(find.text('进入概念对话'));
  await tester.pumpAndSettle();

  for (final String optionText in <String>[
    '所以更像二手转让？',
    '第一次卖出时，钱才主要进发行人那里。',
    '买方付钱，卖方交出股票。',
    '那我是不是就买不到或卖不掉？',
    '流动性好不等于收益高。',
    '价格是在买卖拉扯中形成的。',
    '我能总结为“投资者之间转让”。',
  ]) {
    await tester.tap(find.text(optionText));
    await tester.pumpAndSettle();
  }

  expect(find.textContaining('概念对话已完成'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.arrow_back_rounded));
  await tester.pumpAndSettle();
}
