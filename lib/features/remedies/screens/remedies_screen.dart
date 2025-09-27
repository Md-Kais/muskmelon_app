// lib/features/remedies/screens/remedies_screen.dart
import 'package:flutter/material.dart';
import '../../../app_theme.dart'; // if you have it
import '../data/pest_data.dart';
import '../models/pest.dart';
import 'pest_detail_screen.dart';

class RemediesScreen extends StatelessWidget {
  const RemediesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final title = isBn ? 'রোগ–পোকা' : 'Remedies';
    // inside RemediesScreen build():
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isBn ? 'রেসিপি' : 'Recipes',
              style: Theme.of(context).textTheme.titleMedium),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),

        // ▶︎ Responsive, overflow-safe grid
        body: LayoutBuilder(
          builder: (context, constraints) {
            const columns = 2;
            const gap = 16.0;

            // Tile width within the grid (padding is set on GridView)
            final tileW = (constraints.maxWidth - (columns - 1) * gap) / columns;

            // 4:3 image + 2-line title + one line sub + footer row + padding
            final imageH = tileW * 3 / 4;
            const titleH = 44.0;     // ≈ two lines of titleSmall
            const subH = 20.0;       // ≈ one line of bodySmall
            const footerH = 40.0;    // icons/chevron row
            const chrome = 20.0;     // inner vertical paddings
            final tileH = (imageH + titleH + subH + footerH + chrome).ceilToDouble();

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: pestsData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: gap,
                mainAxisSpacing: 16,
                mainAxisExtent: tileH, // fixed, responsive height → no overflow
              ),
             itemBuilder: (_, i) => _PestCard(pest: pestsData[i]),
            );
          },
        ),
      ),
    );
  }
}

class _PestCard extends StatelessWidget {
  final Pest pest;
  const _PestCard({required this.pest});

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final name = isBn ? pest.nameBn : pest.nameEn;
    final line = isBn ? pest.shortSymptomBn : pest.shortSymptomEn;

    final primary = _tryAppPrimary(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PestDetailScreen(pest: pest)),
      ),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.asset(
                pest.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: primary.withOpacity(.08),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            // Texts
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Text(
                line,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black.withOpacity(.7),
                    ),
              ),
            ),
            const Spacer(),
            // TTS hint + chevron
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Icon(Icons.volume_up, size: 18, color: primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isBn ? 'শুনুন' : 'Listen',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _tryAppPrimary(BuildContext context) {
    try {
      return AppTheme.primary; // your project theme
    } catch (_) {
      return const Color(0xFF4CAF50); // fallback
    }
  }
}
