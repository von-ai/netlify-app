import 'package:flutter/material.dart';

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
    required this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Genre", genre),
            _row("Tanggal", date),
            _row("Status", isWatched ? "Sudah ditonton" : "Belum"),
            if (episodes != null) _row("Episodes", episodes.toString()),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
