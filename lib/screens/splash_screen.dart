import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Center(
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 42, letterSpacing: 2.0, color: Colors.white, fontFamily: 'serif'),
            children: [
              TextSpan(text: 'NEXO', style: TextStyle(fontWeight: FontWeight.w300)),
              TextSpan(text: 'RYD', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}