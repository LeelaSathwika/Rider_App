import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';
import 'trip_details_screen.dart';

class FindingRiderScreen extends StatefulWidget {
  final String pickup;
  final String destination;

  const FindingRiderScreen({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  State<FindingRiderScreen> createState() => _FindingRiderScreenState();
}

class _FindingRiderScreenState extends State<FindingRiderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Logic for the pulsating search animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. THE MAP BACKGROUND
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(17.3850, 78.4867),
              initialZoom: 14,
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
              
              // THE RED ROUTE LINE
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      const LatLng(17.4000, 78.5000), // Sample Pickup
                      const LatLng(17.3700, 78.4700), // Sample Destination
                    ],
                    color: Colors.red,
                    strokeWidth: 4.0,
                  ),
                ],
              ),

              MarkerLayer(
                markers: [
                  // Blue Pin (User's Current Location)
                  Marker(
                    point: const LatLng(17.3850, 78.4867),
                    width: 60,
                    height: 60,
                    child: _buildBluePin(),
                  ),
                  // Red Pin (Destination)
                  const Marker(
                    point: LatLng(17.3700, 78.4700),
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

          // 3. BOTTOM INFO SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handlebar
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Pulsating Avatar Logic
                  ScaleTransition(
                    scale: Tween(begin: 0.95, end: 1.08).animate(_pulseController),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: const Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Quick Match Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on, color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Quick Match",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title & Description
                  const Text(
                    "Finding your rider",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hang tight! We're connecting you with\nnearby rider",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 35),

                  // Trip Details Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailsScreen(
                              pickup: widget.pickup,
                              destination: widget.destination,
                              type: TripDetailsType.finding, // Post-booking mode
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Trip Details",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
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

  // Helper for user's blue current location pin
  Widget _buildBluePin() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBlue.withOpacity(0.2),
          ),
        ),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBlue,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ],
    );
  }
}