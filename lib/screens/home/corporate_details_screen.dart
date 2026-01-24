import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
import 'pin_location_screen.dart';
import 'corporate_benefits_screen.dart';

class CorporateDetailsScreen extends StatefulWidget {
  const CorporateDetailsScreen({super.key});

  @override
  State<CorporateDetailsScreen> createState() => _CorporateDetailsScreenState();
}

class _CorporateDetailsScreenState extends State<CorporateDetailsScreen> {
  final TextEditingController _homeController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();

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
          // 1. PROGRESS BAR SECTION
          _buildProgressBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Where do you work?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We will use this to streamline your daily commute expensing",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // 2. HOME LOCATION
                  _buildLabelWithAction("Home Location", "Locate on Map", () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const PinLocationScreen()));
                    if (res != null) setState(() => _homeController.text = res);
                  }),
                  _buildSearchField(Icons.search, "Search location", _homeController),

                  const SizedBox(height: 20),

                  // 3. OFFICE LOCATION
                  _buildLabelWithAction("Office Location", "Locate on Map", () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const PinLocationScreen()));
                    if (res != null) setState(() => _officeController.text = res);
                  }),
                  _buildSearchField(Icons.search, "Search location", _officeController),

                  const SizedBox(height: 20),

                  // 4. COMPANY NAME
                  _buildSimpleLabel("Company Name"),
                  _buildSearchField(Icons.calendar_today_outlined, "Enter company name", TextEditingController()),

                  const SizedBox(height: 20),

                  // 5. CORPORATE EMAIL
                  _buildSimpleLabel("Corporate Email"),
                  _buildSearchField(Icons.calendar_today_outlined, "Enter corporate email", TextEditingController()),

                  const SizedBox(height: 20),

                  // 6. EMPLOYEE ID
                  _buildSimpleLabel("Employee ID"),
                  _buildSearchField(Icons.calendar_today_outlined, "Enter corporate email", TextEditingController()),

                  const SizedBox(height: 25),

                  // 7. INFO BOX
                  _buildInfoBox(),
                ],
              ),
            ),
          ),

          // 8. CONTINUE BUTTON
          Padding(
            padding: const EdgeInsets.all(24),
            child: buildPrimaryButton(
              text: "Continue",
              onPressed: () {
                // Navigate to Step 2
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CorporateBenefitsScreen()),
  );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 15),
          const Text("Step 1 of 3", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLabelWithAction(String label, String action, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          GestureDetector(
            onTap: onTap,
            child: Text(action, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSearchField(IconData icon, String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey, size: 22),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Corporate rides must be scheduled at least 3 hours before the pickup time.",
              style: TextStyle(color: AppColors.primaryBlue, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}