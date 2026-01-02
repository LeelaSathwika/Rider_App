import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'constants.dart';

void main() => runApp(const NexoRydApp());

class NexoRydApp extends StatelessWidget {
  const NexoRydApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bg, fontFamily: 'sans-serif'),
      home: const SplashScreen(),
    );
  }
}