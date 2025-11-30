import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/widgets/profile_menu.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/providers/navbar_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/widgets/logout.dart';
// Pastikan nama file ini sesuai dengan file Edit Profile yang kita buat tadi
import 'package:project_mobile/pages/edit_profil.dart'; 

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);

    // Cek Login
    if (currentUser == null) {
      return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
              child: Text("Tidak ada pengguna, silakan login.",
                  style: TextStyle(color: AppColors.textDark))));
    }

    final Stream<DocumentSnapshot> userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            navBarProvider.setIndex(0);
          },
        ),
        title: Text("Profile",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Terjadi kesalahan saat memuat data.",
                    style: TextStyle(color: AppColors.textDark)));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildProfileUI(context, "Nama...", "email...", null, AppColors.textDark);
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          String username = userData['username'] ?? 'Nama Pengguna';
          String email = userData['email'] ?? 'email@example.com';
          
          // UBAHAN 1: Biarkan null jika tidak ada foto (jangan pakai placeholder link)
          String? photoUrl = userData['photoUrl']; 

          return _buildProfileUI(
              context, username, email, photoUrl, AppColors.textDark);
        },
      ),
    );
  }

  Widget _buildImage(String data) {
  try {
    // Coba decode sebagai Base64
    return Image.memory(
      base64Decode(data),
      fit: BoxFit.cover,
    );
  } catch (e) {
    // Kalau gagal (siapa tau data lama masih URL http), coba load network
    return Image.network(
      data,
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => const Icon(Icons.person, color: Colors.white),
    );
  }
}

  Widget _buildProfileUI(BuildContext context, String username, String email,
      String? photoUrl, Color textColor) { // UBAHAN 2: Terima String nullable (?)
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- FOTO PROFIL ---
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: (photoUrl != null && photoUrl.isNotEmpty)
                        ? _buildImage(photoUrl) // Buat fungsi helper biar rapi
                        : const Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                ),
                
                // --- TOMBOL EDIT ICON (Hijau) ---
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),

            // NAMA & EMAIL
            Text(username,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: textColor, fontWeight: FontWeight.bold)),
            Text(email,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[500])),

            const SizedBox(height: 20),

            // TOMBOL EDIT PROFILE
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Edit Profile",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),

            // MENU ITEMS
            ProfileMenuWidget(
              title: "Settings",
              icon: Icons.settings,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "User Management",
              icon: Icons.person_add,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "Information",
              icon: Icons.info,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "Logout",
              icon: Icons.logout,
              textColor: Colors.red,
              endIcon: false,
              onPress: () async {
                final navBarProvider =
                    Provider.of<NavBarProvider>(context, listen: false);
                await Logout().signOut(context);
                navBarProvider.setIndex(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}