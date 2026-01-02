import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';
import 'home/navigation_wrapper.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildLogoHeader(),
            const SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome to NexoRyd', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text("Let's set up your profile", style: TextStyle(fontSize: 15, color: AppColors.textGray)),
                    const SizedBox(height: 32),
                    _label("Full Name"),
                    _field(Icons.person_outline, "Enter your name"),
                    const SizedBox(height: 20),
                    _label("Email Address"),
                    _field(Icons.mail_outline, "Enter your email"),
                    const SizedBox(height: 20),
                    _label("Gender"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_gBtn("Male"), _gBtn("Female"), _gBtn("Others")],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  buildPrimaryButton(
                    text: 'Continue',
                    onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainNavigationWrapper()), (r) => false),
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

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(color: AppColors.textGray, fontSize: 14)));
  Widget _field(IconData i, String h) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: TextField(decoration: InputDecoration(prefixIcon: Icon(i, color: Colors.grey), hintText: h, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15))),
  );
  Widget _gBtn(String type) {
    bool isSelected = selectedGender == type;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = type),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28, height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.border, width: isSelected ? 1.5 : 1)),
        child: Center(child: Text(type, style: TextStyle(color: isSelected ? Colors.black : Colors.grey))),
      ),
    );
  }
}