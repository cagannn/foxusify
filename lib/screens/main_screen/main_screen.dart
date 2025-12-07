import 'package:flutter/material.dart';
import 'package:foxusify/screens/profile_screen/profile_screen.dart';
import '../../widgets/rounded_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _SimplePage(title: 'Home Page'), // 0: Home
    const _SimplePage(title: 'Placement Page'), // 1: Placement
    ProfileScreen(), // 2: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),

      // 🔹 Alt bardaki index’e göre sayfa değişiyor
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: RoundedNavBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}

class _SimplePage extends StatelessWidget {
  final String title;

  const _SimplePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 26)));
  }
}
