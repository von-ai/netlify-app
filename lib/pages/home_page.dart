import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/pages/add_list_page.dart';
import 'package:project_mobile/services/home_service.dart';
// import 'package:project_mobile/widgets/card_list.dart';
import '../widgets/add_event.dart';
import '../widgets/event_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/watch_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _service = HomeService();
  void tambahAcara(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      StreamBuilder(
                        stream: _service.getUserStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text(
                              "User",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            );
                          }
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final name = data['username'] ?? 'User';
                          return Text(
                            name,
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(child: AddButton(onPressed: () => tambahAcara(context))),
              const SizedBox(height: 24),
              const Text(
                'Yuk Lanjutkan Tontonanmu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<WatchItem>>(
                stream: _service.getBaruDiupdate(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  return EventCardList(items: snapshot.data!);
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Baru Ditambahkan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<WatchItem>>(
                stream: _service.getBaruDitambahkan(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  return EventCardList(items: snapshot.data!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
