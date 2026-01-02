import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';
import 'profile_setup_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (i) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildLogoHeader(showBack: true, onBack: () => Navigator.pop(context)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verify your mobile number', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('We have sent an OTP to your mobile number', style: TextStyle(fontSize: 15, color: AppColors.textGray)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => _otpBox(index)),
                  ),
                  const SizedBox(height: 60),
                  _buildResendText(),
                  const SizedBox(height: 20),
                  buildPrimaryButton(
                    text: 'Verify OTP',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSetupScreen())),
                  ),
                  const SizedBox(height: 16),
                  buildFooterLinks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) => Container(
    width: 65, height: 65,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: TextField(
      focusNode: _focusNodes[index],
      textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 1,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(counterText: "", border: InputBorder.none),
      onChanged: (v) { if (v.isNotEmpty && index < 3) _focusNodes[index + 1].requestFocus(); },
    ),
  );

  Widget _buildResendText() => Center(child: RichText(text: const TextSpan(style: TextStyle(color: AppColors.textGray, fontSize: 15), children: [TextSpan(text: "Didn't receive code? "), TextSpan(text: "Resend", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold))])));
}