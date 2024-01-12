import 'package:carbozzo/pages/main_pages/community_page.dart';
import 'package:carbozzo/pages/main_pages/home_page.dart';
import 'package:carbozzo/pages/main_pages/ideas_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // ignore: non_constant_identifier_names
  List Screens = [
    const IdeasPage(),
    HomePage(),
    const CommunityPage(),
  ];
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.red,
        color: Colors.black,
        items: const [
          Icon(
            Icons.lightbulb,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.home_filled,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.group,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Screens[_selectedIndex],
    );
  }
}
