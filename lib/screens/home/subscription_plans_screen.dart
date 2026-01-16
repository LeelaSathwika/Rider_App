import 'package:flutter/material.dart';
import '../../constants.dart';
import 'payment_screen.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Consistent light background
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. TOP HEADER SECTION
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9D33FF), // Purple theme color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
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

            // 2. BASIC PLAN CARD
            PlanCard(
              title: "Basic",
              price: "299",
              validity: "/30days",
              buttonColor: AppColors.primaryBlue,
              features: const [
                "10% discount on all rides - Forever",
                "Lifetime validity",
                "Free cancellation",
                "No surge pricing"
              ],
            ),
            const SizedBox(height: 20),

            // 3. PRO PLAN CARD (Highlighted with Purple Border)
            PlanCard(
              title: "Pro",
              price: "499",
              validity: "/30days",
              buttonColor: const Color(0xFF9D33FF),
              borderColor: const Color(0xFF9D33FF),
              features: const [
                "20% discount on all rides - Forever",
                "Lifetime validity",
                "Free cancellation",
                "No surge pricing"
              ],
            ),
            const SizedBox(height: 20),

            // 4. PREMIUM PLAN CARD
            PlanCard(
              title: "Premium",
              price: "1299",
              validity: "/90days",
              buttonColor: AppColors.primaryBlue,
              features: const [
                "10% discount on all rides - Forever",
                "Lifetime validity",
                "Free cancellation",
                "No surge pricing"
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String validity;
  final List<String> features;
  final Color buttonColor;
  final Color? borderColor;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.validity,
    required this.features,
    required this.buttonColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // If borderColor is passed (Pro plan), show purple border, else nothing
        border: borderColor != null ? Border.all(color: borderColor!, width: 1.5) : null,
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
          // Plan Header (Name and Price)
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
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " $validity",
                      style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          // Features List with Green Ticks
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.done, color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      feature,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )),
          
          const SizedBox(height: 15),
          
          // Subscribe Button (Navigates to Payment Screen)
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      planName: title,
                      price: price,
                      validity: validity,
                      features: features,
                    ),
                  ),
                );
              },
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