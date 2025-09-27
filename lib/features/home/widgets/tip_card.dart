import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class TipCard extends StatelessWidget {
  final String title;
  final String tip;
  final VoidCallback? onSpeak;
  final bool showSpeak;

  const TipCard({
    super.key,
    required this.title,
    required this.tip,
    this.onSpeak,
    this.showSpeak = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lightbulb),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(tip, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            if (showSpeak && onSpeak != null)
              IconButton(
                tooltip: 'শুনুন (TTS)',
                onPressed: onSpeak,
                icon: const Icon(Icons.volume_up),
              ),
          ],
        ),
      ),
    );
  }
}
