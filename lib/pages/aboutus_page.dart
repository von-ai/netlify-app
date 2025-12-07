import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final List<Map<String, String>> creators = [
      {
        'name': 'William Anthony Rustan',
        'nim': 'NIM: D121231006',
        'github' : 'https://github.com/Chutannn',
        'image': 'assets/images/will.jpeg', 
      },
      {
        'name': 'Admiral Zuhdi',
        'nim': 'NIM: D121231021',
        'github' : 'https://github.com/von-ai',
        'image': 'assets/images/zuhdi.jpg',
      },
      {
        'name': 'Muh. Aidil Iskandar',
        'nim': 'NIM: D121221094',
        'github' : 'https://github.com/maidili',
        'image': 'assets/images/kakAidil.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "About Us",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, color: Colors.white);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Netlify",
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Version 1.0.0",
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '"Aplikasi ini dibuat untuk membantu pengguna mengatur jadwal tontonan film favorit mereka dengan mudah dan efisien."',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 40),
            const Divider(color: Colors.white10),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Meet Our Team",
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            ...creators.map((creator) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          creator['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 40, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            creator['name']!,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            creator['nim']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (creator['github'] != null && creator['github']!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _launchURL(creator['github']!),
                              child: Row(
                                children: [
                                  const Icon(Icons.link, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Kunjungi GitHub",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 40),
            Text(
              "© 2025 Project Mobile",
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}