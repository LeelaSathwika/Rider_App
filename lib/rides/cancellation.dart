import 'package:flutter/material.dart';
import '../constants.dart'; // Using the primaryBlue defined earlier

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Subscription Plans",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Header Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9D33FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ride More, Save More",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Choose a plan that fits your lifestyle",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),

            // Basic Plan
            const SubscriptionCard(
              title: "Basic",
              price: "299",
              validity: "30days",
              buttonColor: AppColors.primaryBlue,
              features: [
                "10% discount on all rides - Forever",
                "Lifetime validity",
                "Free cancellation",
                "No surge pricing"
              ],
            ),
            const SizedBox(height: 20),

            // Pro Plan (Highlighted with Purple Border)
            const SubscriptionCard(
              title: "Pro",
              price: "499",
              validity: "30days",
              buttonColor: Color(0xFF9D33FF),
              hasBorder: true,
              borderColor: Color(0xFF9D33FF),
              features: [
                "20% discount on all rides - Forever",
                "Lifetime validity",
                "Free cancellation",
                "No surge pricing"
              ],
            ),
            const SizedBox(height: 20),

            // Premium Plan
            const SubscriptionCard(
              title: "Premium",
              price: "1299",
              validity: "90days",
              buttonColor: AppColors.primaryBlue,
              features: [
                "10% discount on all rides - Forever",
                "Lifetime validity",
                "Free cancellation",
                "No surge pricing"
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Card Widget
class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String validity;
  final List<String> features;
  final Color buttonColor;
  final bool hasBorder;
  final Color borderColor;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.validity,
    required this.features,
    required this.buttonColor,
    this.hasBorder = false,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder ? Border.all(color: borderColor, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹$price",
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " /$validity",
                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Features List
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    const Icon(Icons.done, color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      feature,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Subscribe Now",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
