// Last Updated: 2026-04-28
// 最后更新: 2026-04-28
//
// Module: Guidance learning page - 12 chapter investor education path
// 模块: 投资者教育学习页 - 12 章新手学习路径
//
// Dependencies: flutter/material.dart, guidance_concept_dialogues, guidance_glossary, guidance_lessons, guidance_models, myo_practice_block
// 依赖: flutter/material.dart, guidance_concept_dialogues, guidance_glossary, guidance_lessons, guidance_models, myo_practice_block
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../data/guidance_concept_dialogues.dart';
import '../data/guidance_glossary.dart';
import '../data/guidance_lessons.dart';
import '../domain/guidance_models.dart';
import '../widgets/finance_term_text.dart';
import '../widgets/myo_practice_block.dart';

class GuidanceLearningPage extends StatefulWidget {
  const GuidanceLearningPage({super.key});

  @override
  State<GuidanceLearningPage> createState() => _GuidanceLearningPageState();
}

class _GuidanceLearningPageState extends State<GuidanceLearningPage>
    with TickerProviderStateMixin {
  static const Duration _conceptMyoThinkingDelay = Duration(milliseconds: 800);

  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AnimationController _conceptChatController;
  late final AnimationController _caseDropPulseController;
  final ScrollController _conceptChatScrollController = ScrollController();
  final ScrollController _caseScrollController = ScrollController();

  GuidanceLesson? _selectedLesson;
  GuidanceLesson? _activeConceptLesson;
  GuidanceLesson? _activeCaseLesson;
  final Map<String, Set<int>> _completedLearningSteps = <String, Set<int>>{};
  final Map<String, int> _caseRevealedSegmentCounts = <String, int>{};
  bool _caseIntroVisible = false;
  bool _caseGuideVisible = false;
  bool _isCaseDragging = false;
  int _caseGuideToken = 0;
  final Map<String, List<String>> _conceptDialogueSelections =
      <String, List<String>>{};
  final Map<String, int> _conceptRevealedResponseCounts = <String, int>{};
  final Map<String, int> _conceptAdvancedTurnCounts = <String, int>{};
  String? _conceptTypingKey;
  int _conceptRevealToken = 0;
  late final Map<String, _TermFirstOccurrence> _firstTermOccurrences =
      _buildFirstTermOccurrences();

  @override
  void initState() {
    super.initState();
    _conceptChatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 420),
    );
    _caseDropPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    unawaited(_configureAudioPlayer());
  }

  @override
  void dispose() {
    _conceptChatController.dispose();
    _caseDropPulseController.dispose();
    _conceptChatScrollController.dispose();
    _caseScrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _configureAudioPlayer() async {
    try {
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (_) {
      // Learning must remain usable in test or restricted audio environments.
    }
  }

  @override
  Widget build(BuildContext context) {
    final GuidanceLesson? selected = _selectedLesson;
    final GuidanceLesson? activeConceptLesson = _activeConceptLesson;
    final GuidanceLesson? activeCaseLesson = _activeCaseLesson;
    final bool isConceptChatOpen =
        selected != null && activeConceptLesson != null;
    final bool isCaseOpen = selected != null && activeCaseLesson != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: isConceptChatOpen || isCaseOpen
          ? null
          : AppBar(
              backgroundColor: const Color(0xFFF7FAF8),
              elevation: 0,
              centerTitle: false,
              leading: selected == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => setState(() => _selectedLesson = null),
                    ),
              title: Text(
                selected == null ? '新手村课程' : '第 ${selected.chapterNumber} 章',
                style: const TextStyle(
                  color: Color(0xFF162025),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
      body: SafeArea(
        child: isCaseOpen
            ? _buildCaseRoute(activeCaseLesson)
            : isConceptChatOpen
            ? _buildConceptChatRoute(activeConceptLesson)
            : selected == null
            ? _buildLessonList()
            : _buildLessonDetail(selected),
      ),
    );
  }

  Widget _buildConceptChatRoute(GuidanceLesson lesson) {
    final Animation<Offset> slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _conceptChatController,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInBack,
          ),
        );

    return SlideTransition(
      position: slideAnimation,
      child: _buildConceptChatFrame(lesson),
    );
  }

  Widget _buildCaseRoute(GuidanceLesson lesson) {
    final int revealedCount = _caseRevealedSegmentCounts[lesson.id] ?? 0;
    final bool isComplete = revealedCount >= _ipoCaseSegments.length;
    final bool hasDropPrompt =
        !_caseIntroVisible &&
        _caseGuideVisible &&
        revealedCount > 0 &&
        !isComplete;
    return Container(
      color: const Color(0xFFF7FAF8),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 16, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      tooltip: '返回章节学习',
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: _closeCaseRoute,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            '案例 · IPO 股份旅程',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF162025),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            lesson.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF5D696F),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTinyPill(
                      '$revealedCount / ${_ipoCaseSegments.length}',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: _caseScrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
                  children: <Widget>[
                    const SizedBox(height: 44),
                    for (int i = 0; i < revealedCount; i += 1) ...<Widget>[
                      _buildCaseSegment(
                        lesson,
                        _ipoCaseSegments[i],
                        i,
                        isDropTarget: hasDropPrompt && i == revealedCount - 1,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (isComplete) _buildCaseCompleteCard(lesson),
                    if (hasDropPrompt) const SizedBox(height: 220),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            left: 20,
            right: 20,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _caseIntroVisible ? 1 : 0,
                duration: const Duration(milliseconds: 240),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F6FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFCFEFFF)),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Myo：跟我从公司出发，看一份股份怎样来到散户手里。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF086A9D),
                      height: 1.35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: AnimatedSlide(
              offset: _caseIntroVisible || hasDropPrompt
                  ? Offset.zero
                  : const Offset(0, 1.4),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: _caseIntroVisible || hasDropPrompt ? 1 : 0,
                duration: const Duration(milliseconds: 240),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.52,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/characters/myo/myo_lay_face_smile.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      if (hasDropPrompt)
                        Positioned(
                          left: 24,
                          right: 24,
                          bottom: 122,
                          child: _buildCaseGuidePanel(lesson, revealedCount),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseSegment(
    GuidanceLesson lesson,
    _IpoCaseSegment segment,
    int index, {
    bool isDropTarget = false,
  }) {
    Widget content = _buildCaseSegmentCard(segment, index, highlight: false);
    if (!isDropTarget) {
      return content;
    }

    final String expectedParticipant = _ipoCaseSegments[index + 1].participant;
    return DragTarget<String>(
      key: ValueKey<String>('ipo_case_drop_target_$index'),
      onWillAcceptWithDetails: (DragTargetDetails<String> details) {
        return details.data == expectedParticipant;
      },
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        _acceptCaseDrop(lesson, details.data);
      },
      builder:
          (
            BuildContext context,
            List<String?> candidateData,
            List<dynamic> rejectedData,
          ) {
            final bool highlight = _isCaseDragging && candidateData.isNotEmpty;
            return AnimatedBuilder(
              animation: _caseDropPulseController,
              builder: (BuildContext context, Widget? child) {
                return _buildCaseSegmentCard(
                  segment,
                  index,
                  highlight: highlight,
                  pulseValue: highlight ? _caseDropPulseController.value : 0,
                );
              },
            );
          },
    );
  }

  Widget _buildCaseSegmentCard(
    _IpoCaseSegment segment,
    int index, {
    required bool highlight,
    double pulseValue = 0,
  }) {
    final Color borderColor =
        Color.lerp(
          const Color(0xFFE6E8EC),
          const Color(0xFF1FA95B),
          highlight ? 0.55 + pulseValue * 0.45 : 0,
        ) ??
        const Color(0xFFE6E8EC);
    final Color glowColor =
        Color.lerp(
          const Color(0x08000000),
          const Color(0x331FA95B),
          highlight ? 0.35 + pulseValue * 0.65 : 0,
        ) ??
        const Color(0x08000000);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: highlight ? 2.4 : 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glowColor,
            blurRadius: highlight ? 24 : 12,
            spreadRadius: highlight ? 2 : 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF1FA95B),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FinanceTermText(
                  text: segment.title,
                  highlightedTerms: segment.terms,
                  style: const TextStyle(
                    color: Color(0xFF162025),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FinanceTermText(
            text: segment.body,
            highlightedTerms: segment.terms,
            style: const TextStyle(
              color: Color(0xFF5D696F),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (highlight) ...<Widget>[
            const SizedBox(height: 12),
            const Text(
              '把下一位股份参与方拖进来',
              style: TextStyle(
                color: Color(0xFF1FA95B),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCaseGuidePanel(GuidanceLesson lesson, int revealedCount) {
    final _IpoCaseSegment nextSegment = _ipoCaseSegments[revealedCount];
    final String promptText = '把“${nextSegment.participant}”拖进上一幕，看看股份下一站去哪里';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDDE6E1)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            promptText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF304348),
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: LongPressDraggable<String>(
            data: nextSegment.participant,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            onDragStarted: () {
              _caseDropPulseController.repeat(reverse: true);
              setState(() {
                _isCaseDragging = true;
              });
            },
            onDragEnd: (_) {
              if (!mounted) {
                return;
              }
              _caseDropPulseController
                ..stop()
                ..reset();
              setState(() {
                _isCaseDragging = false;
              });
            },
            feedback: Material(
              color: Colors.transparent,
              child: _buildCaseParticipantChip(
                nextSegment.participant,
                isDragging: true,
              ),
            ),
            childWhenDragging: _buildCaseParticipantChip(
              nextSegment.participant,
              isGhost: true,
            ),
            child: _buildCaseParticipantChip(
              nextSegment.participant,
              key: ValueKey<String>('ipo_case_drag_card_$revealedCount'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaseParticipantChip(
    String participant, {
    Key? key,
    bool isDragging = false,
    bool isGhost = false,
  }) {
    return AnimatedOpacity(
      key: key,
      opacity: isGhost ? 0.32 : 1,
      duration: const Duration(milliseconds: 160),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minWidth: 176, maxWidth: 232),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDragging ? const Color(0xFF1FA95B) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDragging
                ? const Color(0xFF127541)
                : const Color(0xFFD5E8DC),
            width: 2,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.open_with_rounded,
              color: isDragging ? Colors.white : const Color(0xFF1FA95B),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                participant,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDragging ? Colors.white : const Color(0xFF162025),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseCompleteCard(GuidanceLesson lesson) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8ED8A6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const FinanceTermText(
            text: '案例点亮：你已经走完 IPO 到二级市场的股份路线。',
            highlightedTerms: <String>{'IPO', '二级市场', '股份'},
            style: TextStyle(
              color: Color(0xFF1F5B39),
              height: 1.45,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _closeCaseRoute,
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('返回章节'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1FA95B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptChatFrame(GuidanceLesson lesson) {
    final GuidanceConceptDialogue? dialogue =
        guidanceConceptDialogues[lesson.chapterNumber];
    if (dialogue == null) {
      return _buildMissingConceptDialogue(lesson);
    }

    final List<String> selectedOptionIds =
        _conceptDialogueSelections[lesson.id] ?? <String>[];
    final int completedTurns = selectedOptionIds.length;
    final bool isComplete = completedTurns >= dialogue.turns.length;

    return Container(
      color: const Color(0xFFEAF5EF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 16, 8),
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: '返回章节学习',
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _closeConceptChat,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '第 ${lesson.chapterNumber} 章 · 概念对话',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF162025),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        lesson.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5D696F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTinyPill('$completedTurns / ${dialogue.turns.length}'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFEFE),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFD7E8DD), width: 2),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView(
                  controller: _conceptChatScrollController,
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                  children: <Widget>[
                    _buildChatMyoBubble(
                      '我们用聊天把概念拆开。进度会保留，左上角返回后，再点“概念”会从这里继续。',
                      highlightedTerms: const <String>{},
                      accent: true,
                    ),
                    const SizedBox(height: 12),
                    for (int i = 0; i < completedTurns; i += 1)
                      ..._buildCompletedConceptTurn(
                        lesson,
                        dialogue.turns[i],
                        i,
                        selectedOptionIds[i],
                      ),
                    if (!isComplete && _canShowNextConceptTurn(lesson))
                      _buildCurrentConceptTurn(
                        lesson,
                        dialogue.turns[completedTurns],
                      )
                    else if (!isComplete &&
                        _conceptTypingKey ==
                            _conceptPromptKey(lesson.id, completedTurns))
                      _buildConceptTypingBubble()
                    else if (isComplete && _canShowConceptComplete(lesson))
                      _buildConceptCompleteCard(lesson),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingConceptDialogue(GuidanceLesson lesson) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E8EC)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.chat_bubble_outline_rounded),
            const SizedBox(height: 10),
            Text(
              '第 ${lesson.chapterNumber} 章概念对话尚未配置。',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF162025),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _closeConceptChat,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('返回章节学习'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompletedConceptTurn(
    GuidanceLesson lesson,
    GuidanceConceptTurn turn,
    int turnIndex,
    String selectedOptionId,
  ) {
    final GuidanceConceptOption selectedOption = turn.options.firstWhere(
      (GuidanceConceptOption option) => option.id == selectedOptionId,
      orElse: () => turn.options.first,
    );
    final String responseKey = _conceptTurnKey(lesson.id, turnIndex);
    final List<String> responseSegments = _conceptResponseSegments(
      selectedOption.myoResponse,
    );
    final int visibleResponseCount =
        _conceptRevealedResponseCounts[responseKey] ?? responseSegments.length;
    final bool isTyping = _conceptTypingKey == responseKey;

    return <Widget>[
      _buildChatMyoBubble(
        turn.myoText,
        highlightedTerms: turn.highlightedTerms,
      ),
      const SizedBox(height: 8),
      _buildChatUserBubble(selectedOption.text),
      const SizedBox(height: 8),
      if (isTyping && visibleResponseCount == 0) ...<Widget>[
        _buildConceptTypingBubble(),
        const SizedBox(height: 8),
      ],
      for (int i = 0; i < visibleResponseCount; i += 1) ...<Widget>[
        _buildChatMyoBubble(
          responseSegments[i],
          highlightedTerms: selectedOption.highlightedTerms,
        ),
        const SizedBox(height: 8),
      ],
      if (isTyping && visibleResponseCount > 0) ...<Widget>[
        _buildConceptTypingBubble(),
        const SizedBox(height: 8),
      ],
      const SizedBox(height: 16),
    ];
  }

  Widget _buildCurrentConceptTurn(
    GuidanceLesson lesson,
    GuidanceConceptTurn turn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildChatMyoBubble(
          turn.myoText,
          highlightedTerms: turn.highlightedTerms,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: turn.options.map((GuidanceConceptOption option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildConceptOptionCard(lesson, turn, option),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConceptOptionCard(
    GuidanceLesson lesson,
    GuidanceConceptTurn turn,
    GuidanceConceptOption option,
  ) {
    return Material(
      color: const Color(0xFFFFF9F0),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _selectConceptOption(lesson, turn, option),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFE2A8), width: 2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  option.text,
                  style: const TextStyle(
                    color: Color(0xFF8A4B00),
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.send_rounded,
                size: 18,
                color: Color(0xFFB45309),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConceptCompleteCard(GuidanceLesson lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildChatMyoBubble(
          '太棒了，你已经了解了第 ${lesson.chapterNumber} 章「${lesson.title}」的核心概念。概念卡会保持点亮，接下来可以回到章节继续案例和互动。',
          highlightedTerms: const <String>{},
          accent: true,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: _closeConceptChat,
            icon: const Icon(Icons.inventory_2_rounded),
            label: const Text('返回章节'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1FA95B),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConceptTypingBubble() {
    return _buildChatMyoBubble(
      '...',
      highlightedTerms: const <String>{},
      accent: true,
    );
  }

  Widget _buildChatMyoBubble(
    String text, {
    required Set<String> highlightedTerms,
    bool accent = false,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 330),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD7E8DD), width: 2),
              ),
              child: Image.asset(
                'assets/images/characters/myo/myo_thinking.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: accent ? const Color(0xFFE4F6FF) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  border: Border.all(
                    color: accent
                        ? const Color(0xFFCFEFFF)
                        : const Color(0xFFE6E8EC),
                  ),
                ),
                child: FinanceTermText(
                  text: text,
                  highlightedTerms: highlightedTerms,
                  style: const TextStyle(
                    color: Color(0xFF23302A),
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 292),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFF1FA95B),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x141FA95B),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              height: 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: <Widget>[
        const Text(
          '和 Myo 一起把投资这件事拆小',
          style: TextStyle(
            fontSize: 26,
            height: 1.15,
            color: Color(0xFF162025),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '12 章内容只做投资者教育，不荐股、不加杠杆。每章先学概念和案例，最后用 4 道小测领取章节通行证。',
          style: TextStyle(
            color: Color(0xFF5D696F),
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        _buildGlossaryEntry(),
        const SizedBox(height: 14),
        ...guidanceLessons.map(_buildLessonTile),
      ],
    );
  }

  Widget _buildGlossaryEntry() {
    final List<GuidanceGlossaryTerm> unlockedTerms = _unlockedGlossaryTerms();
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showGlossarySheet(unlockedTerms),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE4F6FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFCFEFFF), width: 2),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/characters/myo/myo_thinking.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    '词汇表',
                    style: TextStyle(
                      color: Color(0xFF162025),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    unlockedTerms.isEmpty
                        ? '完成章节学习后，这里会收集你已经学到的专业词。'
                        : '已解锁 ${unlockedTerms.length} 个专业词，随时回来复习。',
                    style: const TextStyle(
                      color: Color(0xFF45616F),
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.menu_book_rounded, color: Color(0xFF086A9D)),
          ],
        ),
      ),
    );
  }

  void _showGlossarySheet(List<GuidanceGlossaryTerm> unlockedTerms) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.36,
          maxChildSize: 0.92,
          builder: (BuildContext context, ScrollController scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              children: <Widget>[
                const Text(
                  '词汇表',
                  style: TextStyle(
                    color: Color(0xFF162025),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '只展示已经在顺序学习中解锁的词。点开任意词卡，可以重新看 Myo 的白话解释。',
                  style: TextStyle(
                    color: Color(0xFF5D696F),
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (unlockedTerms.isEmpty)
                  _buildEmptyGlossaryCard()
                else
                  ...unlockedTerms.map(_buildGlossaryTermCard),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyGlossaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFDF8A)),
      ),
      child: const Text(
        '先完成第 1 章的学习卡片，词汇表会自动收录你已经学到的专业词。',
        style: TextStyle(
          color: Color(0xFF8A4B00),
          height: 1.45,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildGlossaryTermCard(GuidanceGlossaryTerm term) {
    final _TermFirstOccurrence? occurrence = _firstTermOccurrences[term.term];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showFinanceTermDialog(context, term),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FCFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCFEFFF)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F6FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'CH${(occurrence?.chapterNumber ?? 0).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Color(0xFF086A9D),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      term.term,
                      style: const TextStyle(
                        color: Color(0xFF162025),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      term.plainExplanation,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF5D696F),
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF86AFC4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonTile(GuidanceLesson lesson) {
    final bool unlocked = _isLessonUnlocked(lesson);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          if (!unlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('先完成第 ${lesson.chapterNumber - 1} 章学习内容，再进入这一章。'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          unawaited(_playGuidanceAudio(_GuidanceAudio.conceptReveal));
          setState(() => _selectedLesson = lesson);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: unlocked ? Colors.white : const Color(0xFFF2F5F4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: unlocked
                  ? const Color(0xFFE6E8EC)
                  : const Color(0xFFDDE5E1),
            ),
            boxShadow: unlocked
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  lesson.heroAsset,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${lesson.chapterNumber.toString().padLeft(2, '0')} · ${lesson.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF162025),
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF5D696F),
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        _buildTag(lesson.rarity),
                        const SizedBox(width: 8),
                        _buildTag(unlocked ? '先学后测' : '未解锁'),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked ? Icons.chevron_right_rounded : Icons.lock_rounded,
                color: const Color(0xFFB0B9C0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonDetail(GuidanceLesson lesson) {
    final bool learningComplete = _isLessonLearningComplete(lesson);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(lesson.heroAsset, height: 260, fit: BoxFit.cover),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            _buildTag(
              'CARD-${lesson.chapterNumber.toString().padLeft(2, '0')}',
            ),
            const SizedBox(width: 8),
            _buildTag(lesson.rarity),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          lesson.title,
          style: const TextStyle(
            color: Color(0xFF162025),
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        FinanceTermText(
          text: lesson.subtitle,
          highlightedTerms: _activeTermsFor(lesson, _slot(lesson, 'subtitle')),
          style: const TextStyle(
            color: Color(0xFF5D696F),
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _buildMyoIntro(lesson, lesson.myoIntro),
        const SizedBox(height: 18),
        _buildLearningJourney(lesson),
        const SizedBox(height: 16),
        _buildSection(lesson, '学完我们能回答', lesson.learningGoals, 'learning_goal'),
        const SizedBox(height: 16),
        _buildSection(lesson, '这一章记住三件事', lesson.keyPoints, 'key_point'),
        const SizedBox(height: 20),
        if (learningComplete) ...<Widget>[
          _buildRewardGate(lesson),
          const SizedBox(height: 12),
          MyoPracticeBlock(lesson: lesson),
        ] else
          _buildLockedQuizNotice(lesson),
      ],
    );
  }

  Widget _buildMyoIntro(GuidanceLesson lesson, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7E8DD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD7E8DD), width: 2),
            ),
            child: Image.asset(
              'assets/images/characters/myo/myo_default_smile.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FinanceTermText(
              text: text,
              highlightedTerms: _activeTermsFor(lesson, _slot(lesson, 'intro')),
              style: const TextStyle(
                color: Color(0xFF23302A),
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    GuidanceLesson lesson,
    String title,
    List<String> items,
    String slotPrefix,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF162025),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ...items.asMap().entries.map((MapEntry<int, String> entry) {
            final int index = entry.key;
            final String item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: Color(0xFF1FA95B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FinanceTermText(
                      text: item,
                      highlightedTerms: _activeTermsFor(
                        lesson,
                        _slot(lesson, '${slotPrefix}_$index'),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF5D696F),
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLearningJourney(GuidanceLesson lesson) {
    final List<_EducationBeat> beats =
        _educationBeats[lesson.chapterNumber] ?? _fallbackBeats;
    final int completed = _completedLearningSteps[lesson.id]?.length ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  '先学：概念、案例、互动',
                  style: TextStyle(
                    color: Color(0xFF162025),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _buildTinyPill('$completed / ${beats.length}'),
            ],
          ),
          const SizedBox(height: 6),
          const FinanceTermText(
            text:
                '小测不再是入口，而是学完后的奖励关卡。先把概念拆小，再用生活场景练一次；看到浅蓝色词卡时，点一下就能让 Myo 用白话解释。',
            highlightedTerms: <String>{},
            style: TextStyle(
              color: Color(0xFF5D696F),
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...beats.asMap().entries.map((MapEntry<int, _EducationBeat> entry) {
            return _buildEducationBeat(lesson, entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildEducationBeat(
    GuidanceLesson lesson,
    int index,
    _EducationBeat beat,
  ) {
    final bool isComplete = _isLearningStepComplete(lesson, index);
    final bool usesConceptChat = _usesConceptChat(lesson, index);
    final bool usesCasePresentation = _usesCasePresentation(lesson, index);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: usesCasePresentation ? () => _openCasePresentation(lesson) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isComplete ? const Color(0xFFE8F5E9) : const Color(0xFFF9FBFA),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isComplete
                ? const Color(0xFF8ED8A6)
                : const Color(0xFFDDE7E1),
            width: isComplete ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFDDE7E1)),
                  ),
                  child: Image.asset(
                    _myoAssetForBeat(beat.kind),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _buildTinyPill('${index + 1} · ${beat.kind}'),
                          const Spacer(),
                          Icon(
                            isComplete
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isComplete
                                ? const Color(0xFF1FA95B)
                                : const Color(0xFFB0B9C0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FinanceTermText(
                        text: beat.title,
                        highlightedTerms: _activeTermsFor(
                          lesson,
                          _slot(lesson, 'beat_${index}_title'),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF162025),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FinanceTermText(
              text: beat.body,
              highlightedTerms: _activeTermsFor(
                lesson,
                _slot(lesson, 'beat_${index}_body'),
              ),
              style: const TextStyle(
                color: Color(0xFF5D696F),
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: usesConceptChat
                    ? () => _openConceptChat(lesson)
                    : usesCasePresentation
                    ? () => _openCasePresentation(lesson)
                    : () => _toggleLearningStep(lesson, index),
                icon: Icon(
                  usesConceptChat
                      ? Icons.chat_bubble_rounded
                      : usesCasePresentation
                      ? Icons.movie_filter_rounded
                      : isComplete
                      ? Icons.check_circle_rounded
                      : Icons.touch_app_rounded,
                  size: 18,
                ),
                label: Text(
                  usesConceptChat
                      ? _conceptChatButtonLabel(lesson)
                      : usesCasePresentation
                      ? isComplete
                            ? '复习案例讲解'
                            : '进入案例讲解'
                      : isComplete
                      ? '已点亮'
                      : '点一下，完成这步',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: isComplete
                      ? const Color(0xFF1FA95B)
                      : const Color(0xFFB45309),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardGate(GuidanceLesson lesson) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE2A8), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.workspace_premium_rounded, color: Color(0xFFB45309)),
          const SizedBox(width: 10),
          Expanded(
            child: FinanceTermText(
              text:
                  '章末通行证：完成学习后再挑战 4 道小测，答对 3 题即可获得 ${lesson.cardName}、XP 奖励和下一章通行证。',
              highlightedTerms: const <String>{},
              style: const TextStyle(
                color: Color(0xFF8A4B00),
                height: 1.45,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedQuizNotice(GuidanceLesson lesson) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE2A8), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/characters/myo/myo_sneak_peek.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FinanceTermText(
              text: '章末通行证先锁住：请先点亮上面的概念、案例、互动三步。这样小测是在确认理解，不是在逼你猜答案。',
              highlightedTerms: const <String>{},
              style: const TextStyle(
                color: Color(0xFF8A4B00),
                height: 1.45,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isLessonLearningComplete(GuidanceLesson lesson) {
    final int stepCount =
        (_educationBeats[lesson.chapterNumber] ?? _fallbackBeats).length;
    return (_completedLearningSteps[lesson.id]?.length ?? 0) >= stepCount;
  }

  bool _isLessonUnlocked(GuidanceLesson lesson) {
    if (lesson.chapterNumber == 1) {
      return true;
    }

    final GuidanceLesson previousLesson =
        guidanceLessons[lesson.chapterNumber - 2];
    return _isLessonLearningComplete(previousLesson);
  }

  bool _isLearningStepComplete(GuidanceLesson lesson, int index) {
    return _completedLearningSteps[lesson.id]?.contains(index) ?? false;
  }

  bool _usesCasePresentation(GuidanceLesson lesson, int index) {
    return lesson.id == 'CH01' && index == 1;
  }

  void _openCasePresentation(GuidanceLesson lesson) {
    setState(() {
      _activeCaseLesson = lesson;
      _caseIntroVisible = true;
      _caseGuideVisible = false;
      _isCaseDragging = false;
      _caseGuideToken += 1;
    });
    _caseDropPulseController
      ..stop()
      ..reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_caseScrollController.hasClients) {
        _caseScrollController.jumpTo(0);
      }
    });
    unawaited(_playGuidanceAudio(_GuidanceAudio.caseSlide));
    unawaited(_finishCaseIntro(lesson));
  }

  Future<void> _finishCaseIntro(GuidanceLesson lesson) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted || _activeCaseLesson?.id != lesson.id) {
      return;
    }
    setState(() {
      _caseIntroVisible = false;
      final int current = _caseRevealedSegmentCounts[lesson.id] ?? 0;
      if (current == 0) {
        _caseRevealedSegmentCounts[lesson.id] = 1;
      }
    });
    _scrollCaseToBottom();
    unawaited(_showCaseGuidePrompt(lesson));
  }

  void _revealNextCaseSegment(GuidanceLesson lesson) {
    final int current = _caseRevealedSegmentCounts[lesson.id] ?? 0;
    if (current >= _ipoCaseSegments.length) {
      return;
    }

    final bool wasLessonComplete = _isLessonLearningComplete(lesson);
    setState(() {
      _caseRevealedSegmentCounts[lesson.id] = current + 1;
      _caseGuideVisible = false;
      _isCaseDragging = false;
      if (current + 1 >= _ipoCaseSegments.length) {
        final Set<int> completed = _completedLearningSteps.putIfAbsent(
          lesson.id,
          () => <int>{},
        );
        completed.add(1);
      }
    });
    _scrollCaseToBottom();
    if (current + 1 < _ipoCaseSegments.length) {
      unawaited(_showCaseGuidePrompt(lesson));
    }

    if (!wasLessonComplete && _isLessonLearningComplete(lesson)) {
      unawaited(_playGuidanceAudio(_GuidanceAudio.nextUnlock));
    }
  }

  void _scrollCaseToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_caseScrollController.hasClients) {
        return;
      }
      _caseScrollController.animateTo(
        _caseScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _closeCaseRoute() {
    setState(() {
      _activeCaseLesson = null;
      _caseIntroVisible = false;
      _caseGuideVisible = false;
      _isCaseDragging = false;
      _caseGuideToken += 1;
    });
    _caseDropPulseController
      ..stop()
      ..reset();
  }

  Future<void> _showCaseGuidePrompt(GuidanceLesson lesson) async {
    final int token = ++_caseGuideToken;
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted ||
        _activeCaseLesson?.id != lesson.id ||
        token != _caseGuideToken) {
      return;
    }
    final int revealedCount = _caseRevealedSegmentCounts[lesson.id] ?? 0;
    if (revealedCount <= 0 || revealedCount >= _ipoCaseSegments.length) {
      return;
    }
    setState(() {
      _caseGuideVisible = true;
      _isCaseDragging = false;
    });
  }

  void _acceptCaseDrop(GuidanceLesson lesson, String participant) {
    final int revealedCount = _caseRevealedSegmentCounts[lesson.id] ?? 0;
    if (revealedCount <= 0 || revealedCount >= _ipoCaseSegments.length) {
      return;
    }
    final String expectedParticipant =
        _ipoCaseSegments[revealedCount].participant;
    if (participant != expectedParticipant) {
      return;
    }
    setState(() {
      _caseGuideVisible = false;
      _isCaseDragging = false;
      _caseGuideToken += 1;
    });
    _caseDropPulseController
      ..stop()
      ..reset();
    unawaited(_playGuidanceAudio(_GuidanceAudio.caseSlide));
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      if (!mounted || _activeCaseLesson?.id != lesson.id) {
        return;
      }
      _revealNextCaseSegment(lesson);
    });
  }

  Set<String> _activeTermsFor(GuidanceLesson lesson, String slotId) {
    final Set<String> activeTerms = <String>{};
    for (final MapEntry<String, _TermFirstOccurrence> entry
        in _firstTermOccurrences.entries) {
      final _TermFirstOccurrence occurrence = entry.value;
      if (occurrence.chapterNumber == lesson.chapterNumber &&
          occurrence.slotId == slotId) {
        activeTerms.add(entry.key);
      }
    }
    return activeTerms;
  }

  List<GuidanceGlossaryTerm> _unlockedGlossaryTerms() {
    final List<GuidanceGlossaryTerm> unlocked = <GuidanceGlossaryTerm>[];
    for (final GuidanceGlossaryTerm term in guidanceGlossaryTerms) {
      final _TermFirstOccurrence? occurrence = _firstTermOccurrences[term.term];
      if (occurrence == null) {
        continue;
      }

      final GuidanceLesson lesson =
          guidanceLessons[occurrence.chapterNumber - 1];
      if (_isLessonLearningComplete(lesson)) {
        unlocked.add(term);
      }
    }

    unlocked.sort((GuidanceGlossaryTerm a, GuidanceGlossaryTerm b) {
      final _TermFirstOccurrence first = _firstTermOccurrences[a.term]!;
      final _TermFirstOccurrence second = _firstTermOccurrences[b.term]!;
      return first.sequence.compareTo(second.sequence);
    });
    return unlocked;
  }

  Map<String, _TermFirstOccurrence> _buildFirstTermOccurrences() {
    final Map<String, _TermFirstOccurrence> firstOccurrences =
        <String, _TermFirstOccurrence>{};
    int sequence = 0;

    void scan(GuidanceLesson lesson, String localSlot, String text) {
      final String slotId = _slot(lesson, localSlot);
      for (final GuidanceGlossaryTerm term in guidanceGlossaryTerms) {
        if (firstOccurrences.containsKey(term.term)) {
          continue;
        }
        if (_textContainsTerm(text, term)) {
          firstOccurrences[term.term] = _TermFirstOccurrence(
            chapterNumber: lesson.chapterNumber,
            slotId: slotId,
            sequence: sequence,
          );
        }
      }
      sequence += 1;
    }

    for (final GuidanceLesson lesson in guidanceLessons) {
      final GuidanceConceptDialogue? dialogue =
          guidanceConceptDialogues[lesson.chapterNumber];
      if (dialogue != null) {
        for (int i = 0; i < dialogue.turns.length; i += 1) {
          final GuidanceConceptTurn turn = dialogue.turns[i];
          scan(lesson, 'concept_${i}_myo', turn.myoText);
          for (int j = 0; j < turn.options.length; j += 1) {
            final GuidanceConceptOption option = turn.options[j];
            scan(
              lesson,
              'concept_${i}_option_${j}_response',
              option.myoResponse,
            );
          }
        }
      }
      scan(lesson, 'subtitle', lesson.subtitle);
      scan(lesson, 'intro', lesson.myoIntro);
      final List<_EducationBeat> beats =
          _educationBeats[lesson.chapterNumber] ?? _fallbackBeats;
      for (int i = 0; i < beats.length; i += 1) {
        scan(lesson, 'beat_${i}_title', beats[i].title);
        scan(lesson, 'beat_${i}_body', beats[i].body);
      }
      for (int i = 0; i < lesson.learningGoals.length; i += 1) {
        scan(lesson, 'learning_goal_$i', lesson.learningGoals[i]);
      }
      for (int i = 0; i < lesson.keyPoints.length; i += 1) {
        scan(lesson, 'key_point_$i', lesson.keyPoints[i]);
      }
    }

    return firstOccurrences;
  }

  bool _textContainsTerm(String text, GuidanceGlossaryTerm term) {
    final Set<String> aliases = <String>{term.term, ...term.aliases};
    return aliases.any(text.contains);
  }

  String _slot(GuidanceLesson lesson, String localSlot) {
    return '${lesson.id}_$localSlot';
  }

  bool _usesConceptChat(GuidanceLesson lesson, int index) {
    return index == 0 &&
        guidanceConceptDialogues.containsKey(lesson.chapterNumber);
  }

  String _conceptChatButtonLabel(GuidanceLesson lesson) {
    final GuidanceConceptDialogue? dialogue =
        guidanceConceptDialogues[lesson.chapterNumber];
    if (dialogue == null) {
      return '进入概念对话';
    }

    final int completedTurns =
        _conceptDialogueSelections[lesson.id]?.length ?? 0;
    if (completedTurns >= dialogue.turns.length) {
      return '复习概念对话';
    }
    if (completedTurns > 0) {
      return '继续概念对话';
    }
    return '进入概念对话';
  }

  String _conceptTurnKey(String lessonId, int turnIndex) {
    return '$lessonId:$turnIndex';
  }

  String _conceptPromptKey(String lessonId, int turnIndex) {
    return '$lessonId:prompt:$turnIndex';
  }

  String _conceptCompleteKey(String lessonId) {
    return '$lessonId:complete';
  }

  void _scrollConceptChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_conceptChatScrollController.hasClients) {
        return;
      }
      _conceptChatScrollController.animateTo(
        _conceptChatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  bool _canShowNextConceptTurn(GuidanceLesson lesson) {
    final int selectedCount =
        _conceptDialogueSelections[lesson.id]?.length ?? 0;
    final int advancedCount = _conceptAdvancedTurnCounts[lesson.id] ?? 0;
    return advancedCount >= selectedCount;
  }

  bool _canShowConceptComplete(GuidanceLesson lesson) {
    final String completeKey = _conceptCompleteKey(lesson.id);
    return _conceptRevealedResponseCounts[completeKey] == 1 &&
        _conceptTypingKey != completeKey;
  }

  Duration _conceptSegmentDelay(String text) {
    final int delayMs = 1000 + (text.length * 18);
    return Duration(milliseconds: delayMs.clamp(1000, 2500).toInt());
  }

  List<String> _conceptResponseSegments(String text) {
    final List<String> rawSegments = text
        .split(RegExp(r'(?<=[。！？；])'))
        .map((String segment) => segment.trim())
        .where((String segment) => segment.isNotEmpty)
        .toList();
    if (rawSegments.length <= 1) {
      return <String>[text];
    }
    return rawSegments;
  }

  Future<void> _revealConceptResponse({
    required GuidanceLesson lesson,
    required int turnIndex,
    required GuidanceConceptOption option,
  }) async {
    final int token = ++_conceptRevealToken;
    final String turnKey = _conceptTurnKey(lesson.id, turnIndex);
    final List<String> segments = _conceptResponseSegments(option.myoResponse);

    setState(() {
      _conceptRevealedResponseCounts[turnKey] = 0;
      _conceptTypingKey = turnKey;
    });
    _scrollConceptChatToBottom();

    await Future<void>.delayed(_conceptMyoThinkingDelay);
    if (!mounted || token != _conceptRevealToken) {
      return;
    }

    for (int i = 0; i < segments.length; i += 1) {
      final bool hasNextSegment = i < segments.length - 1;
      setState(() {
        _conceptTypingKey = hasNextSegment ? turnKey : null;
        _conceptRevealedResponseCounts[turnKey] = i + 1;
      });
      _scrollConceptChatToBottom();

      if (hasNextSegment) {
        await Future<void>.delayed(_conceptSegmentDelay(segments[i]));
        if (!mounted || token != _conceptRevealToken) {
          return;
        }
      }
    }

    final GuidanceConceptDialogue? dialogue =
        guidanceConceptDialogues[lesson.chapterNumber];
    if (dialogue != null && turnIndex + 1 < dialogue.turns.length) {
      final String nextPromptKey = _conceptPromptKey(lesson.id, turnIndex + 1);
      setState(() => _conceptTypingKey = nextPromptKey);
      _scrollConceptChatToBottom();
      await Future<void>.delayed(_conceptMyoThinkingDelay);
      if (!mounted || token != _conceptRevealToken) {
        return;
      }
    }

    setState(() {
      _conceptTypingKey = null;
      _conceptAdvancedTurnCounts[lesson.id] = turnIndex + 1;
    });
    _scrollConceptChatToBottom();
    unawaited(_maybeRevealConceptComplete(lesson, token));
  }

  Future<void> _maybeRevealConceptComplete(
    GuidanceLesson lesson,
    int token,
  ) async {
    final GuidanceConceptDialogue? dialogue =
        guidanceConceptDialogues[lesson.chapterNumber];
    if (dialogue == null) {
      return;
    }
    final int selectedCount =
        _conceptDialogueSelections[lesson.id]?.length ?? 0;
    if (selectedCount < dialogue.turns.length ||
        (_conceptAdvancedTurnCounts[lesson.id] ?? 0) < dialogue.turns.length) {
      return;
    }

    final String completeKey = _conceptCompleteKey(lesson.id);
    if (_conceptRevealedResponseCounts[completeKey] == 1) {
      return;
    }

    setState(() => _conceptTypingKey = completeKey);
    _scrollConceptChatToBottom();
    await Future<void>.delayed(_conceptMyoThinkingDelay);
    if (!mounted || token != _conceptRevealToken) {
      return;
    }
    setState(() {
      _conceptTypingKey = null;
      _conceptRevealedResponseCounts[completeKey] = 1;
    });
    _scrollConceptChatToBottom();
  }

  void _openConceptChat(GuidanceLesson lesson) {
    final int token = ++_conceptRevealToken;
    final GuidanceConceptDialogue? dialogue =
        guidanceConceptDialogues[lesson.chapterNumber];
    final int selectedCount =
        _conceptDialogueSelections[lesson.id]?.length ?? 0;
    final bool shouldRevealFirstPrompt = dialogue != null && selectedCount == 0;
    setState(() {
      _activeConceptLesson = lesson;
      _conceptTypingKey = shouldRevealFirstPrompt
          ? _conceptPromptKey(lesson.id, 0)
          : null;
      _conceptAdvancedTurnCounts[lesson.id] = shouldRevealFirstPrompt
          ? -1
          : selectedCount;
      if (dialogue != null) {
        for (
          int i = 0;
          i < selectedCount && i < dialogue.turns.length;
          i += 1
        ) {
          final GuidanceConceptTurn turn = dialogue.turns[i];
          final String? selectedOptionId =
              _conceptDialogueSelections[lesson.id]?[i];
          final GuidanceConceptOption selectedOption = turn.options.firstWhere(
            (GuidanceConceptOption option) => option.id == selectedOptionId,
            orElse: () => turn.options.first,
          );
          _conceptRevealedResponseCounts[_conceptTurnKey(lesson.id, i)] =
              _conceptResponseSegments(selectedOption.myoResponse).length;
        }
      }
      if (dialogue != null && selectedCount >= dialogue.turns.length) {
        _conceptRevealedResponseCounts[_conceptCompleteKey(lesson.id)] = 1;
      }
    });
    _conceptChatController.forward(from: 0);
    _scrollConceptChatToBottom();
    unawaited(_playGuidanceAudio(_GuidanceAudio.conceptReveal));
    if (shouldRevealFirstPrompt) {
      unawaited(_revealInitialConceptPrompt(lesson, token));
    }
  }

  Future<void> _revealInitialConceptPrompt(
    GuidanceLesson lesson,
    int token,
  ) async {
    await Future<void>.delayed(_conceptMyoThinkingDelay);
    if (!mounted || token != _conceptRevealToken) {
      return;
    }
    setState(() {
      _conceptTypingKey = null;
      _conceptAdvancedTurnCounts[lesson.id] = 0;
    });
    _scrollConceptChatToBottom();
  }

  Future<void> _closeConceptChat() async {
    _conceptRevealToken += 1;
    if (mounted) {
      setState(() => _conceptTypingKey = null);
    }
    await _conceptChatController.reverse();
    if (!mounted) {
      return;
    }
    setState(() => _activeConceptLesson = null);
  }

  void _selectConceptOption(
    GuidanceLesson lesson,
    GuidanceConceptTurn turn,
    GuidanceConceptOption option,
  ) {
    final GuidanceConceptDialogue? dialogue =
        guidanceConceptDialogues[lesson.chapterNumber];
    if (dialogue == null) {
      return;
    }

    final bool wasLessonComplete = _isLessonLearningComplete(lesson);
    final int turnIndex = dialogue.turns.indexWhere(
      (GuidanceConceptTurn item) => item.id == turn.id,
    );
    if (turnIndex < 0 ||
        _conceptTypingKey != null ||
        (_conceptRevealedResponseCounts[_conceptTurnKey(
                  lesson.id,
                  turnIndex,
                )] ??
                0) >
            0) {
      return;
    }

    setState(() {
      final List<String> selections = _conceptDialogueSelections.putIfAbsent(
        lesson.id,
        () => <String>[],
      );
      if (turnIndex == selections.length) {
        selections.add(option.id);
      }

      if (selections.length >= dialogue.turns.length) {
        final Set<int> completed = _completedLearningSteps.putIfAbsent(
          lesson.id,
          () => <int>{},
        );
        completed.add(0);
      }
    });

    if (turnIndex < (_conceptDialogueSelections[lesson.id]?.length ?? 0)) {
      unawaited(
        _revealConceptResponse(
          lesson: lesson,
          turnIndex: turnIndex,
          option: option,
        ),
      );
    }

    final bool isDialogueComplete =
        (_conceptDialogueSelections[lesson.id]?.length ?? 0) >=
        dialogue.turns.length;
    if (isDialogueComplete &&
        !wasLessonComplete &&
        _isLessonLearningComplete(lesson)) {
      unawaited(_playGuidanceAudio(_GuidanceAudio.nextUnlock));
    }
  }

  void _toggleLearningStep(GuidanceLesson lesson, int index) {
    final bool wasLessonComplete = _isLessonLearningComplete(lesson);
    final bool wasStepComplete = _isLearningStepComplete(lesson, index);

    setState(() {
      final Set<int> completed = _completedLearningSteps.putIfAbsent(
        lesson.id,
        () => <int>{},
      );
      if (!completed.add(index)) {
        completed.remove(index);
      }
    });

    if (wasStepComplete) {
      return;
    }

    if (!wasLessonComplete && _isLessonLearningComplete(lesson)) {
      unawaited(_playGuidanceAudio(_GuidanceAudio.nextUnlock));
      return;
    }

    final List<_EducationBeat> beats =
        _educationBeats[lesson.chapterNumber] ?? _fallbackBeats;
    unawaited(_playGuidanceAudio(_audioForBeat(beats[index].kind)));
  }

  String _myoAssetForBeat(String kind) {
    switch (kind) {
      case '概念':
        return 'assets/images/characters/myo/myo_thinking.png';
      case '案例':
        return 'assets/images/characters/myo/myo_sneak_peek.png';
      case '互动':
        return 'assets/images/characters/myo/myo_clap.png';
    }
    return 'assets/images/characters/myo/myo_default_smile.png';
  }

  _GuidanceAudio _audioForBeat(String kind) {
    switch (kind) {
      case '案例':
        return _GuidanceAudio.caseSlide;
      case '互动':
        return _GuidanceAudio.interactionReady;
      case '概念':
      default:
        return _GuidanceAudio.conceptReveal;
    }
  }

  Future<void> _playGuidanceAudio(_GuidanceAudio audio) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audio.assetPath), volume: 0.9);
    } catch (_) {
      // Ignore audio failures so education content and tests are never blocked.
    }
  }

  Widget _buildTinyPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1FA95B),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFE2A8)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB45309),
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

enum _GuidanceAudio {
  conceptReveal('audio/guidance_concept_reveal.wav'),
  caseSlide('audio/guidance_case_slide.wav'),
  interactionReady('audio/guidance_interaction_ready.wav'),
  nextUnlock('audio/guidance_next_unlock.wav');

  const _GuidanceAudio(this.assetPath);

  final String assetPath;
}

class _TermFirstOccurrence {
  const _TermFirstOccurrence({
    required this.chapterNumber,
    required this.slotId,
    required this.sequence,
  });

  final int chapterNumber;
  final String slotId;
  final int sequence;
}

class _EducationBeat {
  const _EducationBeat({
    required this.kind,
    required this.title,
    required this.body,
  });

  final String kind;
  final String title;
  final String body;
}

class _IpoCaseSegment {
  const _IpoCaseSegment({
    required this.participant,
    required this.title,
    required this.body,
    required this.terms,
  });

  final String participant;
  final String title;
  final String body;
  final Set<String> terms;
}

const List<_IpoCaseSegment> _ipoCaseSegments = <_IpoCaseSegment>[
  _IpoCaseSegment(
    participant: '公司',
    title: '第一幕：公司拿出股份',
    body: '一家公司想募集资金，把公司所有权切成很多股份，通过 IPO 公开发行。这里的钱主要流向发行方，也就是公司。',
    terms: <String>{'股份', '公开发行'},
  ),
  _IpoCaseSegment(
    participant: '承销商',
    title: '第二幕：承销商把发行组织起来',
    body: '承销商帮助发行方设计发行方案、估值定价、路演沟通和销售安排。它不是最终持有股份的人，更像把新股送上发行通道的组织者。',
    terms: <String>{'承销商', '发行方'},
  ),
  _IpoCaseSegment(
    participant: '基石投资者',
    title: '第三幕：基石投资者先放下一个锚',
    body: '有些发行会引入基石投资者。它们提前承诺认购较大份额，给市场一个参考锚，但这不等于上市后价格一定上涨。',
    terms: <String>{'基石投资者', '散户'},
  ),
  _IpoCaseSegment(
    participant: '交易所',
    title: '第四幕：交易所提供上市与交易入口',
    body: '交易所提供发行上市和二级市场交易的规则入口。它像有规则的市场场地，负责规则和交易安排，但不是这批股份的最终买家。',
    terms: <String>{'交易所', '二级市场', '股份'},
  ),
  _IpoCaseSegment(
    participant: '散户',
    title: '第五幕：散户打新认购',
    body: '散户可以通过打新提交新股申购。申购成功后，散户拿到配售的股份；如果没有中签，股份就不会来到他的账户。',
    terms: <String>{'打新', '散户', '股份'},
  ),
  _IpoCaseSegment(
    participant: '二级市场',
    title: '第六幕：上市后进入二级市场',
    body: '股票上市后，散户可以继续持有，也可以在二级市场卖给新的买家。这时成交资金主要在投资者之间流转；如果价格跌破发行价，就叫破发。',
    terms: <String>{'二级市场', '散户', '破发'},
  ),
];

const List<_EducationBeat> _fallbackBeats = <_EducationBeat>[
  _EducationBeat(
    kind: '概念',
    title: '先用一句话抓住本章核心',
    body: '把专业词翻译成生活语言，先知道它解决什么问题，再看它有哪些限制。',
  ),
  _EducationBeat(
    kind: '案例',
    title: '再放进真实或生活场景',
    body: '用一笔钱、一个账户或一次市场波动做例子，练习判断“这件事和我有什么关系”。',
  ),
  _EducationBeat(
    kind: '互动',
    title: '最后做一次轻量选择',
    body: '在进入小测前先做低压力互动，答错只给线索，不扣奖励。',
  ),
];

const Map<int, List<_EducationBeat>>
_educationBeats = <int, List<_EducationBeat>>{
  1: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '二级市场是“已发行证券的转手集市”',
      body: '买股票通常不是把钱直接交给公司，而是和另一个投资者交换公司所有权的一小部分。',
    ),
    _EducationBeat(
      kind: '案例',
      title: 'Myo 带你走一遍 IPO 股份旅程',
      body:
          '点击进入滚动式案例讲解：Myo 会先登场，再把股份从公司公开募股、承销发行、基石认购、交易所上市，到散户打新和二级市场交易逐段讲清楚。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '复盘股份传递路线',
      body:
          '完成案例后，再点亮这张复盘卡：公司拿出股份，承销商组织发行，基石投资者提供认购锚，交易所提供规则入口，散户通过打新获得配售并在二级市场交易。',
    ),
  ],
  2: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '股票代码是市场门牌号',
      body: '600、300、688、8/4 开头分别提供不同板块线索，但它们不是收益暗示。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '先看小区，再看房子',
      body: '看到陌生代码时，先确认它属于哪个交易所和板块，再了解交易门槛、波动和风险提示。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '代码贴纸配对',
      body: '把常见代码前缀拖到“主板、创业板、科创板、北交所”的地图区域。',
    ),
  ],
  3: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '交易规则是新手安全带',
      body: '交易时间、涨跌幅、买入后通常次日可卖等规则，先帮你避免按钮点错。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '快递不是 24 小时都揽收',
      body: '市场也有工作时间。午间、收盘后和节假日不能按连续竞价逻辑理解。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '交易日时间轴',
      body: '把“上午连续竞价、午休、下午连续竞价、收盘集合竞价”放到正确顺序。',
    ),
  ],
  4: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '行情图是记录本，不是水晶球',
      body: 'K 线记录开、高、低、收和成交信息，但单根形态不能替你做投资决策。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '像体温记录表',
      body: '一天体温升高只能提示关注原因，不能单独诊断所有问题；价格图也一样。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '周期放大镜',
      body: '滑动切换分时、日线、周线，观察短周期噪音和长周期轮廓的差异。',
    ),
  ],
  5: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '股价高不等于估值贵',
      body: '估值要把价格放回利润、资产、分红和成长质量里看，不能只看一个绝对数字。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '同样 100 元，买到的东西不同',
      body: '一杯水 100 元很贵，一件耐穿外套 100 元可能合理；股票也要看背后的盈利和资产质量。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '估值天平',
      body: '把“PE、PB、股息率”分别拖到“利润、净资产、现金分红”的秤盘上。',
    ),
  ],
  6: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '看公司先看它怎么赚钱',
      body: '业务、收入、利润、现金流和负债共同组成公司简历，热搜不能替代研究。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '像面试一家公司',
      body: '先问它卖什么、客户是谁、钱有没有收回来，再看估值和风险。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '公司简历排序',
      body: '将“主营业务、利润、现金流、负债、风险提示”排成新手研究顺序。',
    ),
  ],
  7: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '风险来自市场、公司和情绪',
      body: '市场大风、公司单点问题和自己的冲动，都会让收益路径变得不稳定。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '天气、路况和驾驶员',
      body: '大盘波动像天气，公司风险像路况，情绪风险像驾驶员分心，工具要分别对应。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '风险工具配对',
      body: '把“分散、现金缓冲、冷静期”匹配到不同风险来源。',
    ),
  ],
  8: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '指数基金是一篮子规则',
      body: '宽基指数把一组代表性资产装进透明篮子，优势是分散、规则清楚、费用通常较低。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '买水果篮，不押单个水果',
      body: '单个水果可能坏掉，一篮子更能分散单点问题，但篮子本身仍会随市场波动。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '篮子宽窄判断',
      body: '选择“宽基、行业、主题”三类篮子的风险集中程度。',
    ),
  ],
  9: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '有些钱的任务是站岗',
      body: '应急金和短期刚需资金优先安全和流动性，不应该承担过高波动。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '学费钱不能坐过山车',
      body: '明年要交学费的钱，不适合放进高波动资产，因为它没有时间等修复。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '资金期限分层',
      body: '把“随时用、1 年内用、5 年以上不用”的资金放到不同风险层。',
    ),
  ],
  10: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '情绪正常，动作要慢',
      body: '从众、FOMO 和损失厌恶都会出现，关键是用规则给冲动加延迟。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '朋友圈热闹不是买入理由',
      body: '牛市刷屏会放大“我也要上车”的压力，但投资动作需要回到仓位和估值规则。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '暂停键演练',
      body: '为“暴涨、暴跌、朋友推荐”三个场景选择冷静期、仓位上限或投资日志。',
    ),
  ],
  11: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '定投是执行规则，不是保证盈利',
      body: '它把“一次猜对时点”变成“长期按固定金额和频率执行”，前提是资金可承受。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '像每月固定存钱',
      body: '收入稳定时设定小额自动计划，遇到波动先检查生活安全垫，而不是硬撑。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '计划可承受性检查',
      body: '输入月结余区间后，选择不会挤压生活和应急金的定投档位。',
    ),
  ],
  12: <_EducationBeat>[
    _EducationBeat(
      kind: '概念',
      title: '组合让每类资产各司其职',
      body: '现金管流动性，固收做稳定器，权益承担长期成长来源之一，比例由用途和期限决定。',
    ),
    _EducationBeat(
      kind: '案例',
      title: '把钱放进三层工具箱',
      body: '三个月内要用的钱放上层随手拿，长期不用的钱才可能放到底层成长仓。',
    ),
    _EducationBeat(
      kind: '互动',
      title: '个人投资系统 v1.0',
      body: '汇总前 11 章的定投计划、纪律清单、风险上限和资金分层，生成可保存的系统草稿。',
    ),
  ],
};
