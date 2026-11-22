import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../domain/discovery_category.dart';
import '../../discovery_collection_screen.dart';
import 'discovery_category_card.dart';

class EditorialDiscoveryGrid extends StatelessWidget {
  const EditorialDiscoveryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.compass, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'گچین کتگیں گال',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: DiscoveryCategory.values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 124,
          ),
          itemBuilder: (context, index) {
            final category = DiscoveryCategory.values[index];
            return DiscoveryCategoryCard(
              category: category,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        DiscoveryCollectionScreen(category: category),
                  ),
                );
              },
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.03, end: 0);
  }
}
