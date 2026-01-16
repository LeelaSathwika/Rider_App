import 'dart:async';
import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../onboarding/onboarding_screen.dart';

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
<<<<<<< HEAD
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
=======
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4688F2),
      body: Center(
        child: Container(
          width: 393,
          height: 851,
          // --- THE FIX IS THESE TWO LINES ---
          decoration: const BoxDecoration(), 
          clipBehavior: Clip.antiAlias, 
          // ----------------------------------
          child: Stack(
            children: [
              // 1. THE BLUR OVERLAY LAYER
              Positioned(
                top: 20,
                left: 0,
                child: Container(
                  width: 393,
                  height: 517,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E4FB8).withOpacity(0.1),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

              // 2. THE LOGO
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                    children: const [
                      TextSpan(
                        text: 'NEXO',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: 'RYD',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
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