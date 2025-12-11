import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/providers/navbar_provider.dart';
import 'package:project_mobile/pages/home_page.dart';
import 'package:project_mobile/pages/daftar_page.dart';
import 'package:project_mobile/pages/profil_page.dart';
import 'package:project_mobile/core/theme/colors.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context);

    final List<Widget> pages = [
      const HomePage(),
      const DaftarPage(),
      const ProfilPage(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: pages[navBarProvider.selectedIndex],
        bottomNavigationBar: Container(
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: GNav(
              backgroundColor: AppColors.background,
              color: AppColors.textDark,
              activeColor: AppColors.textDark,
              tabBackgroundColor: AppColors.primary,
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(icon: LineIcons.home, text: 'Home'),
                GButton(icon: LineIcons.list, text: 'List'),
                GButton(icon: LineIcons.user, text: 'Profile'),
              ],
              selectedIndex: navBarProvider.selectedIndex,
              onTabChange: (value) {
                navBarProvider.setIndex(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
