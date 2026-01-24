import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
import 'payment_gateway_screen.dart';

class CorporateBenefitsScreen extends StatefulWidget {
  const CorporateBenefitsScreen({super.key});

  @override
  State<CorporateBenefitsScreen> createState() => _CorporateBenefitsScreenState();
}

class _CorporateBenefitsScreenState extends State<CorporateBenefitsScreen> {
  // Logic to track selected plan (Defaulting to Executive per your image)
  int selectedIndex = 1; 

  final List<Map<String, dynamic>> plans = [
    {
      "name": "Starter",
      "price": "299",
      "validity": "30days",
      "discount": "10% discount on all rides - Forever",
    },
    {
      "name": "Executive",
      "price": "499",
      "validity": "30days",
      "discount": "20% discount on all rides - Forever",
    },
    {
      "name": "Enterprise",
      "price": "1299",
      "validity": "90days",
      "discount": "10% discount on all rides - Forever",
    }
  ];

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
          // 1. PROGRESS BAR (2 Segments Blue)
          _buildProgressBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Unlock Corporate Benifits", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Select the plan that fits your travel needs", 
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  
                  const SizedBox(height: 30),

                  // 2. DYNAMIC PLAN CARDS
                  ...List.generate(plans.length, (index) => _buildPlanCard(index)),
                ],
              ),
            ),
          ),

          // 3. PAYMENT SECTION
          _buildPaymentFooter(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 15),
          const Text("Step 1 of 3", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPlanCard(int index) {
    bool isSelected = selectedIndex == index;
    var plan = plans[index];

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.black.withOpacity(0.05),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(plan['name'], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "₹${plan['price']}", style: const TextStyle(color: AppColors.primaryBlue, fontSize: 26, fontWeight: FontWeight.bold)),
                      TextSpan(text: " /${plan['validity']}", style: const TextStyle(color: Colors.black54, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _featureRow(plan['discount']),
            _featureRow("Lifetime validity"),
            _featureRow("Free cancellation"),
            _featureRow("No surge pricing"),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.done, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildPaymentFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.account_balance_wallet, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 15),
              const Text("UPI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          buildPrimaryButton(
            text: "Pay ₹${plans[selectedIndex]['price']}",
            onPressed: () {
              // Action for payment
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PaymentGatewayScreen()),
  );
            },
          ),
        ],
      ),
    );
  }
}