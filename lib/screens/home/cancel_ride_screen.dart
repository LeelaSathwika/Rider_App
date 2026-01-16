import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';

class CancelRideScreen extends StatefulWidget {
  const CancelRideScreen({super.key});

  @override
  State<CancelRideScreen> createState() => _CancelRideScreenState();
}

class _CancelRideScreenState extends State<CancelRideScreen> {
  // To track the selected reason
  String? selectedReason = "Driver is taking too long";

  final List<String> reasons = [
    "Driver is taking too long",
    "Booked by mistake",
    "Change of plans",
    "Found alternative transport",
    "Driver asked to cancel",
    "Incorrect pickup location",
    "Other reason"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. MAP BACKGROUND (Blurred/Static)
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(17.3850, 78.4867),
              initialZoom: 14,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            ],
          ),
          // Dark overlay to make map look recessed
          Container(color: Colors.black.withOpacity(0.1)),

          // 2. CANCELLATION SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 15),
                  const Text(
                    "Why are you cancelling?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // CANCELLATION POLICY BOX
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cancellation Policy",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                        ),
                        const SizedBox(height: 10),
                        _policyItem("Free cancellation before driver arrives"),
                        _policyItem("5-minute grace period after arrival."),
                        _policyItem("After grace: 20% fare (min ₹20)."),
                        _policyItem("Frequent cancellations may affect your account."),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // REASONS LIST
                  Flexible(
                    child: Column(
                      children: reasons.map((reason) => RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 15,
                            color: selectedReason == reason ? Colors.black : Colors.grey[600],
                            fontWeight: selectedReason == reason ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        value: reason,
                        groupValue: selectedReason,
                        activeColor: AppColors.primaryBlue,
                        onChanged: (val) {
                          setState(() {
                            selectedReason = val;
                          });
                        },
                      )).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryBlue),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Keep Ride", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // LOGIC: Return to Home Map
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                          child: const Text("Cancel Ride", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _policyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: AppColors.primaryBlue, fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF1E40AF), fontSize: 13))),
        ],
      ),
    );
  }
}