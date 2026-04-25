// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Learning guidance models - immutable lesson, dialogue, and quiz structures
// 模块: 投资者教育模型 - 章节、对话与练习题的不可变结构
//
// Dependencies: None
// 依赖: 无
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

enum GuidanceQuestionType {
  singleChoice('单选'),
  scenarioChoice('场景'),
  matchChoice('匹配'),
  sortChoice('排序');

  const GuidanceQuestionType(this.label);
  final String label;
}

class GuidanceOption {
  const GuidanceOption({required this.id, required this.text});

  final String id;
  final String text;
}

class GuidanceQuestion {
  const GuidanceQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    required this.correctFeedback,
    required this.repairFeedback,
  });

  final String id;
  final GuidanceQuestionType type;
  final String prompt;
  final List<GuidanceOption> options;
  final String correctOptionId;
  final String explanation;
  final String correctFeedback;
  final String repairFeedback;
}

class GuidanceLesson {
  const GuidanceLesson({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.rarity,
    required this.cardName,
    required this.heroAsset,
    required this.myoIntro,
    required this.learningGoals,
    required this.keyPoints,
    required this.questions,
  });

  final String id;
  final int chapterNumber;
  final String title;
  final String subtitle;
  final String rarity;
  final String cardName;
  final String heroAsset;
  final String myoIntro;
  final List<String> learningGoals;
  final List<String> keyPoints;
  final List<GuidanceQuestion> questions;
}

class GuidanceConceptDialogue {
  const GuidanceConceptDialogue({
    required this.lessonId,
    required this.chapterNumber,
    required this.turns,
  });

  final String lessonId;
  final int chapterNumber;
  final List<GuidanceConceptTurn> turns;
}

class GuidanceConceptTurn {
  const GuidanceConceptTurn({
    required this.id,
    required this.myoText,
    required this.options,
    this.highlightedTerms = const <String>{},
  });

  final String id;
  final String myoText;
  final Set<String> highlightedTerms;
  final List<GuidanceConceptOption> options;
}

class GuidanceConceptOption {
  const GuidanceConceptOption({
    required this.id,
    required this.text,
    required this.myoResponse,
    this.highlightedTerms = const <String>{},
  });

  final String id;
  final String text;
  final String myoResponse;
  final Set<String> highlightedTerms;
}
