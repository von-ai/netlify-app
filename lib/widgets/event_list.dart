import 'package:flutter/material.dart';

class EventCardList extends StatelessWidget {
  final List<String> items;

  const EventCardList({super.key, required this.items});

  @override
Widget build(BuildContext context) {
  if (items.isEmpty) {
    return const Text(
      'Belum ada data',
      style: TextStyle(color: Colors.white),
    );
  }

  // Ambil maksimal 2 item terakhir
  final displayItems = items.length > 2
      ? items.sublist(items.length - 2)
      : items;

  return Column(
    children: displayItems.reversed.toList()
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        )
        .toList(),
    );
  }
}