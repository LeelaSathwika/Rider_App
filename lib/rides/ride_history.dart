import 'package:flutter/material.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  final List<Map<String, dynamic>> rides = [
    {
      "type": "Auto",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Completed",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "₹45"
    },
    {
      "type": "Bike",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Completed",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "₹45"
    },
    {
      "type": "Car AC",
      "date": "30 Nov 2025, 10:30 AM",
      "status": "Canceled",
      "from": "5th Block, Road No-14, Indiranagar, Hyderabad",
      "to": "Block 7, Kukatpally, Hyderabad",
      "driver": "Rajesh Kumar",
      "fare": "₹45"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Ride History",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      /// Body
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rides.length,
        itemBuilder: (context, index) {
          final ride = rides[index];
          final isCompleted = ride["status"] == "Completed";

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  children: [
                    Text(
                      "${ride["type"]}  •  ${ride["date"]}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ride["status"],
                        style: TextStyle(
                          fontSize: 12,
                          color: isCompleted ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// From
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle,
                        color: Colors.green, size: 8),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("From",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            ride["from"],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// To
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle,
                        color: Colors.red, size: 8),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("To",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            ride["to"],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade300),

                /// Bottom Row
                Row(
                  children: [
                    Text(
                      ride["driver"],
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      ride["fare"],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
