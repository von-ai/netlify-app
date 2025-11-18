import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';

class CardList extends StatelessWidget {
  final String title;
  final String? genre;
  final String? date;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CardList({
    super.key,
    required this.title,
    this.genre,
    this.date,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.movie_creation,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _buildSubtitle(),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol delete
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Buat subtitle "genre • date" yang aman
  String _buildSubtitle() {
    if ((genre == null || genre!.isEmpty) && (date == null || date!.isEmpty)) {
      return "-";
    }

    if (genre == null || genre!.isEmpty) return date!;
    if (date == null || date!.isEmpty) return genre!;

    return "$genre • $date";
  }
}
