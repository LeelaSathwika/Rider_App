import 'package:flutter/material.dart';
import '../constants.dart';

Widget buildLogoHeader({bool showBack = false, VoidCallback? onBack}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (showBack)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBack,
            ),
          ),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            children: [
              TextSpan(text: 'NEXO', style: TextStyle(color: Color(0xFF2E3E5C))),
              TextSpan(text: 'RYD', style: TextStyle(color: AppColors.primaryBlue)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildPrimaryButton({required String text, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget buildFooterLinks() {
  return Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 12, color: AppColors.textGray, height: 1.5),
        children: [
          TextSpan(text: "By continuing, you agree to our "),
          TextSpan(text: "Terms of Service", style: TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline)),
          TextSpan(text: " and "),
          TextSpan(text: "Privacy Policy", style: TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline)),
        ],
      ),
    ),
  );
}