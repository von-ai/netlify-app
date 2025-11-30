import 'package:flutter/material.dart';
import '../core/theme/colors.dart';

class DetailInfo extends StatelessWidget {
  final String genre;
  final String date;
  final bool isWatched;
  final int? episodes;

  const DetailInfo({
    super.key,
    required this.genre,
    required this.date,
    required this.isWatched,
    this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Genre", genre),
          const SizedBox(height: 12),
          _infoRow("Tanggal Rilis", date),
          const SizedBox(height: 12),
          _infoRow(
            "Status",
            isWatched ? "Sudah Ditonton" : "Belum Ditonton",
            highlight: isWatched,
          ),
          if (episodes != null) ...[
            const SizedBox(height: 12),
            _infoRow("Total Episode", "$episodes"),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primary : AppColors.textDark,
            fontSize: 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
