import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/widgets/profile_menu.dart'; 
import 'package:project_mobile/core/theme/colors.dart'; 
import 'package:project_mobile/providers/navbar_provider.dart'; 
import 'package:provider/provider.dart'; 

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {

    final User? currentUser = FirebaseAuth.instance.currentUser;

    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);

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
        // Tombol kembali
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {navBarProvider.setIndex(0);},
        ),
        title: Text("Profile",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textDark)), 
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Terjadi kesalahan",
                    style: TextStyle(color: AppColors.textDark))); 
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildProfileUI(context, "Nama...", "email...",
                "https://via.placeholder.com/150", AppColors.textDark);
          }
          
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          String username = userData['username'] ?? 'Nama Pengguna';
          String email = userData['email'] ?? 'email@example.com';
          String photoUrl =
              userData['photoUrl'] ?? 'https://via.placeholder.com/150';

          return _buildProfileUI(
              context, username, email, photoUrl, AppColors.textDark);
        },
      ),
    );
  }

  Widget _buildProfileUI(BuildContext context, String username, String email,
      String photoUrl, Color textColor) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // FOTO PROFIL
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      // Error builder jika URL gambar gagal dimuat
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.person,
                            color: Colors.white, size: 90),
                      ),
                    ),
                  ),
                ),
                // TOMBOL EDIT
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.primary, 
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 20,
                    ),
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
                    ?.copyWith(color: textColor)), 
            Text(email,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[500])),

            const SizedBox(height: 20),

            // EDIT PROFILE
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman Edit Profile
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text("Edit Profile",
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),

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
              onPress: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}