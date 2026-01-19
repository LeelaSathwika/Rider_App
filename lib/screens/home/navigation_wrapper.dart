import 'package:flutter/material.dart';
import '../../constants.dart';
import 'home_screen.dart';
import 'ride_history_screen.dart';
import 'profile_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  // Tracks the currently selected tab
  int _currentIndex = 0;

  // This variable holds the pickup address globally within the wrapper
  // so it persists if you switch between tabs.
  String pickupAddress = "Current Location";

  @override
  Widget build(BuildContext context) {
    // Define the list of screens for each tab
    final List<Widget> _tabs = [
      // Index 0: HOME
      HomeScreen(
        address: pickupAddress,
        onUpdate: (newAddr) {
          setState(() {
            pickupAddress = newAddr;
          });
        },
      ),

      // Index 1: SERVICES (Placeholder for now)
      const Center(
        child: Text(
          "Services Screen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),

      // Index 2: HISTORY
      const RideHistoryScreen(),

      // Index 3: PROFILE
      const ProfileScreen(),
    ];

    return Scaffold(
      // IndexedStack is used to keep the state of each tab alive.
      // This means if you move the map and switch to Profile, 
      // the map stays where you left it when you come back.
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),

      // THE BOTTOM NAVIGATION BAR
      // This bar is only part of the NavigationWrapper. 
      // Screens pushed from within the tabs will hide this bar.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Use fixed for 4 items
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        // Exact icons based on common ride-hailing design
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}