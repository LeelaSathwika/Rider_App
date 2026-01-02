import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: buildLogoHeader()),
              const SizedBox(height: 60),
              const Text("Welcome Back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
              const SizedBox(height: 8),
              const Text("Enter your mobile number to continue", style: TextStyle(fontSize: 15, color: AppColors.textGray)),
              const SizedBox(height: 40),
              const Text("Mobile Number", style: TextStyle(fontSize: 14, color: AppColors.textGray, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                child: const TextField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 12),
                        Icon(Icons.phone_outlined, color: AppColors.textGray, size: 20),
                        SizedBox(width: 8),
                        Text("+91", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        SizedBox(height: 25, child: VerticalDivider(color: Colors.black12, thickness: 1)),
                        SizedBox(width: 8),
                      ],
                    ),
                    hintText: "Enter 10 digit mobile number",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
              const Spacer(),
              buildPrimaryButton(
                text: "Send OTP",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpVerificationScreen())),
              ),
              const SizedBox(height: 15),
              buildFooterLinks(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}