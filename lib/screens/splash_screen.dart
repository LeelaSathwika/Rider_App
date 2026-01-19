import 'dart:async';
import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // 3 Second Timer to navigate to Onboarding
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CSS: background: #4688F2;
      backgroundColor: const Color(0xFF4688F2),
      body: Center(
        child: Container(
          // CSS: width: 393; height: 851;
          width: 393,
          height: 851,
          // decoration is mandatory when using clipBehavior to avoid red screen crash
          decoration: const BoxDecoration(), 
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 1. THE BLUR OVERLAY LAYER
              // CSS: width: 393; height: 517; top: 20px; background: #0E4FB8; opacity: 0.1;
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
                    // CSS: backdrop-filter: blur(200px)
                    filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

              // 2. THE LOGO (Centred in the 393x851 canvas)
              Center(
                child: RichText(
                  text: TextSpan(
                    // CSS: font-family: Playfair Display; font-size: 30px;
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      color: Colors.white, // CSS: background: #FFFFFF
                      height: 1.0,         // line-height: 100%
                      letterSpacing: 0,
                    ),
                    children: const [
                      // CSS: font-weight: 400; text-transform: uppercase;
                      TextSpan(
                        text: 'NEXO',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      // CSS: font-weight: 700; text-transform: uppercase;
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