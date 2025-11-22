import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  final String title;
  final String type;

  const DetailHeader({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(type, style: const TextStyle(fontSize: 18, color: Colors.grey)),
      ],
    );
  }
}
