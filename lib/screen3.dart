
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bullet_Widget.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

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
              'assets/images/screen3.png',
              height: 260,
            ),
          ),

          const SizedBox(height: 40),

          const Center(
            child: Text(
              'Office Trips, All Set',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 24),
          const BulletText(text: 'Auto pickup for login rides'),
          const SizedBox(height: 12),
          const BulletText(text: 'Easy request for logout rides'),
          const SizedBox(height: 12),
          const BulletText(text: 'Company-managed billing'),
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

