import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app_theme.dart';
import '../../strings.dart';
import '../../locale_controller.dart';
import 'step_detail_screen.dart';

class Stage {
  final String keyName;
  final String image;
  final String titleBn;
  final String titleEn;
  final String shortBn;
  final String shortEn;
  final String descBn;
  final String descEn;
  final String youtubeId;
  final List<String> refs;

  const Stage({
    required this.keyName,
    required this.image,
    required this.titleBn,
    required this.titleEn,
    required this.shortBn,
    required this.shortEn,
    required this.descBn,
    required this.descEn,
    required this.youtubeId,
    required this.refs,
  });
}

class StepGuideScreen extends StatefulWidget {
  const StepGuideScreen({super.key});

  @override
  State<StepGuideScreen> createState() => _StepGuideScreenState();
}

class _StepGuideScreenState extends State<StepGuideScreen> {
  final _page = PageController(viewportFraction: .90);
  final _tts = FlutterTts();

  bool _ttsAvailable = false;
  late final List<Stage> _stages;

  Box? _box; // Hive box for progress
  final Set<String> _done = {}; // completed stage keys
  bool _loading = true;

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
    _stages = _buildStages();
    _initTts();
    _openProgress();
  }

  List<Stage> _buildStages() => const [
    Stage(
      keyName: 'seed',
      image: 'assets/images/step_seed.png',
      titleBn: 'বীজ নির্বাচন',
      titleEn: 'Seed Selection',
      shortBn: 'ভালো মানের বীজ নির্বাচন',
      shortEn: 'Choose quality seeds',
      descBn:
          'বিশ্বস্ত উৎস থেকে উচ্চ অঙ্কুরোদগমের (fresh, disease-free) বীজ নিন। উষ্ণ তাপমাত্রা (প্রায় 21–32°C) অঙ্কুরোদগমে সুবিধা দেয়। বপনের আগে বীজ পরিষ্কার ও শুষ্ক রাখুন, চাইলে 12–24 ঘন্টা ভিজিয়ে নরম করা যায়। রোগমুক্ত করতে ট্রে/মাটিও পরিষ্কার রাখুন।',
      descEn:
          'Buy fresh, disease-free seed from a trusted source. Warm soils (≈70–90°F / 21–32°C) improve germination. Keep seed clean and dry; pre-soaking 12–24h can help imbibition. Use clean trays/soil to avoid damping-off.',
      youtubeId: 'uEtvXh3K2IU',
      refs: [
        'https://njaes.rutgers.edu/fs1140/',
        'https://extension.okstate.edu/fact-sheets/fertilizing-home-garden-vegetables.html',
        'https://www.thespruce.com/seed-germination-temperatures-1402287',
      ],
    ),
    Stage(
      keyName: 'soil',
      image: 'assets/images/step_soil.png',
      titleBn: 'মাটি প্রস্তুতি',
      titleEn: 'Soil Preparation',
      shortBn: 'দোআঁশ, পানি নিষ্কাশন ভালো',
      shortEn: 'Loamy, well-drained beds',
      descBn:
          'বাঙ্গি দোআঁশ, পানি নিষ্কাশন ভালো এমন মাটিতে ভালো হয়; pH প্রায় 6.0–6.5 উপযোগী। উঁচু বেড/রিজ বানিয়ে কম্পোস্ট মেশান, আগেই সেচলাইন (ড্রিপ) পাতলে আর্দ্রতা ধরে রাখা সহজ হয়। জৈব সার ও মালচ মাটির তাপমাত্রা ও আগাছা নিয়ন্ত্রণে সহায়ক।',
      descEn:
          'Muskmelon prefers well-drained loam with pH ~6.0–6.5. Build raised beds/ridges, incorporate compost, and lay drip lines early to maintain even moisture. Organic mulch helps weed suppression and soil temperature.',
      youtubeId: 'uEtvXh3K2IU',
      refs: [
        'https://njaes.rutgers.edu/fs1140/',
        'https://dmi.gov.in/Documents/DPR/PP/Protected%20Cultivation%20of%20Muskmelon%20%20Polyhouse%2004-12-15.pdf',
        'https://krishi.icar.gov.in/jspui/handle/123456789/24346',
      ],
    ),
    Stage(
      keyName: 'plant',
      image: 'assets/images/step_plant.png',
      titleBn: 'রোপণ',
      titleEn: 'Planting',
      shortBn: 'বীজ বপন বা চারা রোপণ',
      shortEn: 'Direct sow or transplant',
      descBn:
          'প্রতি গর্তে ২–৩টি বীজ ২–৩ সেমি গভীরে বপন করুন; পরে একটি শক্ত চারা রেখে পাতলা করুন। সারি-সারি দূরত্ব সাধারণত 1.8–2.4 মিটার এবং গর্তে গাছের দূরত্ব 0.6–0.9 মিটার রাখা যায় (জমি/জাত অনুযায়ী সামঞ্জস্য করুন)। পুরো রোদ ও উষ্ণ মাটি নিশ্চিত করুন।',
      descEn:
          'Sow 2–3 seeds at 2–3 cm depth; thin to the best seedling. Typical spacing: 6–8 ft between rows and 2–3 ft in-row (adjust by variety/field). Plant into warm, full-sun beds for vigorous vines.',
      youtubeId: 'uEtvXh3K2IU',
      refs: [
        'https://njaes.rutgers.edu/fs1140/',
        'https://acis.icar.gov.in/kaes-ext/handle/123456789/2381',
      ],
    ),
    Stage(
      keyName: 'care',
      image: 'assets/images/step_care.png',
      titleBn: 'গাছের যত্ন',
      titleEn: 'Crop Care',
      shortBn: 'সেচ, সার, আগাছা, রোগ-পোকা',
      shortEn: 'Irrigation, feeding, weeds & pests',
      descBn:
          'ড্রিপ সেচে মাটি সমান ভেজা রাখুন; ফুল-ফল ধরার সময় হালকা টপ-ড্রেসিং দিন। প্লাস্টিক/জৈব মালচ আগাছা কমায়। লতা উঠলে ফল মাটির স্পর্শ কমাতে খড়/প্লেট দিন। পাউডারি মিলডিউ, ফলপচা বা কীট লক্ষণ দেখলে দ্রুত ব্যবস্থা নিন।',
      descEn:
          'Use drip to keep soil evenly moist; side-dress lightly around flowering/fruit-set. Mulch to reduce weeds. Place straw/tiles under fruit to avoid rot. Scout for powdery mildew, rots and insects and act promptly.',
      youtubeId: 'uEtvXh3K2IU',
      refs: [
        'https://extension.okstate.edu/fact-sheets/fertilizing-home-garden-vegetables.html',
        'https://njaes.rutgers.edu/fs1140/',
        'https://dmi.gov.in/Documents/DPR/PP/Protected%20Cultivation%20of%20Muskmelon%20%20Polyhouse%2004-12-15.pdf',
      ],
    ),
    Stage(
      keyName: 'harvest',
      image: 'assets/images/step_harvest.png',
      titleBn: 'ফসল তোলা',
      titleEn: 'Harvest',
      shortBn: 'সঠিক পরিপক্বতা ও সংরক্ষণ',
      shortEn: 'Maturity & handling',
      descBn:
          'ক্যান্টালুপ টাইপে “ফুল-স্লিপ” অবস্থায় ডাঁটা সহজেই আলাদা হয়—এটাই আদর্শ সময়। খোসার জালিকা স্পষ্ট ও ঘ্রাণ বাড়ে। আঘাত এড়িয়ে ছায়ায় ঠান্ডা করুন; হালকা ঠান্ডায় (শীতল, শুকনো) রাখলে গুণাগুণ থাকে।',
      descEn:
          'For cantaloupe types, harvest at “full-slip” when the stem detaches easily; netting and aroma intensify. Handle gently, shade-cool promptly, and store cool/dry to retain quality.',
      youtubeId: '6gbxlzOyFJU',
      refs: [
        'https://dmi.gov.in/Documents/DPR/PP/Protected%20Cultivation%20of%20Muskmelon%20%20Polyhouse%2004-12-15.pdf',
        'https://njaes.rutgers.edu/fs1140/',
      ],
    ),
  ];

  Future<void> _initTts() async {
    if (!_supportsTts) {
      setState(() => _ttsAvailable = false);
      return;
    }
    try {
      await _tts.awaitSpeakCompletion(true);
      setState(() => _ttsAvailable = true);
    } catch (_) {
      setState(() => _ttsAvailable = false);
    }
  }

  Future<void> _openProgress() async {
    try {
      _box = await Hive.openBox('step_progress');
      for (final s in _stages) {
        final v = _box!.get(s.keyName);
        if (v == true) _done.add(s.keyName);
      }
    } catch (_) {
      // ignore; stays in-memory only
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleDone(Stage s) async {
    if (_done.contains(s.keyName)) {
      _done.remove(s.keyName);
      await _box?.put(s.keyName, false);
    } else {
      _done.add(s.keyName);
      await _box?.put(s.keyName, true);
    }
    if (mounted) setState(() {});
  }

  Future<void> _speak(String text) async {
    if (!_ttsAvailable) return;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    try {
      await _tts.setLanguage(isBn ? 'bn-BD' : 'en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {}
  }

  @override
  void dispose() {
    _page.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    if (_loading) {
      return const SafeArea(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ===== Top slider =====
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _page,
                itemCount: _stages.length,
                padEnds: false,
                itemBuilder: (context, i) {
                  final s = _stages[i];
                  final done = _done.contains(s.keyName);
                  return Padding(
                    padding: EdgeInsets.only(
                      left: i == 0 ? 16 : 8,
                      right: i == _stages.length - 1 ? 16 : 8,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Stack(
                      children: [
                        // image card
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StepDetailScreen(stage: s),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(s.image),
                                fit: BoxFit.cover,
                                onError: (_, __) {},
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                )
                              ],
                              border: Border.all(
                                color: done
                                    ? AppTheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // title overlay (bottom)
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .35),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isBn ? s.titleBn : s.titleEn,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        // DONE tick (top-right)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _toggleDone(s),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: done
                                    ? AppTheme.primary.withValues(alpha: .90)
                                    : Colors.white.withValues(alpha: .85),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .20),
                                    blurRadius: 8,
                                  )
                                ],
                              ),
                              child: Icon(
                                done ? Icons.check : Icons.check_circle_outline,
                                size: 20,
                                color: done ? Colors.white : AppTheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Slider dots
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SmoothPageIndicator(
                  controller: _page,
                  count: _stages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 3,
                    spacing: 6,
                    dotColor: Colors.grey.withValues(alpha: .4),
                    activeDotColor: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ),

          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Text(
                isBn ? 'ধাপসমূহ' : 'Stages',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),

          // ===== Scrollable cards list =====
          SliverList.builder(
            itemCount: _stages.length,
            itemBuilder: (context, i) {
              final s = _stages[i];
              final title = isBn ? s.titleBn : s.titleEn;
              final short = isBn ? s.shortBn : s.shortEn;
              final done = _done.contains(s.keyName);

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StepDetailScreen(stage: s),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: done
                              ? AppTheme.primary.withValues(alpha: .85)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: LayoutBuilder(
                        builder: (ctx, constraints) {
                          final width = constraints.maxWidth;
                          final textScale = MediaQuery.textScalerOf(ctx).scale(1);
                          final narrow = width < 360 || textScale > 1.20;

                          final image = ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              s.image,
                              width: 84,
                              height: 84,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 84,
                                height: 84,
                                color: AppTheme.primary.withValues(alpha: .08),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          );

                          final textCol = Expanded(
                            child: Opacity(
                              opacity: done ? 0.8 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      if (done)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primary
                                                .withValues(alpha: .10),
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            isBn ? 'সম্পন্ন' : 'Done',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    short,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );

                          final actions = _StageActions(
                            done: done,
                            isBn: isBn,
                            onToggle: () => _toggleDone(s),
                            ttsAvailable: _ttsAvailable,
                            onSpeak: _ttsAvailable ? () => _speak(short) : null,
                            dense: narrow,
                          );

                          // WIDE: one-row layout
                          if (!narrow) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                image,
                                const SizedBox(width: 12),
                                textCol,
                                const SizedBox(width: 8),
                                actions,
                              ],
                            );
                          }

                          // NARROW: two-row layout (actions on next line, right-aligned)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  image,
                                  const SizedBox(width: 12),
                                  textCol,
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: actions,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
        ],
      ),
    );
  }
}

/// Compact, wrapping action row (tick / TTS / chevron).
class _StageActions extends StatelessWidget {
  final bool done;
  final bool isBn;
  final VoidCallback onToggle;
  final bool ttsAvailable;
  final VoidCallback? onSpeak;
  final bool dense;

  const _StageActions({
    required this.done,
    required this.isBn,
    required this.onToggle,
    required this.ttsAvailable,
    required this.onSpeak,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = dense ? 22.0 : 24.0;
    final box = BoxConstraints.tightFor(
      width: dense ? 36 : 40,
      height: dense ? 36 : 40,
    );

    final children = <Widget>[
      IconButton(
        tooltip: isBn ? 'সম্পন্ন করুন' : 'Mark done',
        onPressed: onToggle,
        icon: Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? AppTheme.primary : AppTheme.textSecondary,
          size: iconSize,
        ),
        constraints: box,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      IconButton(
        tooltip: isBn ? 'শুনুন' : 'Listen',
        onPressed: ttsAvailable ? onSpeak : null,
        icon: Icon(Icons.volume_up, size: iconSize),
        constraints: box,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: iconSize + 2),
    ];

    // Right-align the actions; Wrap allows multi-line if needed.
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 0.90, maxScaleFactor: 1.20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: dense ? 4 : 8,
                runSpacing: dense ? 4 : 8,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

