import 'package:flutter/material.dart';
import 'package:project_mobile/pages/detail_page.dart';
import 'package:project_mobile/models/watch_item.dart';
import 'package:project_mobile/core/theme/colors.dart';

class EventCardList extends StatelessWidget {
  final List<WatchItem> items;

  const EventCardList({super.key, required this.items});

  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
      case 'anime':
        return Icons.animation;
      case 'movie':
        return Icons.movie;
      case 'series':
        return Icons.tv;
      default:
        return Icons.play_circle_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text(
        'Belum ada data',
        style: TextStyle(color: Colors.white54),
      );
    }

    final displayItems = items.length > 2
        ? items.sublist(items.length - 2)
        : items;

    return Column(
      children: displayItems.reversed.map((item) {
        final totalEp = item.episodes ?? 0;
        final currentEp = item.currentEpisode;
        final progress = (totalEp > 0) ? currentEp / totalEp : 0.0;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailPage(id: item.id!)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon / Thumbnail
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(item.type),
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Genre + Mood
                      Row(
                        children: [
                          Text(
                            item.genre,
                            style: TextStyle(
                              color: AppColors.textDark.withOpacity(0.65),
                              fontSize: 13,
                            ),
                          ),
                          if (item.mood != null && item.mood!.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            Icon(
                              Icons.circle,
                              size: 5,
                              color: AppColors.textDark.withOpacity(0.35),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.mood!,
                              style: TextStyle(
                                color: AppColors.textDark.withOpacity(0.55),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Episode Progress Bar
                      if (item.episodes != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor:
                                    AppColors.textDark.withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${item.currentEpisode}/${item.episodes} eps",
                              style: TextStyle(
                                color: AppColors.textDark.withOpacity(0.45),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}