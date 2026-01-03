import 'package:flutter/material.dart';


import '../files/WelcomeScreen.dart';
import 'bullet_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [

            /// 🔹 Skip Button (Top Right)
            Positioned(
              top: 8,
              right: 16,
              child: _skipButton(),
            ),

            /// 🔹 Positioned Image (EXACT Figma style)
          Positioned(
            top: 65,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: 1.4,
              child: Image.asset(
                'assets/images/saftycomes.png',
                width: 434,
                fit: BoxFit.contain,
              ),
            ),
          ),


            /// 🔹 Main Content (Text + Button)
            Column(
              children: [

                // Reserve space for image
                const SizedBox(height: 380),

                /// Text + Bullets
                SizedBox(
                  width: 342,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Center(
                        child: Text(
                          'Safety Comes First',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      BulletText(text: 'Women-only ride option'),
                      SizedBox(height: 12),
                      BulletText(text: 'Live tracking & ride PIN'),
                      SizedBox(height: 12),
                      BulletText(text: 'SOS & family sharing'),
                    ],
                  ),
                ),

                const Spacer(),

                /// Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => mobilenumber(), // change screen
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E4FB8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Skip Button (Exact pill style)
  Widget _skipButton() {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: const Center(
        child: Text(
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

