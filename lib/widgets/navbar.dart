import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../providers/navbar_provider.dart';
import '../pages/home_page.dart';
import '../pages/daftar_page.dart';
import '../pages/profil_page.dart';

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
      backgroundColor: Colors.black,
      body: pages[navBarProvider.selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromRGBO(30, 215, 96, 100),
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
