import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class _SocialItem {
  final String label;
  final String subtitle;
  final String url;
  final IconData icon;

  const _SocialItem({
    required this.label,
    required this.subtitle,
    required this.url,
    required this.icon,
  });
}

class TakbandFollowSheet extends StatelessWidget {
  final VoidCallback onDismissLater;
  final VoidCallback onDontShowAgain;

  const TakbandFollowSheet({
    super.key,
    required this.onDismissLater,
    required this.onDontShowAgain,
  });

  static const List<_SocialItem> _items = [
    _SocialItem(
      label: 'تیلیگرام',
      subtitle: 'Telegram',
      url: 'https://t.me/takband_qandeel',
      icon: LucideIcons.send,
    ),
    _SocialItem(
      label: 'انسٹاگرام',
      subtitle: 'Instagram',
      url: 'https://www.instagram.com/takband.qandeel',
      icon: LucideIcons.camera,
    ),
    _SocialItem(
      label: 'یوٹیوب',
      subtitle: 'YouTube',
      url: 'https://www.youtube.com/@takband_qandeel',
      icon: LucideIcons.video,
    ),
    _SocialItem(
      label: 'کسٹ‌باکس',
      subtitle: 'CastBox',
      url: 'https://castbox.fm/va/7074852',
      icon: LucideIcons.headphones,
    ),
  ];

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onDismissLater,
    required VoidCallback onDontShowAgain,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return TakbandFollowSheet(
          onDismissLater: () {
            Navigator.of(sheetCtx).pop();
            onDismissLater();
          },
          onDontShowAgain: () {
            Navigator.of(sheetCtx).pop();
            onDontShowAgain();
          },
        );
      },
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    HapticFeedback.selectionClick();
    final uri = Uri.parse(url);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لینک کاپی بوت'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    onDontShowAgain();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Soft drag handle
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 18),

          // Gentle feather emblem
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.feather,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'تکبند قندیل ءِ همراه بہ بئے',
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'اگاں سیدگنج پہ تو کارآمد بوتگ، مئے کسانیں لبزانکی ٹولی ءِ تاک ءُ پڈکاسٹاں هم بچار دانکہ بلوچی زبان ءِ نوکیں کاراں سرپد بہ بئے.',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.65),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // Compact 2x2 Social Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.55,
            ),
            itemBuilder: (context, index) {
              final item = _items[index];
              return Material(
                color: theme.scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: colorScheme.outline),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _openUrl(context, item.url),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(
                            item.icon,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 13.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.subtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Zero-guilt dismiss actions
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onDontShowAgain,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('دگہ پیش مدار'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: onDismissLater,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('پدا بچاراں'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
