// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Finance term text - highlights glossary terms with tap explanations
// 模块: 金融术语文本 - 高亮术语并提供点击解释
//
// Dependencies: flutter/material.dart, guidance_glossary
// 依赖: flutter/material.dart, guidance_glossary
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

import 'package:flutter/material.dart';

import '../data/guidance_glossary.dart';

class FinanceTermText extends StatelessWidget {
  const FinanceTermText({
    super.key,
    required this.text,
    required this.style,
    this.highlightedTerms,
    this.highlightStyle,
    this.textAlign,
    this.onTermOpened,
  });

  final String text;
  final TextStyle style;
  final Set<String>? highlightedTerms;
  final TextStyle? highlightStyle;
  final TextAlign? textAlign;
  final ValueChanged<GuidanceGlossaryTerm>? onTermOpened;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: _buildSpans(context)),
      textAlign: textAlign,
    );
  }

  List<InlineSpan> _buildSpans(BuildContext context) {
    final TextStyle termStyle =
        highlightStyle ??
        style.copyWith(
          color: const Color(0xFF086A9D),
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.none,
        );
    final Set<String> activeTerms =
        highlightedTerms ??
        guidanceGlossaryTerms
            .map((GuidanceGlossaryTerm term) => term.term)
            .toSet();
    final List<_GlossaryAlias> aliases = _sortedAliases(activeTerms);
    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;

    while (cursor < text.length) {
      final _GlossaryAlias? match = _matchAt(text, cursor, aliases);
      if (match == null) {
        final int next = _nextMatchIndex(text, cursor + 1, aliases);
        final int end = next == -1 ? text.length : next;
        spans.add(TextSpan(text: text.substring(cursor, end), style: style));
        cursor = end;
        continue;
      }

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onTermOpened?.call(match.term);
              showFinanceTermDialog(context, match.term, match.alias);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE4F6FF),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(match.alias, style: termStyle),
              ),
            ),
          ),
        ),
      );
      cursor += match.alias.length;
    }

    return spans;
  }

  List<_GlossaryAlias> _sortedAliases(Set<String> activeTerms) {
    final List<_GlossaryAlias> aliases = <_GlossaryAlias>[];
    for (final GuidanceGlossaryTerm term in guidanceGlossaryTerms) {
      if (!activeTerms.contains(term.term)) {
        continue;
      }
      aliases.add(_GlossaryAlias(alias: term.term, term: term));
      for (final String alias in term.aliases) {
        aliases.add(_GlossaryAlias(alias: alias, term: term));
      }
    }
    aliases.sort((_GlossaryAlias a, _GlossaryAlias b) {
      return b.alias.length.compareTo(a.alias.length);
    });
    return aliases;
  }

  _GlossaryAlias? _matchAt(
    String text,
    int index,
    List<_GlossaryAlias> aliases,
  ) {
    for (final _GlossaryAlias alias in aliases) {
      if (text.startsWith(alias.alias, index)) {
        return alias;
      }
    }
    return null;
  }

  int _nextMatchIndex(String text, int from, List<_GlossaryAlias> aliases) {
    for (int index = from; index < text.length; index += 1) {
      if (_matchAt(text, index, aliases) != null) {
        return index;
      }
    }
    return -1;
  }
}

void showFinanceTermDialog(
  BuildContext context,
  GuidanceGlossaryTerm term, [
  String? surface,
]) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      final String visibleSurface = surface ?? term.term;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFCFEFFF), width: 2),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE4F6FF),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/characters/myo/myo_thinking.png',
                          fit: BoxFit.contain,
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
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (visibleSurface != term.term)
                              Text(
                                '你点到的是：$visibleSurface',
                                style: const TextStyle(
                                  color: Color(0xFF7A858B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 34),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    term.plainExplanation,
                    style: const TextStyle(
                      color: Color(0xFF23302A),
                      height: 1.5,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFDF8A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(
                          Icons.lightbulb_rounded,
                          size: 18,
                          color: Color(0xFFB45309),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            term.example,
                            style: const TextStyle(
                              color: Color(0xFF8A4B00),
                              height: 1.45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 4,
              top: 0,
              child: Material(
                color: const Color(0xFF086A9D),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: '关闭解释',
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _GlossaryAlias {
  const _GlossaryAlias({required this.alias, required this.term});

  final String alias;
  final GuidanceGlossaryTerm term;
}
