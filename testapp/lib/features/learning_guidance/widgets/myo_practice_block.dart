// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Myo practice block - reusable warm-feedback quiz component
// 模块: Myo 练习组件 - 可复用的温暖反馈章末练习
//
// Dependencies: flutter/material.dart, guidance_models, learning guidance image assets
// 依赖: flutter/material.dart, guidance_models, 投资者教育练习图片素材
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../domain/guidance_models.dart';

class MyoPracticeBlock extends StatefulWidget {
  const MyoPracticeBlock({super.key, required this.lesson});

  final GuidanceLesson lesson;

  @override
  State<MyoPracticeBlock> createState() => _MyoPracticeBlockState();
}

class _MyoPracticeBlockState extends State<MyoPracticeBlock> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, String> _answers = <String, String>{};
  bool _hasPlayedPassReward = false;

  @override
  void initState() {
    super.initState();
    unawaited(_configureAudioPlayer());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _configureAudioPlayer() async {
    try {
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (_) {
      // Keep quiz interactions available even if the audio backend is absent.
    }
  }

  int get _correctCount {
    return widget.lesson.questions.where((GuidanceQuestion question) {
      return _answers[question.id] == question.correctOptionId;
    }).length;
  }

  bool get _isComplete => _answers.length == widget.lesson.questions.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '章末通行证小测',
          style: TextStyle(
            color: Color(0xFF162025),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        _buildMyoBubble(
          '你已经完成本章学习了。现在用这组小测领取奖励：答对 $_practicePassScore 题即可解锁卡片、XP 和下一章通行证。',
          accent: true,
        ),
        const SizedBox(height: 14),
        ...widget.lesson.questions.map(_buildQuestionCard),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: !_isComplete
              ? _buildProgress(_practicePassScore)
              : _buildResult(_practicePassScore),
        ),
      ],
    );
  }

  Widget _buildProgress(int passScore) {
    return Container(
      key: const ValueKey<String>('progress'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE7E1)),
      ),
      child: Text(
        '通行证进度 ${_answers.length} / ${widget.lesson.questions.length}。答对 $passScore 题即可解锁 ${widget.lesson.cardName}，答错也可以马上重试。',
        style: const TextStyle(
          color: Color(0xFF5D696F),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildResult(int passScore) {
    final bool passed = _correctCount >= passScore;
    final String illustrationAsset = passed
        ? _summaryPassAsset(widget.lesson.chapterNumber)
        : _summaryRetryAsset(widget.lesson.chapterNumber);
    return Container(
      key: ValueKey<String>('result_$passed'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: passed ? const Color(0xFFFFF9F0) : const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: passed ? const Color(0xFFFFB547) : const Color(0xFFDDE7E1),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              illustrationAsset,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            passed ? '通行证已点亮：${widget.lesson.cardName}' : '我们再补一小步',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: passed ? const Color(0xFFB45309) : const Color(0xFF23302A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            passed
                ? '你答对了 $_correctCount 题，获得章节卡、30 XP 和下一章通行证。这里是学习记录，不是投资建议。'
                : '你答对了 $_correctCount 题。错题不会扣分，点选项可以马上重试；Myo 会继续给线索。',
            style: const TextStyle(
              height: 1.45,
              color: Color(0xFF5D696F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(GuidanceQuestion question) {
    final String? picked = _answers[question.id];
    final bool? isCorrect = picked == null
        ? null
        : picked == question.correctOptionId;
    final String backgroundAsset = _questionBackgroundAsset(question);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E8EC)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                backgroundAsset,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          question.type.label,
                          style: const TextStyle(
                            color: Color(0xFF1FA95B),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isCorrect != null)
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.info_rounded,
                          color: isCorrect
                              ? const Color(0xFF1FA95B)
                              : const Color(0xFFFFB547),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.prompt,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: Color(0xFF162025),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...question.options.map((GuidanceOption option) {
                    return _buildOption(question, option, picked);
                  }),
                  if (picked != null) ...<Widget>[
                    const SizedBox(height: 12),
                    _buildFeedback(
                      question,
                      picked == question.correctOptionId,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _questionBackgroundAsset(GuidanceQuestion question) {
    final bool useSecondVariant =
        question.id.endsWith('Q2') || question.id.endsWith('Q4');
    switch (question.type) {
      case GuidanceQuestionType.matchChoice:
      case GuidanceQuestionType.sortChoice:
        return useSecondVariant
            ? '$_learningGuidanceAssetBase/practice_match_card_bg_02.png'
            : '$_learningGuidanceAssetBase/practice_match_card_bg.png';
      case GuidanceQuestionType.singleChoice:
      case GuidanceQuestionType.scenarioChoice:
        return useSecondVariant
            ? '$_learningGuidanceAssetBase/practice_single_choice_card_bg_02.png'
            : '$_learningGuidanceAssetBase/practice_single_choice_card_bg.png';
    }
  }

  String _summaryPassAsset(int chapterNumber) {
    return chapterNumber.isEven
        ? '$_learningGuidanceAssetBase/practice_summary_pass_02.png'
        : '$_learningGuidanceAssetBase/practice_summary_pass.png';
  }

  String _summaryRetryAsset(int chapterNumber) {
    return chapterNumber.isEven
        ? '$_learningGuidanceAssetBase/practice_summary_retry_02.png'
        : '$_learningGuidanceAssetBase/practice_summary_retry.png';
  }

  Widget _buildOption(
    GuidanceQuestion question,
    GuidanceOption option,
    String? picked,
  ) {
    final bool selected = picked == option.id;
    final bool correct = option.id == question.correctOptionId;
    final Color borderColor = selected
        ? (correct ? const Color(0xFF1FA95B) : const Color(0xFFFFB547))
        : const Color(0xFFE6E8EC);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          final bool passedBefore =
              _isComplete && _correctCount >= _practicePassScore;
              
          if (_answers[question.id] != option.id) {
            final bool isCorrect = option.id == question.correctOptionId;
            unawaited(_playAudio(isCorrect 
                ? 'audio/quiz_correct_soft_chime_01.wav' 
                : 'audio/quiz_retry_warm_pop_01.wav'));
          }

          setState(() {
            _answers[question.id] = option.id;
          });
          _playRewardAudioIfNeeded(passedBefore);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFFCF4) : const Color(0xFFF9FBFA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? borderColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  option.id,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF5D696F),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  option.text,
                  style: const TextStyle(
                    color: Color(0xFF23302A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(GuidanceQuestion question, bool isCorrect) {
    return _buildMyoBubble(
      isCorrect
          ? '${question.correctFeedback}\n${question.explanation}'
          : '${question.repairFeedback}\n${question.explanation}',
      accent: isCorrect,
      avatarAsset: isCorrect 
          ? '$_learningGuidanceAssetBase/myo_quiz_correct_micro.png'
          : '$_learningGuidanceAssetBase/myo_quiz_retry_micro.png',
    );
  }

  void _playRewardAudioIfNeeded(bool passedBefore) {
    final bool passedNow = _isComplete && _correctCount >= _practicePassScore;
    if (passedBefore || !passedNow || _hasPlayedPassReward) {
      return;
    }

    _hasPlayedPassReward = true;
    final String assetPath = widget.lesson.chapterNumber == 12
        ? 'audio/guidance_finale_12_cards.wav'
        : 'audio/guidance_passport_stamp.wav';
    unawaited(_playAudio(assetPath));
  }

  Future<void> _playAudio(String assetPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath), volume: 0.9);
    } catch (_) {
      // Audio is a reward layer; quiz state should never depend on it.
    }
  }

  Widget _buildMyoBubble(String text, {bool accent = false, String? avatarAsset}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (avatarAsset != null)
          Image.asset(
            avatarAsset,
            width: 38,
            height: 38,
          )
        else
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent ? const Color(0xFFFFF9F0) : const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(
                color: accent ? const Color(0xFFFFB547) : const Color(0xFFD7E8DD),
                width: 2,
              ),
            ),
            child: const Text(
              '喵',
              style: TextStyle(
                color: Color(0xFF1FA95B),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent ? const Color(0xFFFFF9F0) : const Color(0xFFF7FAF8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: accent
                    ? const Color(0xFF8A4B00)
                    : const Color(0xFF23302A),
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const int _practicePassScore = 3;
const String _learningGuidanceAssetBase = 'assets/images/learning_guidance';
