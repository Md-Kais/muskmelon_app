import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../app_theme.dart';
import '../../shell.dart';
import '../../locale_controller.dart';
import '../../strings.dart';
import 'widgets/quick_card.dart';
import 'widgets/tip_card.dart';
import 'widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _ttsAvailable = false;

  bool get _platformSupportsTts {
    // flutter_tts typically supports Android, iOS, Web, macOS.
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
    _initTts();
  }

  Future<void> _initTts() async {
    if (!_platformSupportsTts) {
      setState(() => _ttsAvailable = false);
      return;
    }
    try {
      // Ensures method channel is ready; avoid MissingPluginException on first frame.
      await _tts.awaitSpeakCompletion(true);
      setState(() => _ttsAvailable = true);
    } catch (_) {
      setState(() => _ttsAvailable = false);
    }
  }

  final List<String> _tipsBn = const [
    'ফুল আসার সময় নিয়মিত পানি দিন; অতিরিক্ত পানি এড়িয়ে চলুন যাতে শিকড় না পচে।',
    'মাটি ঝুরঝুরে রাখুন এবং আগাছা পরিষ্কার করুন যাতে গাছ দ্রুত বাড়ে।',
    'বীজ বপনের আগে ১২–২৪ ঘণ্টা ভিজিয়ে রাখলে অঙ্কুরোদগম ভালো হয়।',
    'পাতা হলদে হলে জিঙ্ক/আয়রন ঘাটতি পরীক্ষা করুন।',
    'ফল সেটের সময় হালকা জৈব সার দিন; অতিরিক্ত নাইট্রোজেন এড়ান।',
    'ড্রিপ সেচ ব্যবহার করলে পানি সাশ্রয় হয় এবং রোগ কমে।',
    'ফল মাটিতে না লাগে—তলায় খড়/পলিথিন দিন।',
  ];

  final List<String> _tipsEn = const [
    'Water regularly at flowering; avoid overwatering to prevent root rot.',
    'Keep soil loose and weed-free for faster growth.',
    'Soak seeds 12–24 hours before sowing to boost germination.',
    'Yellow leaves? Check possible zinc/iron deficiency.',
    'During fruit set, add light organic feed; avoid excess nitrogen.',
    'Drip irrigation saves water and lowers disease pressure.',
    'Keep fruit off the soil—place straw/plastic underneath.',
  ];

  String get _todayTip {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final src = isBn ? _tipsBn : _tipsEn;
    final i = DateTime.now().day % src.length;
    return src[i];
  }

  Future<void> _speak(String text) async {
    if (!_ttsAvailable) return;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    try {
      await _tts.setLanguage(isBn ? 'bn-BD' : 'en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isBn
            ? 'দুঃখিত, ভয়েস প্লে করা যায়নি।'
            : 'Sorry, couldn’t play voice.')),
      );
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = S.of(context);
    final localeTag = Localizations.localeOf(context).toLanguageTag(); // e.g., bn-BD

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primary],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/hero_overlay.png'),
                  fit: BoxFit.cover,
                  opacity: 0.06,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 12, offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.homeHeadline,
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(t.homeSub,
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.white.withValues(alpha: .95))),
                  const SizedBox(height: 12),

                  // >>> Overflow-safe controls (CTA + language toggle)
                  Builder(builder: (context) {
                    final size = MediaQuery.sizeOf(context);
                    final width = size.width;

                    // Current text scale (1.0 = default). Clamp only this row.
                    final currentScale = MediaQuery.textScalerOf(context).scale(1);
                    final clampedScale = currentScale.clamp(0.90, 1.15).toDouble();

                    // Go "compact" on very small screens or large text scales.
                    final compact = width < 360 || currentScale > 1.20;
                    final segBn = compact ? 'BN' : 'বাংলা';
                    final segEn = compact ? 'EN' : 'English';

                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(clampedScale)),
                      child: OverflowBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        overflowAlignment: OverflowBarAlignment.start,
                        spacing: 8,
                        overflowSpacing: 8,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 140),
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                minimumSize: const Size(0, 40),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () => NavShell.of(context)?.setIndex(1),
                              child: Text(t.ctaStart,
                                  style: theme.textTheme.labelLarge),
                            ),
                          ),

                          SegmentedButton<String>(
                            showSelectedIcon: false,
                            style: ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              minimumSize:
                                  WidgetStateProperty.all(const Size(0, 40)),
                            ),
                            segments: [
                              ButtonSegment(value: 'bn', label: Text(segBn)),
                              ButtonSegment(value: 'en', label: Text(segEn)),
                            ],
                            selected: {
                              Localizations.localeOf(context).languageCode == 'en'
                                  ? 'en'
                                  : 'bn'
                            },
                            onSelectionChanged: (s) {
                              final v = s.first;
                              appLocale.value = (v == 'en')
                                  ? const Locale('en', 'US')
                                  : const Locale('bn', 'BD');
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  // <<< end overflow-safe controls
                ],
              ),
            ),
          ),

          // Quick access cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  QuickCard(
                    assetImage: 'assets/images/card_steps.png',
                    bgColor: const Color(0xFFE7F5EA),
                    title: t.qcStepsTitle,
                    subtitle: t.qcStepsSub,
                    onTap: () => NavShell.of(context)?.setIndex(1),
                  ),
                  const SizedBox(height: 10),
                  QuickCard(
                    assetImage: 'assets/images/card_pests.png',
                    bgColor: const Color(0xFFFFEFE6),
                    title: t.qcPestTitle,
                    subtitle: t.qcPestSub,
                    onTap: () => NavShell.of(context)?.setIndex(2),
                  ),
                  const SizedBox(height: 10),
                  QuickCard(
                    assetImage: 'assets/images/card_recipes.png',
                    bgColor: const Color(0xFFEFF4FF),
                    title: t.qcRecTitle,
                    subtitle: t.qcRecSub,
                    onTap: () => NavShell.of(context)?.setIndex(3),
                  ),
                  const SizedBox(height: 10),
                  QuickCard(
                    assetImage: 'assets/images/card_support.png',
                    bgColor: const Color(0xFFFFF7E6),
                    title: t.qcSupTitle,
                    subtitle: t.qcSupSub,
                    onTap: () => NavShell.of(context)?.setIndex(4),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Tip (speak button hidden if TTS unavailable)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TipCard(
                title: t.todaysTip,
                tip: _todayTip,
                onSpeak: _ttsAvailable ? () => _speak(_todayTip) : null,
                showSpeak: _ttsAvailable,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Weather
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WeatherCard(
                title: t.weatherTitle,
                temp: Localizations.localeOf(context).languageCode == 'bn' ? '২৮°C' : '28°C',
                humidity: Localizations.localeOf(context).languageCode == 'bn' ? '৭৫%' : '75%',
                rain: Localizations.localeOf(context).languageCode == 'bn' ? '৩০%' : '30%',
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Calendar with locale
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TableCalendar(
                    locale: localeTag, // <- important for bn names
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.now(),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
