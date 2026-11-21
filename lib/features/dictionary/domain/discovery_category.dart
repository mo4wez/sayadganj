import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum DiscoveryCategory {
  richDefinitions(
    title: 'دراجیں تشریح',
    subtitle: 'سرجم ءُ پُرمانائیں لبز',
    icon: LucideIcons.scrollText,
    supportsRefresh: false,
  ),
  vocalizedWords(
    title: 'گوں اعراب ءَ',
    subtitle: 'زبر، زیر ءُ پیش ءِ همراه ءَ',
    icon: LucideIcons.sparkles,
    supportsRefresh: true,
  ),
  proverbsAndSources(
    title: 'بَتَل ءُ بُنزہ',
    subtitle: 'ادبی گْونڈگال ءُ ٹِک',
    icon: LucideIcons.feather,
    supportsRefresh: false,
  ),
  pastWeekWords(
    title: 'گوستگیں ھپتگ',
    subtitle: '۷ روچ ءِ گچین کتگیں لبز',
    icon: LucideIcons.calendarDays,
    supportsRefresh: false,
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final bool supportsRefresh;

  const DiscoveryCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.supportsRefresh,
  });
}
