import 'package:flutter/material.dart';
import 'package:riders/screen2.dart';
import 'package:riders/screen3.dart';
import 'package:riders/screen4.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                children: const [
                  Screen2(),
                  Screen3(),
                  Screen4(),
                ],
              ),
            ),

            /// Bottom dots
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
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
