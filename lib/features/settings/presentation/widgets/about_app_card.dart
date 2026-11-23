import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';

class _SocialChannel {
  final String title;
  final String handle;
  final String url;
  final IconData icon;

  const _SocialChannel({
    required this.title,
    required this.handle,
    required this.url,
    required this.icon,
  });
}

class AboutAppCard extends StatelessWidget {
  final AsyncValue<int> wordCountAsync;

  const AboutAppCard({super.key, required this.wordCountAsync});

  List<_SocialChannel> _buildChannels(AppLocalizations l10n) => [
    _SocialChannel(
      title: l10n.channelTelegram,
      handle: '@takband_qandeel',
      url: 'https://t.me/takband_qandeel',
      icon: LucideIcons.send,
    ),
    _SocialChannel(
      title: l10n.channelInstagram,
      handle: '@takband.qandeel',
      url: 'https://www.instagram.com/takband.qandeel',
      icon: LucideIcons.camera,
    ),
    _SocialChannel(
      title: l10n.channelYoutube,
      handle: '@takband_qandeel',
      url: 'https://www.youtube.com/@takband_qandeel',
      icon: LucideIcons.video,
    ),
    _SocialChannel(
      title: l10n.channelCastbox,
      handle: 'TakbandQandeel Podcast',
      url: 'https://castbox.fm/va/7074852',
      icon: LucideIcons.headphones,
    ),
  ];

  String _toEasternDigits(String input) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var output = input;
    for (var i = 0; i < western.length; i++) {
      output = output.replaceAll(western[i], eastern[i]);
    }
    return output;
  }

  Future<void> _openChannel(
    BuildContext context,
    _SocialChannel channel,
  ) async {
    HapticFeedback.selectionClick();
    final uri = Uri.parse(channel.url);

    try {
      final openedExternal = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (openedExternal) return;

      final openedDefault = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      if (openedDefault) return;
    } catch (e) {
      debugPrint('Failed to launch ${channel.url}: $e');
    }

    if (context.mounted) {
      await _copyLink(context, channel.url);
    }
  }

  Future<void> _copyLink(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.linkCopiedSnack),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final channels = _buildChannels(l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Identity Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.bookOpenText,
                    size: 22,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appSubtitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          final version = _toEasternDigits(
                            snapshot.data?.version ?? '',
                          );
                          final label = version.isEmpty
                              ? l10n.offlineBadge
                              : l10n.versionLabel(version);
                          return Text(
                            label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.aboutSayadGanjDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.database,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wordCountAsync.when(
                      data: (count) => l10n.totalWordsCount(
                        _toEasternDigits(count.toString()),
                      ),
                      loading: () => l10n.totalWordsCount('...'),
                      error: (_, __) => l10n.totalWordsCount('—'),
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 16),

            // TakbandQandeel Activists Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    LucideIcons.feather,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.takbandTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.takbandSubtitle,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(l10n.takbandDescription, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 14),

            // Social & Podcast Links
            Text(
              l10n.ourChannelsAndPodcast,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(channels.length, (index) {
              final channel = channels[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == channels.length - 1 ? 0 : 8,
                ),
                child: Material(
                  color: theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outline, width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openChannel(context, channel),
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      _copyLink(context, channel.url);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              channel.icon,
                              size: 17,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  channel.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    channel.handle,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LucideIcons.arrowUpLeft,
                            size: 17,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 14),

            // Made with love footer
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.madeWithLove,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.takbandName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
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
