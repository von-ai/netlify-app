import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final List<Map<String, String>> faqs = [
      {
        "question": "Apa fungsi aplikasi ini?",
        "answer": "Aplikasi ini membantu Anda mencatat, menjadwalkan, dan mengingat film atau serial anime yang ingin Anda tonton agar tidak terlewat."
      },
      {
        "question": "Bagaimana cara menambahkan jadwal?",
        "answer": "Tekan tombol '+ Tambah Acara' di halaman utama (Home), isi judul, deskripsi, tanggal, dan waktu tonton, lalu simpan."
      },
      {
        "question": "Apakah aplikasi ini butuh internet?",
        "answer": "Ya, aplikasi ini memerlukan koneksi internet untuk menyimpan data ke server dan melakukan sinkronisasi akun."
      },
      {
        "question": "Bagaimana cara menghapus jadwal?",
        "answer": "Anda bisa menghapus jadwal satu per satu di detail acara, atau menghapus semua sekaligus melalui menu Pengaturan > Hapus Semua Jadwal."
      },
      {
        "question": "Mengapa notifikasi tidak muncul?",
        "answer": "Pastikan Anda telah memberikan izin notifikasi di pengaturan HP Anda dan tombol 'Izinkan Notifikasi' di menu Pengaturan aplikasi sudah aktif. Untuk beberapa Hp perlu juga mematikan fitur Power Saving."
      },
      {
        "question": "Bagaimana cara mengganti foto profil?",
        "answer": "Masuk ke menu Profil, tekan tombol 'Edit Profile', lalu tekan ikon kamera untuk memilih foto baru dari galeri Anda."
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "FAQ",
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Pertanyaan Umum",
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Cari solusi untuk masalahmu di sini",
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          ...faqs.map((faq) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent, 
                ),
                child: ExpansionTile(
                  iconColor: AppColors.primary,
                  collapsedIconColor: Colors.grey,
                  title: Text(
                    faq['question']!,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['answer']!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent, color: AppColors.primary, size: 40),
                const SizedBox(height: 12),
                Text(
                  "Masih butuh bantuan?",
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Hubungi tim support kami jika masalah berlanjut.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}