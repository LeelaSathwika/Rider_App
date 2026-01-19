import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart'; // Ensure ExactBlueTick is defined here
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data mapping based on your exact image positioning and properties
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Smart rides. one app.",
      "image": "assets/images/onboarding1.png",
      "w": 434.0, "h": 434.0, "t": 35.0, "l": -23.0,
      "features": ["Personal rides, anytime", "Easy office commutes", "Shared & scheduled trips"]
    },
    {
      "title": "Office Trips, All Set",
      "image": null, // Page 2: Clean White Space as requested
      "features": ["Auto pickup for login rides", "Easy request for logout rides", "Company-managed billing"]
    },
    {
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
          // CSS: width: 393; height: 851;
          width: 393,
          height: 851,
          decoration: const BoxDecoration(color: Colors.white),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 1. SWIPEABLE CONTENT AREA
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Stack(
                    children: [
                      // Vector Illustration (Page 1 & 3)
                      if (data['image'] != null)
                        Positioned(
                          top: data['t'],
                          left: data['l'],
                          child: Image.asset(
                            data['image'],
                            width: data['w'],
                            height: data['h'],
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(),
                          ),
                        ),

                      // Text block - Exact position top: 435px; left: 25px;
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
                            const SizedBox(height: 25), // Spacing between title and list
                            ...((data['features'] as List<String>).map((f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      const ExactBlueTick(size: 18), // Custom Sharp Tick from shared_widgets
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

              // 2. SKIP BUTTON - Fixed at top: 74px; left: 319px;
              Positioned(
                top: 74,
                left: 319,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (c) => const LoginScreen()),
                  ),
                  child: Container(
                    width: 44,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              // 3. INDICATOR DOTS - Positioned at top: 745px (Calculated to be below text)
              Positioned(
                top: 745, 
                left: 175,
                child: SizedBox(
                  width: 44,
                  height: 9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      bool isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 20 : 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryBlue : const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // 4. GET STARTED BUTTON - Fixed at bottom area top: 785px
              // ONLY visible on the 3rd screen
              if (_currentPage == 2)
                Positioned(
                  top: 785,
                  left: 16,
                  child: SizedBox(
                    width: 361,
                    height: 52,
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