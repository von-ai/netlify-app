import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/pages/aboutus_page.dart';
import 'package:project_mobile/widgets/profile_menu.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/providers/navbar_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/widgets/logout.dart';
import 'package:project_mobile/pages/edit_profil.dart';
import 'package:project_mobile/pages/settings_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    if (currentUser == null) {
      return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
              child: Text("Tidak ada pengguna, silakan login.",
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textDark,
                  ))));
    }

    final Stream<DocumentSnapshot> userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            navBarProvider.setIndex(0);
          },
        ),
        title: Text(
          "Profile",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Terjadi kesalahan saat memuat data.",
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textDark,
                    )));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildProfileUI(
                context, "Nama...", "email...", null, AppColors.textDark);
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          String username = userData['username'] ?? 'Nama Pengguna';
          String email = userData['email'] ?? 'email@example.com';
          String? photoUrl = userData['photoUrl'];

          return _buildProfileUI(
              context, username, email, photoUrl, AppColors.textDark);
        },
      ),
    );
  }

  Widget _buildImage(String data) {
    try {
      return Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Image.network(
        data,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) =>
            const Icon(Icons.person, color: Colors.white),
      );
    }
  }

  Widget _buildProfileUI(BuildContext context, String username, String email,
      String? photoUrl, Color textColor) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
                        ? _buildImage(photoUrl)
                        : const Icon(Icons.person,
                            size: 80, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(username,
                style: textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontSize: 22,
                )),
            Text(email,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 14,
                )),

            const SizedBox(height: 20),

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
                child: Text("Edit Profile",
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),

            ProfileMenuWidget(
              title: "Settings",
              icon: Icons.settings,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ProfileMenuWidget(
              title: "About Us",
              icon: Icons.person,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            ProfileMenuWidget(
              title: "FAQ",
              icon: Icons.info,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "Logout",
              icon: Icons.logout,
              textColor: Colors.red,
              iconColor: Colors.red,
              endIcon: false,
              onPress: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showLogoutDialog(BuildContext context) async {
  final textTheme = Theme.of(context).textTheme;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(
          'Konfirmasi Logout',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Batal',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Ya, Keluar',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final navBarProvider =
                  Provider.of<NavBarProvider>(context, listen: false);
              await Logout().signOut(context);
              navBarProvider.setIndex(0);
            },
          ),
        ],
      );
    },
  );
}