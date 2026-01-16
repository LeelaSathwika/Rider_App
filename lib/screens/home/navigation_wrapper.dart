import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../rides/ProfileScreen.dart';
import '../../rides/ride_history.dart';
import 'home_screen.dart';
import 'ride_history_screen.dart';
import 'profile_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;
  String pickupAddress = "Current Location";

  @override
  Widget build(BuildContext context) {
    // List of screens for the Bottom Nav
    final List<Widget> _tabs = [
      HomeScreen(
        address: pickupAddress,
        onUpdate: (newAddr) => setState(() => pickupAddress = newAddr),
      ),
      const Center(child: Text("Services Screen")),
      const RideHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
<<<<<<< HEAD
        index: _currentIndex,
        children: _tabs,
=======
        index: _index,
        children: [
          HomeScreen(address: pickupAddress, onUpdate: (v) => setState(() => pickupAddress = v)),
          const Center(child: Text("Services Screen")),
          // const Center(child: Text("History Screen")),
          RideHistoryScreen(),
          // const Center(child: Text("Profile Screen")),
          ProfileScreen(),
        ],
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_filled), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}