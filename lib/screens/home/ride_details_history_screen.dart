import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
import 'schedule_ride_screen.dart';

class RideDetailsHistoryScreen extends StatelessWidget {
  const RideDetailsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Light greyish-blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ride Details",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "ID: #RYD0023",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, size: 18, color: Colors.grey),
            label: const Text(
              "Need help?",
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          )
        ],
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
                children: [
                  // 1. SERVICE SUMMARY SECTION
                  _buildSectionCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.electric_rickshaw, size: 40, color: Colors.blueGrey),
                            const SizedBox(width: 15),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Service Type", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                Text("Auto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const Spacer(),
                            _buildStatusChip("Completed", Colors.green),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Colors.black12),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              "30 Nov 2025, 10:30 AM",
                              style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. TRIP ROUTE SECTION
                  _buildSectionCard(
                    title: "Trip Route",
                    child: Column(
                      children: [
                        _buildRouteRow(Colors.green, "From", "5th Block, Road No-14, Indiranagar, Hyderabad"),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(width: 1, height: 25, color: Colors.black12),
                          ),
                        ),
                        _buildRouteRow(Colors.red, "To", "Koramangala"),
                      ],
                    ),
                  ),

                  // 3. DRIVER INFORMATION SECTION
                  _buildSectionCard(
                    title: "Driver Information",
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orange,
                          child: Text("RK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rajesh Kumar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Driver", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 4. FARE DETAILS SECTION
                  _buildSectionCard(
                    title: "Fare Details",
                    child: Column(
                      children: [
                        _buildFareRow("Base Fare", "₹31"),
                        const SizedBox(height: 12),
                        _buildFareRow("Distance Charge", "₹13"),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Colors.black12),
                        ),
                        _buildFareRow("Total Paid", "₹45", isBold: true),
                      ],
                    ),
                  ),

                  // 5. YOUR RATING SECTION
                  _buildSectionCard(
                    title: "Your Rating",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Thank you for your feedback!", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 15),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < 3 ? Colors.orange : Colors.grey.shade200,
                              size: 40,
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        const Text("You rated this ride 3 stars", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM FIXED BUTTON
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
            ),
            child: buildPrimaryButton(
              text: "Book Similar Ride",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScheduleRideScreen()),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // --- UI WIDGET HELPERS ---

  Widget _buildSectionCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            const SizedBox(height: 15),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRouteRow(Color color, String label, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(Icons.circle, color: color, size: 10),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFareRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? Colors.black : Colors.grey.shade600,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: Colors.black,
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}