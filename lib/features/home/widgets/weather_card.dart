import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../strings.dart';

class WeatherCard extends StatelessWidget {
  final String title;
  final String temp;      // e.g., "২৮°C" or "28°C"
  final String humidity;  // e.g., "৭৫%" or "75%"
  final String rain;      // e.g., "৩০%" or "30%"

  const WeatherCard({
    super.key,
    required this.title,
    required this.temp,
    required this.humidity,
    required this.rain,
  });

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Weather glyph
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wb_sunny),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with ellipsis to avoid overflow
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // trims long titles
                  ),
                  const SizedBox(height: 6),

                  // Responsive stats row: Row -> Wrap when tight
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final scale =
                          MediaQuery.textScalerOf(ctx).scale(1); // Flutter TextScaler
                      final tooTight =
                          constraints.maxWidth < 300 || scale > 1.20;

                      // Build either a Row (evenly spaced) or a Wrap (two per line)
                      Widget stats;
                      if (tooTight) {
                        final itemW = (constraints.maxWidth - 12) / 2;
                        stats = Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            SizedBox(width: itemW, child: _KV(t.temp, temp)),
                            SizedBox(width: itemW, child: _KV(t.humidity, humidity)),
                            SizedBox(width: itemW, child: _KV(t.rain, rain)),
                          ],
                        ); // Wrap auto-flows to next line. :contentReference[oaicite:1]{index=1}
                      } else {
                        stats = Row(
                          children: [
                            Expanded(child: _KV(t.temp, temp)),
                            const SizedBox(width: 8),
                            Expanded(child: _KV(t.humidity, humidity)),
                            const SizedBox(width: 8),
                            Expanded(child: _KV(t.rain, rain)),
                          ],
                        ); // Expanded divides width evenly. :contentReference[oaicite:2]{index=2}
                      }

                      // Clamp ONLY this section’s text scaling to keep layout stable
                      return MediaQuery.withClampedTextScaling(
                        minScaleFactor: 0.90,
                        maxScaleFactor: 1.20, // still accessible, but safe
                        child: stats, // docs show this exact pattern. :contentReference[oaicite:3]{index=3}
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KV extends StatelessWidget {
  final String k, v;
  const _KV(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium;
    final valueStyle = Theme.of(context).textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          k,
          style: labelStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // prevent label overflow
        ),
        const SizedBox(height: 2),
        Text(
          v,
          style: valueStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // prevent value overflow
        ),
      ],
    );
  }
}
