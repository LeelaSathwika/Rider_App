import 'package:flutter/material.dart';

import 'bullet_Widget.dart';


class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _skipButton(),
          const SizedBox(height: 16),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TopIcon(icon: Icons.wifi_tethering, text: 'LIVE\nTRACKING'),
              TopIcon(icon: Icons.shield, text: 'SOS FAMILY\nSHARING'),
              TopIcon(icon: Icons.female, text: 'WOMEN ONLY\nRIDE'),
            ],
          ),

          const SizedBox(height: 20),

          Image.asset('assets/images/car.png', height: 190),

          const SizedBox(height: 20),

          const Text(
            'Safety Comes First',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 18),
          const BulletText(text: 'Women-only ride option'),
          const SizedBox(height: 10),
          const BulletText(text: 'Live tracking & ride PIN'),
          const SizedBox(height: 10),
          const BulletText(text: 'SOS & family sharing'),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF114BBE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
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




class TopIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const TopIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFF2E7D32),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }
}
