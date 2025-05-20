import 'package:flutter/material.dart';
import 'mood_tracker.dart';
import 'journal_screen.dart';
import 'insights_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    MoodTrackerScreen(),
    JournalScreen(),
    InsightsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: 'Insights',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.sageGreen,
          unselectedItemColor: AppTheme.textSecondary,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
} 