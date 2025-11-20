import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/pages/add_list_page.dart';
import '../widgets/add_event.dart';
import '../widgets/event_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> akanDitonton = ["Naruto", "One Piece", "Attack on Titan"];
  List<String> baruDitambahkan = [];

  void tambahAcara(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
                      Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .snapshots(),

                        builder: (context, snapshot) {
                          String username = 'User';

                          if (snapshot.hasData && snapshot.data!.exists) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            username = data['username'] ?? 'User';
                          }
                          return Text(
                            username,
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
