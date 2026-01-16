import 'package:flutter/material.dart';
import '../../constants.dart';
import 'ride_details_history_screen.dart'; // To handle clicking on a ride

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  // Mock Data to match the image provided
  final List<Map<String, dynamic>> historyData = const [
    {
      "type": "Auto",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Completed",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "45",
      "isCompleted": true
    },
    {
      "type": "Bike",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Completed",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "45",
      "isCompleted": true
    },
    {
      "type": "Car AC",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Canceled",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "45",
      "isCompleted": false
    },
    {
      "type": "Bike",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Completed",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "45",
      "isCompleted": true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hidden because it's a main tab
        title: const Text(
          "Ride History",
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 22
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final ride = historyData[index];
          return RideHistoryCard(
            rideType: ride['type'],
            date: ride['date'],
            status: ride['status'],
            fromAddr: ride['from'],
            toAddr: ride['to'],
            driverName: ride['driver'],
            fare: ride['fare'],
            isCompleted: ride['isCompleted'],
            onTap: () {
              // Navigate to specific ride details
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RideDetailsHistoryScreen()),
              );
            },
          );
        },
      ),
    );
  }
}

class RideHistoryCard extends StatelessWidget {
  final String rideType, date, status, fromAddr, toAddr, driverName, fare;
  final bool isCompleted;
  final VoidCallback onTap;

  const RideHistoryCard({
    super.key,
    required this.rideType,
    required this.date,
    required this.status,
    required this.fromAddr,
    required this.toAddr,
    required this.driverName,
    required this.fare,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // Top Row: Type, Date and Status Badge
            Row(
              children: [
                Text(
                  "$rideType  •  ",
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompleted ? Colors.green.shade100 : Colors.red.shade100,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isCompleted ? Colors.green.shade700 : Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),

            // Middle Section: Address Timeline
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Vertical Line / Dots
                Column(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 10),
                    Container(width: 1, height: 25, color: Colors.black12),
                    const Icon(Icons.circle, color: Colors.red, size: 10),
                  ],
                ),
                const SizedBox(width: 12),
                // Address Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddressSubRow("From", fromAddr),
                      const SizedBox(height: 12),
                      _buildAddressSubRow("To", toAddr),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Divider(height: 1, color: Colors.black12),
            const SizedBox(height: 12),

            // Bottom Row: Driver and Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  driverName,
                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                Text(
                  "₹$fare",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSubRow(String label, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        Text(
          address,
          style: const TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w500, 
            color: Color(0xFF2E3E5C)
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}