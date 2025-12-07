import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/pages/add_list_page.dart';
import 'package:project_mobile/services/home_service.dart';
import 'package:project_mobile/widgets/add_event.dart';
import 'package:project_mobile/widgets/event_list.dart';
import 'package:project_mobile/models/watch_item.dart';
import 'package:project_mobile/services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _service = HomeService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init(); 
    _notificationService.scheduleInactivityReminder();
  }

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
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: _service.getUserStream(),
                builder: (context, snapshot) {
                  String username = "User";
                  String? photoUrl; 

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    username = data['username'] ?? "User";
                    photoUrl = data['photoUrl'];
                  }

                  ImageProvider? imageProvider;
                  if (photoUrl != null && photoUrl.isNotEmpty) {
                    try {
                      imageProvider = MemoryImage(base64Decode(photoUrl));
                    } catch (e) {
                      debugPrint("Error decoding image: $e");
                    }
                  }

                  return Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                          image: imageProvider != null
                              ? DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageProvider == null
                            ? const Icon(Icons.person, color: Colors.white, size: 30)
                            : null,
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
                          Text(
                            username,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
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