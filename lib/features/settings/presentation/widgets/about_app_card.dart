import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static const List<_SocialChannel> _channels = [
    _SocialChannel(
      title: 'تیلیگرام (Telegram)',
      handle: '@takband_qandeel',
      url: 'https://t.me/takband_qandeel',
      icon: LucideIcons.send,
    ),
    _SocialChannel(
      title: 'انسٹاگرام (Instagram)',
      handle: '@takband.qandeel',
      url: 'https://www.instagram.com/takband.qandeel',
      icon: LucideIcons.camera,
    ),
    _SocialChannel(
      title: 'یوٹیوب (YouTube)',
      handle: '@takband_qandeel',
      url: 'https://www.youtube.com/@takband_qandeel',
      icon: LucideIcons.video,
    ),
    _SocialChannel(
      title: 'کسٹ‌باکس پڈکاسٹ (CastBox)',
      handle: 'TakbandQandeel Podcast',
      url: 'https://castbox.fm/va/7074852',
      icon: LucideIcons.headphones,
    ),
  ];

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لینک کاپی بوت'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                        'سیدگنج — بلوچی لبزبلد',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'نسخہ ۱.۰.۰ • ۱۰۰٪ آفلاین',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'بلوچی ءَ پہ بلوچی سرجمیں لبزبلد کہ بید ء انٹرنیٹ ءَ کار کنت ءُ لبزانی مانا، اعراب ءُ تشریح ءَ پیش داریت۔',
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
                      data: (count) => 'کل لبز: $count',
                      loading: () => 'کل لبز: ...',
                      error: (_, __) => 'کل لبز: —',
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
                        'تکبند قندیل (TakbandQandeel)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'بلوچی زبان ءُ لبزانک ءِ دوزواہانی ٹولی',
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
            Text(
              'ما بلوچی زبان ءُ لبزانک ءِ کسانیں کارمند ءُ دوزواہانی ٹولی یے ایں کہ پہ بلوچی زبان ءِ دیمروئی، زانتکاری ءُ ڈیجیٹل مڈیانی جوڑ کنگ ءَ کار کنگ ءَ ایں۔',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),

            // Social & Podcast Links
            Text(
              'مئے تاک ءُ پڈکاسٹ',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(_channels.length, (index) {
              final channel = _channels[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == _channels.length - 1 ? 0 : 8,
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
                    'گوں مھر ءَ',
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
                    'تاکبند کندیل',
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
