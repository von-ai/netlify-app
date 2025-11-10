import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';

class CardList extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback? onTap;

  const CardList({super.key, required this.title, this.date = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
