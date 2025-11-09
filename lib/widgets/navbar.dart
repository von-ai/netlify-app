import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../pages/daftar_page.dart';
import '../pages/home_page.dart';
import '../pages/profil_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}
class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  List _pages = [
    const HomePage(),
    const DaftarPage(),
    const ProfilPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
              });
           },
          ),
        ),
      ),
    );
  }
}