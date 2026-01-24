import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';

class CorporateSetupCompleteScreen extends StatelessWidget {
  const CorporateSetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Corporate Details",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 1. PROGRESS BAR (Step 3 of 3 - All 3 segments Blue)
          _buildProgressBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // 2. LARGE AVATAR/ILLUSTRATION PLACEHOLDER
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // 3. TITLE & SUBTITLE
                  const Text(
                    "Setup Complete",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your Corporate profile ready to use",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  
                  const SizedBox(height: 40),

                  // 4. BENEFITS SECTION
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "What you'll get:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _benefitRow("10% discount on all rides - Forever"),
                  _benefitRow("Lifetime validity"),
                  _benefitRow("Free cancellation"),
                  _benefitRow("No surge pricing"),
                ],
              ),
            ),
          ),

          // 5. BOTTOM NAVIGATION BUTTONS
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                buildPrimaryButton(
                  text: "Book Your First Ride",
                  onPressed: () {
                    // Logic to navigate back to Home Map
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    // Logic to navigate back to Home Map
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    "Skip to Dashboard",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for the Progress Bar (Step 3)
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 15),
          const Text("Step 3 of 3", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Helper for benefit list items
  Widget _benefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}