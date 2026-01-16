import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';
import 'driver_on_way_screen.dart';
import 'change_drop_location_screen.dart';
import 'cancel_ride_screen.dart';

// Enum to manage the two different stages of the trip flow
enum TripDetailsType { finding, driverOTP }

class TripDetailsScreen extends StatefulWidget {
  final String pickup;
  final String destination;
  final TripDetailsType type;

  const TripDetailsScreen({
    super.key,
    required this.pickup,
    required this.destination,
    required this.type,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  // We keep destination in state so it updates if "Change Drop Location" is used
  late String currentDestination;

  @override
  void initState() {
    super.initState();
    currentDestination = widget.destination;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. MAP LAYER (With Red Route Line)
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
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      const LatLng(17.4000, 78.5000), // Pickup
                      const LatLng(17.3700, 78.4700), // Destination
                    ],
                    color: Colors.red,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  const Marker(
                    point: LatLng(17.3850, 78.4867),
                    child: Icon(Icons.location_on, color: AppColors.primaryBlue, size: 35),
                  ),
                  const Marker(
                    point: LatLng(17.3700, 78.4700),
                    child: Icon(Icons.location_on, color: Colors.red, size: 35),
                  ),
                ],
              ),
            ],
          ),

          // 2. TOP BACK BUTTON (With Material wrapper to prevent elevation crash)
          Positioned(
            top: 50,
            left: 20,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              color: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => _handleBackLogic(),
              ),
            ),
          ),

          // 3. TRIP DETAILS BOTTOM PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
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
                  const Text("Trip Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // VEHICLE INFO CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.electric_rickshaw, size: 45, color: Colors.blueGrey),
                        const SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Finding your ride", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("Auto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                        const Spacer(),
                        const Text("₹45", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // LOCATION DETAILS SECTION (Only for Driver tracking stage)
                  if (widget.type == TripDetailsType.driverOTP) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Location Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeDropLocationScreen(pickup: widget.pickup),
                              ),
                            );
                            if (result != null && result is String) {
                              setState(() => currentDestination = result);
                            }
                          },
                          child: const Text(
                            "Change Drop Location",
                            style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],

                  // ADDRESS TIMELINE (Green to Red)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.radio_button_checked, color: Colors.green, size: 20),
                          Container(width: 2, height: 40, color: Colors.black12),
                          const Icon(Icons.radio_button_checked, color: Colors.red, size: 20),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.pickup, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 2),
                            const SizedBox(height: 38),
                            Text(currentDestination, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 2),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ACTION BUTTONS
                  _buildActionButtons(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- LOGIC HELPERS ---

  void _handleBackLogic() {
    if (widget.type == TripDetailsType.finding) {
      // REQUIREMENT: Redirect forward to OTP page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DriverOnWayScreen(pickup: widget.pickup, destination: currentDestination),
        ),
      );
    } else {
      // Stay on current flow (go back to OTP map)
      Navigator.pop(context);
    }
  }

  Widget _buildActionButtons() {
    if (widget.type == TripDetailsType.finding) {
      // Post-booking mode: Single blue "Back" button
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          onPressed: () => _handleBackLogic(),
          child: const Text("Back", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );
    } else {
      // OTP stage mode: Cancel and Back buttons
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CancelRideScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Cancel Ride", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleBackLogic(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text("Back", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }
  }
}