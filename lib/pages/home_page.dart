import 'package:flutter/material.dart';
import '../widgets/add_event.dart';
import '../widgets/event_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Contoh data dummy untuk list
  List<String> akanDitonton = ["Naruto", "One Piece", "Attack on Titan"];
  List<String> baruDitambahkan = [];

  // Fungsi tombol "Tambah Acara"
  void tambahAcara() {
    setState(() {
      baruDitambahkan.add("Film Baru ${baruDitambahkan.length + 1}");
    });
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
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'User!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Tombol tambah acara
              Center(child: AddButton(onPressed: tambahAcara)),

              const SizedBox(height: 24),

              // Bagian Akan Ditonton
              const Text(
                'Akan Ditonton',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              EventCardList(items: akanDitonton),

              const SizedBox(height: 24),

              // Bagian Baru Ditambahkan
              const Text(
                'Baru Ditambahkan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              EventCardList(items: baruDitambahkan),
            ],
          ),
        ),
      ),
    );
  }
}
