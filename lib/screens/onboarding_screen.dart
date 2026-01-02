import 'package:flutter/material.dart';
import '../constants.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Smart rides. one app.",
      "features": ["Personal rides, anytime", "Easy office commutes", "Shared & scheduled trips"]
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Office Trips, All Set",
      "features": ["Auto pickup for login rides", "Easy request for logout rides", "Company-managed billing"]
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Safety Comes First",
      "features": ["Women-only ride option", "Live tracking & ride PIN", "SOS & family sharing"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                  style: OutlinedButton.styleFrom(shape: const StadiumBorder(), side: const BorderSide(color: Colors.black12)),
                  child: const Text("Skip", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (v) => setState(() => _currentPage = v),
                itemCount: _pages.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset(_pages[i]['image'], height: 220, errorBuilder: (c, e, s) => const Icon(Icons.image, size: 100, color: Colors.grey))),
                      const SizedBox(height: 40),
                      Text(_pages[i]['title'], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      ...(_pages[i]['features'] as List<String>).map((f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [const Icon(Icons.check, color: AppColors.primaryBlue), const SizedBox(width: 10), Text(f, style: const TextStyle(fontSize: 17))]),
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Container(
                margin: const EdgeInsets.only(right: 5),
                height: 8, width: _currentPage == i ? 24 : 8,
                decoration: BoxDecoration(color: _currentPage == i ? AppColors.primaryBlue : Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(_currentPage == 2 ? "Get Started" : "Next", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}