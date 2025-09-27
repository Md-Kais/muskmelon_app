import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import 'step_guide_screen.dart';
import '../../strings.dart';

class StepDetailScreen extends StatefulWidget {
  final Stage stage;
  const StepDetailScreen({super.key, required this.stage});

  @override
  State<StepDetailScreen> createState() => _StepDetailScreenState();
}

class _StepDetailScreenState extends State<StepDetailScreen> {
  YoutubePlayerController? _yt;

  @override
  void initState() {
    super.initState();
    if (widget.stage.youtubeId.isNotEmpty) {
      _yt = YoutubePlayerController(
        initialVideoId: widget.stage.youtubeId,
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
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final s = widget.stage;

    final title = isBn ? s.titleBn : s.titleEn;
    final desc  = isBn ? s.descBn  : s.descEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Header image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              s.image,
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

          // Description
          Text(desc, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),

          // YouTube video (if provided)
          if (_yt != null) ...[
            Text(isBn ? 'ভিডিও নির্দেশনা' : 'Video guide',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(
                controller: _yt!,
                showVideoProgressIndicator: true,
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: .45)),
              ),
              child: Text(
                isBn ? 'ভিডিও শীঘ্রই যোগ করা হবে।' : 'Video will be added soon.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // References (clickable links)
          _buildReferences(s, context, isBn),
        ],
      ),
    );
  }

  /// Builds the reference links card at the bottom.
  Widget _buildReferences(Stage s, BuildContext context, bool isBn) {
    if (s.refs.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isBn ? 'রেফারেন্স' : 'References',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...s.refs.map((u) => ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const Icon(Icons.link),
                  title: Text(u,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () async {
                    final uri = Uri.parse(u);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBn
                                ? 'লিংক খোলা যায়নি'
                                : 'Could not launch the link',
                          ),
                        ),
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
