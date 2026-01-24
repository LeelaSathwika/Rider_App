import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Official Professional Mapbox SDK
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo; 
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
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
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  
  // UI State
  int _selectedRideIndex = 1; 
  String _timeLabel = "Ride Now"; // This updates when user schedules
  DateTime? _scheduledTime;
  bool _isWomenOnly = false;
  bool _isLoading = true;

  // Real-world coordinates
  Position? _startCoords;
  Position? _endCoords;

  final List<Map<String, dynamic>> _rideOptions = [
    {"name": "Bike", "price": "45", "time": "3min away", "drop": "1:45 pm", "img": "assets/images/bike.png"},
    {"name": "Auto", "price": "45", "time": "5min away", "drop": "1:45 pm", "img": "assets/images/auto.png"},
    {"name": "Near by Grouping", "price": "45", "time": "5min away", "drop": "1:45 pm", "img": "assets/images/auto.png"},
    {"name": "Mini AC", "price": "120", "time": "1min away", "drop": "1:45 pm", "img": "assets/images/car4.png", "tag": "FASTEST"},
    {"name": "Min Non AC", "price": "90", "time": "3min away", "drop": "1:45 pm", "img": "assets/images/car6.png"},
  ];

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(mapboxToken);
  }

  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;
    pointAnnotationManager = await controller.annotations.createPointAnnotationManager();
    _initializeTripFlow();
  }

  // ================= 1. MAP LOGIC (ROUTE & PINS) =================
  
  Future<void> _initializeTripFlow() async {
    try {
      _startCoords = await _getCoords(widget.pickup);
      _endCoords = await _getCoords(widget.destination);

      if (_startCoords != null && _endCoords != null) {
        await _fetchAndDrawRoadRoute();
        await _addPinsToMap();
        
        // Auto-fit camera to show the whole trip
        mapboxMap?.setCamera(CameraOptions(
          center: Point(coordinates: _startCoords!),
          zoom: 12.0,
          padding: MbxEdgeInsets(top: 80, left: 50, bottom: 420, right: 50),
        ));
      }
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Trip Init Error: $e");
    }
  }

  Future<Position?> _getCoords(String address) async {
    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(address)}.json?access_token=$mapboxToken&limit=1";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['features'].isNotEmpty) {
        List c = data['features'][0]['center'];
        return Position(c[0], c[1]); 
      }
    }
    return null;
  }

  Future<void> _fetchAndDrawRoadRoute() async {
    final url = "https://api.mapbox.com/directions/v5/mapbox/driving/${_startCoords!.lng},${_startCoords!.lat};${_endCoords!.lng},${_endCoords!.lat}?geometries=geojson&access_token=$mapboxToken";
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final geometry = data['routes'][0]['geometry'];

      await mapboxMap?.style.addSource(GeoJsonSource(id: "route-source", data: jsonEncode(geometry)));
      await mapboxMap?.style.addLayer(LineLayer(
        id: "route-layer",
        sourceId: "route-source",
        lineColor: AppColors.primaryBlue.value, 
        lineWidth: 5.0,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
      ));
    }
  }

  Future<void> _addPinsToMap() async {
    if (pointAnnotationManager == null) return;

    // RED PIN - PICKUP
    await pointAnnotationManager!.create(PointAnnotationOptions(
      geometry: Point(coordinates: Position(_startCoords!.lng, _startCoords!.lat)),
      textField: widget.pickup.split(',')[0], 
      textSize: 12.0,
      textOffset: [0, -2.2],
      textColor: Colors.red.value,
      textHaloColor: Colors.white.value,
      textHaloWidth: 2.0,
      iconImage: "marker-15",
      iconColor: Colors.red.value,
    ));

    // GREEN PIN - DESTINATION
    await pointAnnotationManager!.create(PointAnnotationOptions(
      geometry: Point(coordinates: Position(_endCoords!.lng, _endCoords!.lat)),
      textField: widget.destination.split(',')[0],
      textSize: 12.0,
      textOffset: [0, -2.2],
      textColor: Colors.green.value,
      textHaloColor: Colors.white.value,
      textHaloWidth: 2.0,
      iconImage: "marker-15",
      iconColor: Colors.green.value,
    ));
  }

  // ================= 2. TIME PICKER LOGIC =================

  void _showTimeOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Pickup Time"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _timeLabel = "Ride Now";
                _scheduledTime = null;
              });
              Navigator.pop(context);
            },
            child: const Text("Ride Now"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showDateTimePicker();
            },
            child: const Text("Schedule for Later"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showDateTimePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (c) => Container(
        height: 350,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Select Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: DateTime.now().add(const Duration(minutes: 10)),
                onDateTimeChanged: (dt) => _scheduledTime = dt,
              ),
            ),
            buildPrimaryButton(
              text: "Set Time",
              onPressed: () {
                if (_scheduledTime != null) {
                  setState(() => _timeLabel = DateFormat('MMM d, hh:mm a').format(_scheduledTime!));
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= 3. UI BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // MAP
          MapWidget(
            key: const ValueKey("bookingMap"),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
          ),

          if (_isLoading) const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),

          // BACK BUTTON
          Positioned(
            top: 50, left: 20,
            child: Material(
              elevation: 4, shape: const CircleBorder(), color: Colors.white,
              child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            ),
          ),

          // SELECTION SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  
                  // Interactive Header Row
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _showTimeOptions,
                          child: Row(
                            children: [
                              Icon(Icons.access_time_filled, 
                                color: _scheduledTime != null ? AppColors.primaryBlue : Colors.black87, 
                                size: 22),
                              const SizedBox(width: 8),
                              Text(_timeLabel, 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                  color: _scheduledTime != null ? AppColors.primaryBlue : Colors.black
                                )),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text("Women Only", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            CupertinoSwitch(
                              activeTrackColor: AppColors.primaryBlue,
                              value: _isWomenOnly, 
                              onChanged: (v) => setState(() => _isWomenOnly = v)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // LIST OF VEHICLES
                  Expanded(
                    child: ListView.builder(
                      itemCount: _rideOptions.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context, i) => _buildRideCard(i),
                    ),
                  ),

                  // BOOK BUTTON
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: buildPrimaryButton(
                      text: _scheduledTime == null ? "Book Ride" : "Schedule Ride",
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (c) => FindingRiderScreen(
                              pickup: widget.pickup, 
                              destination: widget.destination
                            )
                          )
                        );
                      },
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

  Widget _buildRideCard(int i) {
    var ride = _rideOptions[i];
    bool isSel = _selectedRideIndex == i;
    return GestureDetector(
      onTap: () => setState(() => _selectedRideIndex = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSel ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSel ? AppColors.primaryBlue : Colors.black12, width: isSel ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Image.asset(ride['img'], width: 65, height: 45, errorBuilder: (c,e,s) => const Icon(Icons.directions_car, size: 40)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ride['tag'] != null)
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFD0E2FF), borderRadius: BorderRadius.circular(5)), child: Text(ride['tag'], style: const TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold))),
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
}