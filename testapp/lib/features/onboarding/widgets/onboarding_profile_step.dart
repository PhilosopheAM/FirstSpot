/// Last Updated: 2026-04-21
/// 最后更新: 2026-04-21
///
/// Module: Onboarding Profile Lite Step (Step 02)
/// 模块: 首开引导 - 轻量画像收集步骤 (对话式)
///
/// Dependencies: flutter/material.dart, onboarding_models, bouncy_button
///
/// Author: AI
/// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../domain/onboarding_models.dart';
import 'bouncy_button.dart';

class OnboardingProfileLiteStep extends StatefulWidget {
  const OnboardingProfileLiteStep({
    super.key,
    required this.answers,
    required this.onNext,
    required this.onAnswersChanged,
  });

  final OnboardingProfileAnswers answers;
  final VoidCallback onNext;
  final ValueChanged<OnboardingProfileAnswers> onAnswersChanged;

  @override
  State<OnboardingProfileLiteStep> createState() =>
      _OnboardingProfileLiteStepState();
}

class _OnboardingProfileLiteStepState extends State<OnboardingProfileLiteStep> {
  int _currentQuestionIndex = 0;
  final ScrollController _scrollController = ScrollController();

  bool _isMyoTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _simulateMyoTyping(VoidCallback onComplete) async {
    setState(() {
      _isMyoTyping = true;
    });
    _scrollToBottom();
    
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (mounted) {
      setState(() {
        _isMyoTyping = false;
        onComplete();
      });
      _scrollToBottom();
    }
  }

  void _updateIdentity(UserIdentityType type) {
    setState(() {
      widget.answers.identity = type;
    });
    widget.onAnswersChanged(widget.answers);
    
    _simulateMyoTyping(() {
      setState(() {
        if (_currentQuestionIndex == 0) _currentQuestionIndex = 1;
      });
    });
    // TODO: 播放 assets/audio/option_select_pop.mp3
  }

  void _updateSavings(SavingsRange range) {
    setState(() {
      widget.answers.savings = range;
    });
    widget.onAnswersChanged(widget.answers);
    
    _simulateMyoTyping(() {
      setState(() {
        if (_currentQuestionIndex == 1) _currentQuestionIndex = 2;
      });
    });
    // TODO: 播放 assets/audio/option_select_pop.mp3
  }

  void _updateVolatility(VolatilityFeeling feeling) {
    setState(() {
      widget.answers.volatility = feeling;
    });
    widget.onAnswersChanged(widget.answers);
    
    _simulateMyoTyping(() {
      setState(() {
        if (_currentQuestionIndex == 2) _currentQuestionIndex = 3;
      });
    });
    // TODO: 播放 assets/audio/option_select_pop.mp3
  }

  void _undoQuestion(int targetIndex) {
    setState(() {
      _currentQuestionIndex = targetIndex;
      if (targetIndex <= 0) widget.answers.identity = null;
      if (targetIndex <= 1) widget.answers.savings = null;
      if (targetIndex <= 2) widget.answers.volatility = null;
    });
    widget.onAnswersChanged(widget.answers);
  }

  Widget _buildMyoBubble(String text, {bool isReaction = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🐱')), // TODO: Myo 头像
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isReaction ? const Color(0xFFFFF9F0) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(
                  color: isReaction ? const Color(0xFFFFB547) : const Color(0xFFE6E8EC),
                  width: 2,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isReaction ? const Color(0xFFD97706) : const Color(0xFF1F2328),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(String text, {VoidCallback? onUndo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onUndo != null)
            GestureDetector(
              onTap: onUndo,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 16,
                  color: Color(0xFFFF6B8B),
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF4CC38A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserOptions<T>({
    required List<T> options,
    required String Function(T) labelBuilder,
    required void Function(T) onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, left: 52.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.end,
        children: options.map((option) {
          return GestureDetector(
            onTap: () => onSelect(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF4CC38A), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFD7E8DD),
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                labelBuilder(option),
                style: const TextStyle(
                  color: Color(0xFF4CC38A),
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: Column(
          children: [
            // 进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(3, (index) {
                  final isFilled = index < _currentQuestionIndex;
                  final isCurrent = index == _currentQuestionIndex;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 12,
                      decoration: BoxDecoration(
                        color: isFilled || isCurrent
                            ? const Color(0xFF4CC38A)
                            : const Color(0xFFE6E8EC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      // TODO: 在 isCurrent 处添加 Myo 头像跳跃动画
                    ),
                  );
                }),
              ),
            ),
            
            // 聊天区
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  _buildMyoBubble('先认识一下！你现在主要在做什么？'),
                  if (widget.answers.identity == null)
                    _buildUserOptions<UserIdentityType>(
                      options: UserIdentityType.values,
                      labelBuilder: (t) => t.label,
                      onSelect: _updateIdentity,
                    )
                  else
                    _buildUserBubble(
                      widget.answers.identity!.label,
                      onUndo: () => _undoQuestion(0),
                    ),
                  
                  if (_currentQuestionIndex == 0 && _isMyoTyping)
                    _buildMyoBubble('...', isReaction: true),

                  if (_currentQuestionIndex >= 1) ...[
                    _buildMyoBubble(widget.answers.identity!.feedback, isReaction: true),
                    _buildMyoBubble('好的，那你大概每个月能攒下多少？不用精确～'),
                    if (widget.answers.savings == null)
                      _buildUserOptions<SavingsRange>(
                        options: SavingsRange.values,
                        labelBuilder: (t) => t.label,
                        onSelect: _updateSavings,
                      )
                    else
                      _buildUserBubble(
                        widget.answers.savings!.label,
                        onUndo: () => _undoQuestion(1),
                      ),
                  ],
                  
                  if (_currentQuestionIndex == 1 && _isMyoTyping)
                    _buildMyoBubble('...', isReaction: true),

                  if (_currentQuestionIndex >= 2) ...[
                    _buildMyoBubble(widget.answers.savings!.feedback, isReaction: true),
                    _buildMyoBubble('看到账户有涨有跌时，你更像哪一种？'),
                    if (widget.answers.volatility == null)
                      _buildUserOptions<VolatilityFeeling>(
                        options: VolatilityFeeling.values,
                        labelBuilder: (t) => '${t.emoji} ${t.label}',
                        onSelect: _updateVolatility,
                      )
                    else
                      _buildUserBubble(
                        '${widget.answers.volatility!.emoji} ${widget.answers.volatility!.label}',
                        onUndo: () => _undoQuestion(2),
                      ),
                  ],

                  if (_currentQuestionIndex == 2 && _isMyoTyping)
                    _buildMyoBubble('...', isReaction: true),

                  if (_currentQuestionIndex >= 3) ...[
                    _buildMyoBubble(widget.answers.volatility!.feedback, isReaction: true),
                    _buildMyoBubble('收到！你的专属起步计划要出炉了 🌱'),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
            
            // 底部按钮区
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE6E8EC), width: 2)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: BouncyButton(
                  onPressed: widget.answers.isComplete ? widget.onNext : null,
                  color: widget.answers.isComplete ? const Color(0xFF4CC38A) : const Color(0xFFE6E8EC),
                  shadowColor: widget.answers.isComplete ? const Color(0xFF3BA06E) : Colors.transparent,
                  borderRadius: 28,
                  child: Text(
                    widget.answers.isComplete ? '下一步：看看投资到底在干嘛' : '请先回答完上面的问题',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: widget.answers.isComplete ? Colors.white : const Color(0xFF8A948E),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
