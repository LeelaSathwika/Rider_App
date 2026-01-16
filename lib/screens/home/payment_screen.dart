import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';

class PaymentScreen extends StatelessWidget {
  final String planName;
  final String price;
  final String validity;
  final List<String> features;

  const PaymentScreen({
    super.key,
    required this.planName,
    required this.price,
    required this.validity,
    required this.features,
  });

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
          "Complete Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PLAN SUMMARY CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primaryBlue, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$planName Plan",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${validity.replaceAll('/', '')} validity",
                          style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        _buildPriceRow("Plan Price", "₹$price"),
                        const SizedBox(height: 12),
                        _buildPriceRow("Service Charges", "₹0", isGreen: true),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(color: Colors.black12),
                        ),
                        _buildPriceRow("Total Amount", "₹$price", isBold: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. BENEFITS SECTION
                  const Text(
                    "What you'll get:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            const Icon(Icons.done, color: Colors.green, size: 20),
                            const SizedBox(width: 12),
                            Text(f, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),

          // 3. BOTTOM PAYMENT SELECTION & BUTTON
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Payment Method Selector
                InkWell(
                  onTap: () {}, // Logic to change payment method
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.account_balance_wallet, color: Colors.green, size: 24),
                        ),
                        const SizedBox(width: 15),
                        const Text("UPI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Pay Button
                buildPrimaryButton(
                  text: "Pay ₹$price",
                  onPressed: () {
                    // Logic for actual payment gateway integration
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isGreen = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isGreen ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}