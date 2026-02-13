import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foxusify/features/league/screens/profile_screen/profile_screen.dart';
import 'package:foxusify/features/pomodoro/controller/timer_controller.dart';
import '../../../../widgets/rounded_navbar.dart';
import 'pomodoro_screen.dart'; // Assuming this exists or will be created/fixed

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  // Temporary list of pages until we fully implement them
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const PomodoroScreen(), // This is the timer screen
      const Center(child: Text("League Screen")), // Placeholder
      const ProfileScreen(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
