import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:project_mobile/pages/editdata_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotifEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    bool allowed = await AwesomeNotifications().isNotificationAllowed();
    setState(() {
      _isNotifEnabled = allowed;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    if (value) {
      bool allowed = await NotificationService().requestPermission();
      setState(() => _isNotifEnabled = allowed);
    } else {
      await AwesomeNotifications().showNotificationConfigPage();
      _checkPermissionStatus();
    }
  }

  Future<void> _deleteUserSchedules() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('watchlist');

      final snapshots = await collection.get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua jadwal berhasil dihapus.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus: $e")),
      );
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          "Hapus Semua Jadwal?",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        content: Text(
          "Tindakan ini akan menghapus seluruh daftar tontonan yang sudah kamu buat. Data tidak bisa dikembalikan.",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUserSchedules();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader("Akun"),
          _settingItem(
            icon: Icons.manage_accounts,
            color: AppColors.primary,
            title: "Ubah Data Akun",
            subtitle: "Ganti Email & Password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditDataPage()),
              );
            },
          ),

          const SizedBox(height: 24),

          _sectionHeader("Notifikasi"),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              activeColor: AppColors.primary,
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active,
                    color: AppColors.primary, size: 22),
              ),
              title: Text(
                "Izinkan Notifikasi",
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "Terima jadwal & update",
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              value: _isNotifEnabled,
              onChanged: _toggleNotification,
            ),
          ),

          const SizedBox(height: 24),

          _sectionHeader("Data User"),
          _settingItem(
            icon: Icons.delete_forever,
            color: Colors.red,
            title: "Hapus Semua Jadwal",
            subtitle: "Kosongkan daftar tontonan saya",
            onTap: _showDeleteConfirmation,
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 13,
            ),
      ),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}