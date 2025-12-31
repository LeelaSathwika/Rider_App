import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'bullet_Widget.dart';


class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _skipButton(),
          const SizedBox(height: 20),

          Center(
            child: Image.asset(
              'assets/images/screen2.png',
              height: 260,
            ),
          ),

          const SizedBox(height: 40),

          const Center(
            child: Text(
              'Smart rides. one app.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 24),
          const BulletText(text: 'Personal rides, anytime'),
          const SizedBox(height: 12),
          const BulletText(text: 'Easy office commutes'),
          const SizedBox(height: 12),
          const BulletText(text: 'Shared & scheduled trips'),
        ],
      ),
    );
  }

  Widget _skipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Skip', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
