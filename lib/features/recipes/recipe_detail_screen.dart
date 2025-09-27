import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../app_theme.dart';
import '../../strings.dart';
import 'models/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  YoutubePlayerController? _yt;

  bool get _supportsTts {
    if (kIsWeb) return true;
    try {
      return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.recipe.youtubeId.isNotEmpty) {
      _yt = YoutubePlayerController(
        initialVideoId: widget.recipe.youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          controlsVisibleAtStart: true,
          enableCaption: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _yt?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? r.titleBn : r.titleEn,
            style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          if (_supportsTts)
            IconButton(
              tooltip: isBn ? 'শুনুন' : 'Listen',
              onPressed: null, // hook up FlutterTts if you like
              icon: const Icon(Icons.volume_up),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Header image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              r.imageAsset,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: AppTheme.primary.withValues(alpha: .08),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Ingredients
          Text(isBn ? 'উপকরণ' : 'Ingredients',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          ..._bulletList(isBn ? r.ingredientsBn : r.ingredientsEn),
          const SizedBox(height: 12),

          // Steps
          Text(isBn ? 'প্রস্তুত প্রণালী' : 'Steps',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          ..._numberedList(isBn ? r.stepsBn : r.stepsEn),
          const SizedBox(height: 12),

          // Nutrition
          _NutritionCard(n: r.nutritionPerServing, isBn: isBn),
          const SizedBox(height: 12),

          // YouTube
          if (_yt != null) ...[
            Text(isBn ? 'ভিডিও' : 'Video',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(
                controller: _yt!,
                showVideoProgressIndicator: true,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // References
          if (r.refs.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isBn ? 'রেফারেন্স' : 'References',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...r.refs.map((u) => ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          leading: const Icon(Icons.link),
                          title: Text(u,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () async {
                            // leave to external browser
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isBn
                                    ? 'লিংক খুলতে ব্রাউজার ব্যবহার করুন'
                                    : 'Open link in browser'),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _bulletList(List<String> items) {
    return items
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(e)),
                ],
              ),
            ))
        .toList();
  }

  List<Widget> _numberedList(List<String> steps) {
    return steps.asMap().entries.map((e) {
      final i = e.key + 1;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$i. '),
            Expanded(child: Text(e.value)),
          ],
        ),
      );
    }).toList();
  }
}

class _NutritionCard extends StatelessWidget {
  final Nutrition n;
  final bool isBn;
  const _NutritionCard({required this.n, required this.isBn});

  @override
  Widget build(BuildContext context) {
    final label = isBn ? 'পুষ্টি (প্রতি সার্ভিং)' : 'Nutrition (per serving)';
    final kv = Theme.of(context).textTheme.bodyMedium;
    final vv = Theme.of(context).textTheme.titleMedium;

    Widget row(String k, String v) => Row(
          children: [
            Expanded(child: Text(k, style: kv, maxLines: 1, overflow: TextOverflow.ellipsis)),
            Text(v, style: vv),
          ],
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            row(isBn ? 'ক্যালোরি' : 'Calories', '${n.calories} kcal'),
            row(isBn ? 'কার্বোহাইড্রেট' : 'Carbs', '${n.carbs.toStringAsFixed(1)} g'),
            row(isBn ? 'প্রোটিন' : 'Protein', '${n.protein.toStringAsFixed(1)} g'),
            row(isBn ? 'ফ্যাট' : 'Fat', '${n.fat.toStringAsFixed(1)} g'),
            row(isBn ? 'ফাইবার' : 'Fiber', '${n.fiber.toStringAsFixed(1)} g'),
            row(isBn ? 'পটাসিয়াম' : 'Potassium', '${n.potassium} mg'),
            row(isBn ? 'ভিটামিন C' : 'Vitamin C', '${n.vitaminC.toStringAsFixed(1)} mg'),
            const SizedBox(height: 6),
            Text(
              isBn
                  ? 'নোট: উপরের মান কেবল বাঙ্গির অংশের উপর ভিত্তি করে; ঐচ্ছিক উপাদান যোগ করলে মান পরিবর্তিত হবে।'
                  : 'Note: Values include melon portion only; optional add-ins will change totals.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: .7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
