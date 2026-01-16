import 'package:flutter/material.dart';
import '../constants.dart';
<<<<<<< HEAD:lib/screens/onboarding_screen.dart
import '../widgets/shared_widgets.dart'; // Ensure ExactBlueTick is defined here
import 'login_screen.dart';
=======
import '../screens/login_screen.dart';
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019:lib/onboarding/onboarding_screen.dart

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data and Image positioning
  final List<Map<String, dynamic>> _pages = [
    {
<<<<<<< HEAD:lib/screens/onboarding_screen.dart
=======
      "image": "assets/images/smartride.png",
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019:lib/onboarding/onboarding_screen.dart
      "title": "Smart rides. one app.",
      "image": "assets/images/onboarding1.png",
      "w": 434.0, "h": 434.0, "t": 35.0, "l": -23.0,
      "features": ["Personal rides, anytime", "Easy office commutes", "Shared & scheduled trips"]
    },
    {
<<<<<<< HEAD:lib/screens/onboarding_screen.dart
=======
      "image": "assets/images/smartride.png",
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019:lib/onboarding/onboarding_screen.dart
      "title": "Office Trips, All Set",
      "image": null, // Page 2: White space
      "features": ["Auto pickup for login rides", "Easy request for logout rides", "Company-managed billing"]
    },
    {
<<<<<<< HEAD:lib/screens/onboarding_screen.dart
=======
      "image": "assets/images/saftycomes.png",
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019:lib/onboarding/onboarding_screen.dart
      "title": "Safety Comes First",
      "image": "assets/images/onboarding3.png",
      "w": 732.0, "h": 409.0, "t": 51.0, "l": -165.0,
      "features": ["Women-only ride option", "Live tracking & ride PIN", "SOS & family sharing"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 393,
          height: MediaQuery.of(context).size.height, // Use full screen height
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              // 1. THE SWIPEABLE CONTENT
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Stack(
                    children: [
                      // Image (Top area)
                      if (data['image'] != null)
                        Positioned(
                          top: data['imgT'] ?? data['t'],
                          left: data['imgL'] ?? data['l'],
                          child: Image.asset(
                            data['image'],
                            width: data['w'],
                            height: data['h'],
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(),
                          ),
                        ),

                      // Text Content (Fixed at top 435px to match your design)
                      Positioned(
                        top: 435,
                        left: 25,
                        width: 342,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'],
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 25),
                            ...((data['features'] as List<String>).map((f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      const ExactBlueTick(size: 18), // Custom Sharp Tick
                                      const SizedBox(width: 15),
                                      Text(
                                        f,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // 2. SKIP BUTTON (Top Right)
              Positioned(
                top: 60,
                right: 25,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Text("Skip", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              // 3. INDICATOR DOTS (Fixed to the BOTTOM of the screen)
              Positioned(
                bottom: 100, // Anchored to bottom so it never disappears
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    bool isSelected = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSelected ? 22 : 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
              ),

              // 4. GET STARTED BUTTON (Visible ONLY on page 3)
              // Anchored to bottom: 30px
              if (_currentPage == 2)
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (c) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}