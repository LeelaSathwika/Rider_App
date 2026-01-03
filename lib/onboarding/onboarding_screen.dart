import 'package:flutter/material.dart';
import 'package:riders/onboarding/screen2.dart';
import 'package:riders/onboarding/screen3.dart';
import 'package:riders/onboarding/screen4.dart';

import '../files/SideNavigationDrawer.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 14 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF114BBE) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool active = currentIndex == index;

    return GestureDetector(
      onTap: () {
        _controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: active ? const Color(0xFF114BBE) : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? const Color(0xFF114BBE) : Colors.grey,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// 🔹 DRAWER OPENS FROM MENU ICON
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.82,
        child: const SafeArea(
          child: ProfileDrawerScreen(), // 👈 PROFILE UI HERE
        ),
      ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 TOP BAR WITH MENU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: const Icon(Icons.menu, size: 26),
                  ),
                  const SizedBox(width: 16),

                ],
              ),
            ),

            /// PAGES
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                children: [

                   Screen2(),
                   Screen3(),
                   Screen4(),
                   // EmergencySosScreen(),
                   // WalletScreen(),
                   // RideHistoryScreen(),
                   // CompletePaymentScreen(),
                   // mobilenumber(),
                   // RideBookingScreen(),
                   // PickupLocationScreen(),
                  // profilescreen(),
                ],
              ),
            ),

            /// ONBOARDING DOTS
            if (currentIndex <= 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(currentIndex == 0),
                    _dot(currentIndex == 1),
                    _dot(currentIndex == 2),
                  ],
                ),
              ),


          ],
        ),
      ),
    );
  }
}
