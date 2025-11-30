import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final Stream userStream;

  const HomeHeader({super.key, required this.userStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        final username = snapshot.hasData
            ? snapshot.data['username'] ?? 'User'
            : 'User';

        return Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selamat Datang,",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
