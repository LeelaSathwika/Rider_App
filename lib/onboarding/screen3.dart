
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bullet_Widget.dart';


class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button
            Positioned(
              top: 12,
              right: 24,

              child: _skipButton(),
            ),

            // Main content
            Positioned(
              top: 35,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Image (exact Figma size & overflow)
                  SizedBox(
                    width: 434,
                    height: 434,
                    child: Image.asset(
                      'assets/images/smartride.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content container (342px width)
                  SizedBox(
                    width: 342,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Center(
                          child: Text(
                            'Office Trips, All Set',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        BulletText(text: '  Auto pickup for login rides'),
                        SizedBox(height: 12),
                        BulletText(text: ' Easy request for logout rides'),
                        SizedBox(height: 12),
                        BulletText(text: ' Company-managed billing'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skipButton() {
    return SizedBox(
      height: 28,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          side: const BorderSide(color: Colors.black, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}


