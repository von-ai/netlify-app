import 'dart:convert'; // PENTING: Untuk decode foto Base64
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Pastikan import ini ada
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/pages/add_list_page.dart';
import 'package:project_mobile/services/home_service.dart';
import '../widgets/add_event.dart';
import '../widgets/event_list.dart';
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
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // --- HEADER (FOTO + NAMA) ---
              // StreamBuilder diletakkan di sini agar membungkus Foto & Nama
              StreamBuilder<DocumentSnapshot>(
                stream: _service.getUserStream(),
                builder: (context, snapshot) {
                  // 1. Siapkan Default Data (Jika Loading/Error)
                  String username = "User";
                  String? photoUrl; // Base64 string

                  // 2. Jika Data Ada, update variabel
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    username = data['username'] ?? "User";
                    photoUrl = data['photoUrl'];
                  }

                  // 3. Logic Foto Profil (Base64 Decoder)
                  ImageProvider? imageProvider;
                  if (photoUrl != null && photoUrl.isNotEmpty) {
                    try {
                      imageProvider = MemoryImage(base64Decode(photoUrl));
                    } catch (e) {
                      // Jaga-jaga jika format salah, biarkan null biar jadi icon
                      print("Error decoding image: $e");
                    }
                  }

                  return Row(
                    children: [
                      // --- LINGKARAN FOTO ---
                      Container(
                        width: 50, // Sesuaikan ukuran (radius 25 x 2)
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
                        // Jika tidak ada foto, tampilkan Icon Person
                        child: imageProvider == null
                            ? const Icon(Icons.person, color: Colors.white, size: 30)
                            : null,
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // --- TEKS SAMBUTAN & NAMA ---
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
                            style: TextStyle(
                              color: AppColors.textDark, // Warna Hijau/Primary kamu
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
              // --- AKHIR HEADER ---

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