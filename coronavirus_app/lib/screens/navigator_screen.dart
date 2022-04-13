import 'package:coronavirus_app/screens/front_screen.dart';
import 'package:coronavirus_app/screens/home_scrren.dart';
import 'package:coronavirus_app/screens/hospitals.dart';
import 'package:flutter/material.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    FrontScreen(),
    HomePage(),
    HospitalsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Hospitals',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(249, 80, 71, 181),
        onTap: _onItemTapped,
      ),
      body: _screens[_selectedIndex],
    );
  }
}
