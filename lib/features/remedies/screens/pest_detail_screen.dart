// lib/features/remedies/screens/pest_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:muskmelon_app/shared/widget/expandable_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_theme.dart';
import '../models/pest.dart';

class PestDetailScreen extends StatefulWidget {
  final Pest pest;
  const PestDetailScreen({super.key, required this.pest});

  @override
  State<PestDetailScreen> createState() => _PestDetailScreenState();
}

class _PestDetailScreenState extends State<PestDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _tts = FlutterTts();
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
    _tts.setLanguage('bn-BD'); // default Bangla; will fallback if not installed
    _tts.setSpeechRate(0.5);
    _tts.setCompletionHandler(() => setState(() => _speaking = false));
    _tts.setCancelHandler(() => setState(() => _speaking = false));
  }

  @override
  void dispose() {
    _tts.stop();
    _tts.dispose();
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    String text;
    switch (_tabs.index) {
      case 0:
        text = isBn ? widget.pest.symptomsBn : widget.pest.symptomsEn;
        break;
      case 1:
        text = isBn ? widget.pest.preventionBn : widget.pest.preventionEn;
        break;
      case 2:
        text = _doseText(widget.pest.organic, isBn);
        break;
      case 3:
        text = _doseText(widget.pest.chemical, isBn);
        break;
      default:
        text = isBn ? widget.pest.safetyBn : widget.pest.safetyEn;
    }
    setState(() => _speaking = true);
    await _tts.stop();
    await _tts.speak(text);
  }

  String _doseText(List<Dose> doses, bool isBn) {
    if (doses.isEmpty) return isBn ? 'তথ্য নেই।' : 'No data.';
    final b = StringBuffer(isBn ? 'ডোজ ও নির্দেশনা:\n' : 'Doses & notes:\n');
    for (final d in doses) {
      b.writeln('• ${d.label} — ${d.amount}');
      if (d.notes.isNotEmpty) b.writeln('   ${isBn ? "নোট" : "Note"}: ${d.notes}');
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pest;
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final title = isBn ? p.nameBn : p.nameEn;
    final primary = _tryAppPrimary();

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: primary,
          unselectedLabelColor: Colors.black87,
          tabs: [
            Tab(text: isBn ? 'লক্ষণ' : 'Symptoms'),
            Tab(text: isBn ? 'প্রতিরোধ' : 'Prevention'),
            Tab(text: isBn ? 'জৈব' : 'Organic'),
            Tab(text: isBn ? 'রাসায়নিক' : 'Chemical'),
            Tab(text: isBn ? 'সতর্কতা' : 'Safety'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _speaking
                ? (isBn ? 'বন্ধ করুন' : 'Stop')
                : (isBn ? 'শুনুন' : 'Listen'),
            onPressed: () async {
              if (_speaking) {
                await _tts.stop();
                setState(() => _speaking = false);
              } else {
                _speak();
              }
            },
            icon: Icon(_speaking ? Icons.stop_circle : Icons.volume_up,
                color: primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              p.imageAsset,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: primary.withOpacity(.08),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 320,
            child: TabBarView(
              controller: _tabs,
              children: [
                _TextTab(text: isBn ? p.symptomsBn : p.symptomsEn),
                _TextTab(text: isBn ? p.preventionBn : p.preventionEn),
                _DoseTab(doses: p.organic),
                _DoseTab(doses: p.chemical),
                _TextTab(text: isBn ? p.safetyBn : p.safetyEn),
              ],
            ),
          ),

          const SizedBox(height: 12),
          _ReferencesCard(
            title: isBn ? 'রেফারেন্স' : 'References',
            links: {...p.references, ...p.organic.expand((e) => e.sources), ...p.chemical.expand((e) => e.sources)}.toList(),
          ),
        ],
      ),
    );
  }

  Color _tryAppPrimary() {
    try {
      return AppTheme.primary;
    } catch (_) {
      return const Color(0xFF4CAF50);
    }
  }
}

extension on FlutterTts {
  void dispose() {}
}

class _TextTab extends StatelessWidget {
  final String text;
  const _TextTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: ExpandableText(
          text,
          maxLines: 6, // collapsed lines
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}


class _DoseTab extends StatelessWidget {
  final List<Dose> doses;
  const _DoseTab({required this.doses});

  @override
  Widget build(BuildContext context) {
    if (doses.isEmpty) {
      return const Center(child: Text('—'));
    }
    return Column(
      children: [
        for (final d in doses) ...[
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: -6,
                    children: [
                      _doseChip(d.amount),
                      if (d.notes.isNotEmpty) _doseChip(d.notes),
                    ],
                  ),
                  if (d.sources.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: d.sources
                          .map((u) => ActionChip(
                                label: const Text('Link'),
                                onPressed: () async {
                                  final uri = Uri.parse(u);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _doseChip(String text) {
    return Chip(
      label: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
      avatar: const Icon(Icons.local_hospital, size: 16),
      backgroundColor: const Color(0xFFFDD835).withOpacity(.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _ReferencesCard extends StatelessWidget {
  final String title;
  final List<String> links;
  const _ReferencesCard({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            ...links.map(
              (u) => ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: const Icon(Icons.link),
                title: Text(u, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () async {
                  final uri = Uri.parse(u);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
