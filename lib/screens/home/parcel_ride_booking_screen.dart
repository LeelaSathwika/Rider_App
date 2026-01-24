import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo; // Alias to avoid conflict
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
import 'finding_rider_screen.dart';

class ParcelRideBookingScreen extends StatefulWidget {
  final String pickup;
  final String destination;

  const ParcelRideBookingScreen({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  State<ParcelRideBookingScreen> createState() => _ParcelRideBookingScreenState();
}

class _ParcelRideBookingScreenState extends State<ParcelRideBookingScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  int _selectedRideIndex = 0; // Default to Bike
  bool _isLoading = true;

  // Mapbox-specific Position objects
  Position? _startCoords;
  Position? _endCoords;

  final List<Map<String, dynamic>> _parcelOptions = [
    {"name": "Bike", "price": "25", "time": "3min away", "drop": "1.45 pm", "img": "assets/images/bike.png"},
    {"name": "Auto", "price": "45", "time": "5min away", "drop": "1.45 pm", "img": "assets/images/auto.png"},
  ];

  @override
  void initState() {
    super.initState();
    // Critical: Initialize Token
    MapboxOptions.setAccessToken(mapboxToken);
  }

  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;
    // Create manager for the Red/Green pins
    pointAnnotationManager = await controller.annotations.createPointAnnotationManager();
    _initializeTrip();
  }

  // ================= 1. REAL ROUTING & PINS LOGIC =================

  Future<void> _initializeTrip() async {
    try {
      // A. Get real coordinates for both addresses
      _startCoords = await _getCoords(widget.pickup);
      _endCoords = await _getCoords(widget.destination);

      if (_startCoords != null && _endCoords != null) {
        // B. Draw the Road-Following Route
        await _fetchAndDrawRoadRoute();

        // C. Add Custom Pins (Green for Pickup, Red for Destination)
        await _addLocationPins();

        // D. Zoom map to show both points with padding for the UI
        mapboxMap?.setCamera(CameraOptions(
          center: Point(coordinates: _startCoords!),
          zoom: 13.0,
          padding: MbxEdgeInsets(top: 100, left: 60, bottom: 450, right: 60),
        ));
      }
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Parcel Route Error: $e");
    }
  }

  Future<Position?> _getCoords(String address) async {
    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(address)}.json?access_token=$mapboxToken&limit=1";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['features'].isNotEmpty) {
        List c = data['features'][0]['center'];
        return Position(c[0], c[1]); // Longitude, Latitude
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

      // Add Source and Layer to draw the route line
      await mapboxMap?.style.addSource(GeoJsonSource(id: "route-source", data: jsonEncode(geometry)));
      await mapboxMap?.style.addLayer(LineLayer(
        id: "route-layer",
        sourceId: "route-source",
        lineColor: Colors.black.value, // Dark route line
        lineWidth: 5.0,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
      ));
    }
  }

  Future<void> _addLocationPins() async {
    if (pointAnnotationManager == null) return;

    // 1. GREEN PIN - PICKUP
    await pointAnnotationManager!.create(PointAnnotationOptions(
      // FIX: Use the Point class directly. 
      // Ensure Position is (Longitude, Latitude)
      geometry: Point(coordinates: Position(_startCoords!.lng, _startCoords!.lat)),
      textField: "From\n${widget.pickup.split(',')[0]}...",
      textSize: 10.0,
      textOffset: [0, -2.5],
      textColor: Colors.white.value,
      textHaloColor: Colors.black.value,
      textHaloWidth: 8.0,
      iconImage: "marker-15",
      iconColor: Colors.green.value,
    ));

    // 2. RED PIN - DESTINATION
    await pointAnnotationManager!.create(PointAnnotationOptions(
      // FIX: Use the Point class directly
      geometry: Point(coordinates: Position(_endCoords!.lng, _endCoords!.lat)),
      textField: "To\n${widget.destination.split(',')[0]}...",
      textSize: 10.0,
      textOffset: [0, -2.5],
      textColor: Colors.white.value,
      textHaloColor: Colors.black.value,
      textHaloWidth: 8.0,
      iconImage: "marker-15",
      iconColor: Colors.red.value,
    ));
  }
  // ================= 2. UI LAYOUT =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // THE MAP
          MapWidget(
            key: const ValueKey("parcelMap"),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
          ),

          if (_isLoading) const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),

          // BACK BUTTON
          Positioned(
            top: 50, left: 20,
            child: Material(
              elevation: 4, shape: const CircleBorder(), color: Colors.white,
              child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),

          // BOTTOM SELECTION SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.52,
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
                  const SizedBox(height: 10),
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: _parcelOptions.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemBuilder: (context, i) => _buildRideCard(i),
                    ),
                  ),

                  _buildPaymentFooter(),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: buildPrimaryButton(
                      text: "Book Ride",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => FindingRiderScreen(
                              pickup: widget.pickup,
                              destination: widget.destination,
                            ),
                          ),
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
    var ride = _parcelOptions[i];
    bool isSel = _selectedRideIndex == i;
    return GestureDetector(
      onTap: () => setState(() => _selectedRideIndex = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSel ? AppColors.primaryBlue : Colors.black.withOpacity(0.05),
            width: isSel ? 1.5 : 1,
          ),
          color: isSel ? AppColors.primaryBlue.withOpacity(0.03) : Colors.white,
        ),
        child: Row(
          children: [
            Image.asset(ride['img'], width: 70, height: 50, errorBuilder: (c, e, s) => const Icon(Icons.directions_bike, size: 40)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("${ride['time']} • Drop ${ride['drop']}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Text("₹${ride['price']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _footerBtn(Icons.account_balance_wallet, "CASH", Colors.green),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _footerBtn(Icons.percent, "OFFERS", Colors.orange),
        ],
      ),
    );
  }

  Widget _footerBtn(IconData i, String t, Color c) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(i, color: c, size: 20),
        ),
        const SizedBox(width: 10),
        Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
      ],
    );
  }
}