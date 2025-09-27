import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines; // collapsed lines
  final String expandLabelBn;
  final String collapseLabelBn;
  final String expandLabelEn;
  final String collapseLabelEn;

  const ExpandableText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 6,
    this.expandLabelBn = 'আরও দেখুন',
    this.collapseLabelBn = 'কম দেখুন',
    this.expandLabelEn = 'See more',
    this.collapseLabelEn = 'See less',
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final labelExpand   = isBn ? widget.expandLabelBn   : widget.expandLabelEn;
    final labelCollapse = isBn ? widget.collapseLabelBn : widget.collapseLabelEn;
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        // Detect if text would overflow when collapsed
        final tp = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.maxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final overflowed = tp.didExceedMaxLines; // shows only when needed. :contentReference[oaicite:0]{index=0}

        return AnimatedSize( // smooth expand/collapse. :contentReference[oaicite:1]{index=1}
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: style,
                maxLines: _expanded ? null : widget.maxLines, // clamp lines. :contentReference[oaicite:2]{index=2}
                overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              if (overflowed) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _expanded ? labelCollapse : labelExpand,
                        style: style.copyWith(
                          color: const Color(0xFFFDD835),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: const Color(0xFFFDD835),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
