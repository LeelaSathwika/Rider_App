import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';

class ShareTripScreen extends StatefulWidget {
  const ShareTripScreen({super.key});

  @override
  State<ShareTripScreen> createState() => _ShareTripScreenState();
}

class _ShareTripScreenState extends State<ShareTripScreen> {
  // List of contacts
  final List<Map<String, String>> contacts = [
    {"name": "Mom", "phone": "+91 98765 43210"},
    {"name": "Priya", "phone": "+91 98765 43210"},
    {"name": "Rahul", "phone": "+91 98765 43210"},
    {"name": "Dad", "phone": "+91 98765 43210"},
  ];

  // Track selected indices
  final Set<int> selectedIndices = {1}; // Default "Priya" selected per your image

  void _toggleContact(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        if (selectedIndices.length < 3) {
          selectedIndices.add(index);
        } else {
          // Optional: Show a snackbar if more than 3 are selected
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Select up to 3 contacts only")),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. MAP BACKGROUND (Blurred/Recessed)
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(17.3850, 78.4867),
              initialZoom: 15,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            ],
          ),
          Container(color: Colors.black.withOpacity(0.1)), // Dim layer

          // 2. BACK BUTTON
          Positioned(
            top: 50,
            left: 20,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 3. SHARE TRIP BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handlebar
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Share Trip",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Select up to 3 contacts",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 25),

                  // CONTACTS LIST
                  Column(
                    children: List.generate(contacts.length, (index) {
                      return _buildContactTile(index);
                    }),
                  ),

                  const SizedBox(height: 30),

                  // SHARE BUTTON
                  buildPrimaryButton(
                    text: "Share Trip Details",
                    onPressed: () {
                      // Logic to share data
                      Navigator.pop(context);
                    },
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

  Widget _buildContactTile(int index) {
    bool isSelected = selectedIndices.contains(index);
    final contact = contacts[index];

    return GestureDetector(
      onTap: () => _toggleContact(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.black12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom Checkbox
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : Colors.grey.shade400,
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primaryBlue : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  contact['phone']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}