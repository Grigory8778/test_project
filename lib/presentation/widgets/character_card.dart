import 'package:flutter/material.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';
import 'package:test_project/presentation/widgets/chip_widget.dart';
import 'package:test_project/presentation/widgets/info_row.dart';

class CharacterCard extends StatelessWidget {
  final CharacterHive item;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const CharacterCard({
    super.key,
    required this.item,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 102,
                  height: 102,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    width: 82,
                    height: 82,
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (onToggleFavorite != null)
                          IconButton(
                            tooltip: isFavorite
                                ? 'Убрать из избранного'
                                : 'В избранное',
                            icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border),
                            onPressed: onToggleFavorite,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ChipWidget(label: item.status),
                        ChipWidget(label: item.species),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (item.location.isNotEmpty)
                      InfoRow(icon: Icons.place, text: item.location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
