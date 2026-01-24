import 'dart:async';
import 'package:flutter/material.dart';
import 'corporate_setup_complete_screen.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CorporateSetupCompleteScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Payment Gateway",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}