import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml for date formatting
import '../../constants.dart';
import 'finding_rider_screen.dart';

class RideBookingScreen extends StatefulWidget {
  final String pickup;
  final String destination;

  const RideBookingScreen({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  bool _isWomenOnly = false;
  int _selectedRideIndex = 1; 
  
  // New State variables for scheduling
  String _selectedTimeLabel = "Ride Now";
  DateTime? _scheduledDateTime;

  final LatLng pickupCoords = const LatLng(17.4000, 78.5000);
  final LatLng destCoords = const LatLng(17.3700, 78.4700);

  final List<Map<String, dynamic>> _rideOptions = [
    {"name": "Bike", "price": "45", "time": "3min away", "drop": "1:45 pm", "icon": Icons.directions_bike, "tag": null},
    {"name": "Auto", "price": "45", "time": "5min away", "drop": "1:45 pm", "icon": Icons.electric_rickshaw, "tag": null},
    {"name": "Near by Grouping", "price": "45", "time": "5min away", "drop": "1:45 pm", "icon": Icons.groups_rounded, "tag": null},
    {"name": "Mini AC", "price": "120", "time": "1min away", "drop": "1:45 pm", "icon": Icons.directions_car, "tag": "FASTEST"},
    {"name": "Min Non AC", "price": "90", "time": "3min away", "drop": "1:45 pm", "icon": Icons.minor_crash_rounded, "tag": null},
  ];

  // Function to show Schedule Picker
  void _showSchedulePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text("Schedule a Ride", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: DateTime.now().add(const Duration(minutes: 15)),
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    _scheduledDateTime = newDateTime;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    setState(() {
                      if (_scheduledDateTime != null) {
                        _selectedTimeLabel = DateFormat('MMM d, hh:mm a').format(_scheduledDateTime!);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Confirm Time", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Function to show selection between Ride Now and Schedule
  void _showRideOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Select Pickup Time"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedTimeLabel = "Ride Now";
                _scheduledDateTime = null;
              });
              Navigator.pop(context);
            },
            child: const Text("Ride Now"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showSchedulePicker();
            },
            child: const Text("Schedule Ride"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. THE MAP
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                (pickupCoords.latitude + destCoords.latitude) / 2,
                (pickupCoords.longitude + destCoords.longitude) / 2,
              ),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxToken',
                userAgentPackageName: 'com.example.flutter_application_rider',
              ),
              // BLUE ROUTE LINE
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [pickupCoords, destCoords],
                    strokeWidth: 5.0,
                    color: AppColors.primaryBlue.withOpacity(0.7),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pickupCoords,
                    width: 100, height: 80,
                    child: _buildMapPin(widget.pickup, Colors.green),
                  ),
                  Marker(
                    point: destCoords,
                    width: 100, height: 80,
                    child: _buildMapPin(widget.destination, Colors.red),
                  ),
                ],
              ),
            ],
          ),

          // 2. TOP BACK BUTTON
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

          // 3. BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 5)],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  
                  // Header Row with Interactive "Ride Now"
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _showRideOptions,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedTimeLabel == "Ride Now" ? Colors.transparent : AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_filled, 
                                  size: 20, 
                                  color: _selectedTimeLabel == "Ride Now" ? Colors.black87 : AppColors.primaryBlue),
                                const SizedBox(width: 8),
                                Text(_selectedTimeLabel, 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 16,
                                    color: _selectedTimeLabel == "Ride Now" ? Colors.black : AppColors.primaryBlue
                                  )
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Text("Women Only", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 8),
                            CupertinoSwitch(
                              activeTrackColor: AppColors.primaryBlue,
                              value: _isWomenOnly,
                              onChanged: (val) => setState(() => _isWomenOnly = val),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _rideOptions.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) => _buildRideCard(index),
                    ),
                  ),

                  _buildPaymentFooter(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FindingRiderScreen(
                                pickup: widget.pickup,
                                destination: widget.destination,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: Text(
                          _scheduledDateTime == null ? "Book Ride" : "Schedule Ride", 
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Same Map Pin Builder as before
  Widget _buildMapPin(String address, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
          child: Text(address, style: const TextStyle(color: Colors.white, fontSize: 8), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Icon(Icons.location_on, color: color, size: 35),
      ],
    );
  }

  // Same Ride Card Builder as before
  Widget _buildRideCard(int index) {
    final ride = _rideOptions[index];
    bool isSelected = _selectedRideIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedRideIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.black12, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(ride['icon'], size: 40, color: Colors.blueGrey[700]),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ride['tag'] != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(4)),
                      child: Text(ride['tag'], style: const TextStyle(color: AppColors.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  Text(ride['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("${ride['time']} • Drop ${ride['drop']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text("₹${ride['price']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPaymentItem(Icons.account_balance_wallet, "CASH", Colors.green),
          Container(width: 1, height: 25, color: Colors.grey[200]),
          _buildPaymentItem(Icons.percent, "OFFERS", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      ],
    );
  }
}