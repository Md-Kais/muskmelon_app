import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../strings.dart';
import 'data/recipe_data.dart';
import 'models/recipe.dart';
import 'recipe_detail_screen.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  bool get _supportsTts {
    if (kIsWeb) return true;
    try {
      return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

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
              itemCount: recipesData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: gap,
                mainAxisSpacing: 16,
                mainAxisExtent: tileH, // fixed, responsive height → no overflow
              ),
              itemBuilder: (_, i) => _RecipeCard(
                recipe: recipesData[i],
                supportsTts: _supportsTts,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool supportsTts;
  const _RecipeCard({required this.recipe, required this.supportsTts});

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final title = isBn ? recipe.titleBn : recipe.titleEn;
    final primary = AppTheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: MediaQuery.withClampedTextScaling(
          // Prevent huge system text from breaking the tile layout
          minScaleFactor: 0.90,
          maxScaleFactor: 1.20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top image (4:3)
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  recipe.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: primary.withValues(alpha: .08),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),

              // Title (max 2 lines)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

              // Short line under title (1 line)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                child: Text(
                  isBn ? 'উপকরণ • ধাপ • ভিডিও' : 'Ingredients • Steps • Video',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withValues(alpha: .70),
                      ),
                ),
              ),

              // Footer row (kept compact)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    Icon(Icons.restaurant_menu, size: 18, color: primary),
                    const Spacer(),
                    if (supportsTts) Icon(Icons.volume_up, size: 18, color: primary),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
