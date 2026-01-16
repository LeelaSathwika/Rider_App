import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';
import 'trip_details_screen.dart';

class DriverOnWayScreen extends StatelessWidget {
  final String pickup;
  final String destination;

  const DriverOnWayScreen({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. THE MAP LAYER (Full Screen)
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(17.3850, 78.4867),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxToken',
                additionalOptions: {
                  'accessToken': mapboxToken,
                  'id': 'mapbox.mapbox-streets-v12',
                },
                // Ensure this matches your package name from build.gradle
                userAgentPackageName: 'com.example.flutter_application_rider',
              ),
              // Route Line from Driver to Pickup
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      const LatLng(17.3910, 78.4950), // Driver Position
                      const LatLng(17.3850, 78.4867), // Pickup Position
                    ],
                    color: Colors.black54,
                    strokeWidth: 3.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Driver Vehicle Icon
                  const Marker(
                    point: LatLng(17.3910, 78.4950),
                    width: 40, height: 40,
                    child: Icon(Icons.electric_rickshaw, color: Colors.black, size: 30),
                  ),
                  // Pickup Location (Red Pin)
                  const Marker(
                    point: LatLng(17.3850, 78.4867),
                    width: 40, height: 40,
                    child: Icon(Icons.location_on, color: Colors.red, size: 35),
                  ),
                ],
              ),
            ],
          ),

          // 2. TOP BACK BUTTON (Fixed Material elevation)
          Positioned(
            top: 50,
            left: 20,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              color: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. BOTTOM DRIVER STATUS SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handlebar
                  Center(
                    child: Container(
                      width: 50, height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // OTP DISPLAY BANNER
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF), // Exact light blue
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Share this OTP with driver  ", style: TextStyle(fontSize: 15, color: Colors.black87)),
                        Text(
                          "9 3 1 3", 
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                            color: AppColors.primaryBlue, 
                            letterSpacing: 4
                          )
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // STATUS TEXT
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        const TextSpan(text: "Captain On the way  "),
                        TextSpan(
                          text: "3 mins", 
                          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // DRIVER INFO CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orange,
                          child: Text("RK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rajesh Kumar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("Bajaj Auto", style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 14),
                                  Text(" 4.8  •  KA-90-HV-6953", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Call and Chat action circles
                        _buildCircleAction(Icons.phone, Colors.green),
                        const SizedBox(width: 10),
                        _buildCircleAction(Icons.chat_bubble, AppColors.primaryBlue),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PICKUP ADDRESS PREVIEW
                  const Text("Pickup From", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text(
                    pickup, 
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 20),

                  // TRIP DETAILS BUTTON (Outlined)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailsScreen(
                              pickup: pickup,
                              destination: destination,
                              type: TripDetailsType.driverOTP, // Next stage mode
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        "Trip Details", 
                        style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ISSUE WARNING BUTTON (Red)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE), // Soft red background
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Issue with pickup?", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper widget for circular icon buttons (Call/Chat)
  Widget _buildCircleAction(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}