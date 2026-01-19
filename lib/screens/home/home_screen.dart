import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Official Mapbox Professional SDK
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'location_search_screen.dart';
import 'pickup_location_screen.dart';
import 'ride_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  final String address;
  final Function(String) onUpdate; // Updates the pickup text in the main app state

  const HomeScreen({
    super.key,
    required this.address,
    required this.onUpdate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ================= UI STATE =================
  bool isCashBackMode = false;
  String destinationAddress = "Enter Destination";
  MapboxMap? mapboxMap;
  bool isManualLocation = false; // Prevents GPS from overwriting manual pickup

  // Coordinates for Navigation
  Point? pickupPoint;
  Point? dropPoint;

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(mapboxToken);
  }

  // ================= 1. MAP INITIALIZATION & GPS =================
  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;

    // Force Android/iOS Permission Popup
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }

    // Enable Professional Blue Pulsing Dot
    await mapboxMap!.location.updateSettings(
      LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );

    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    try {
      final pos = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      pickupPoint = Point(coordinates: Position(pos.longitude, pos.latitude));

      if (mapboxMap != null) {
        await mapboxMap!.flyTo(CameraOptions(center: pickupPoint!, zoom: 15.5), MapAnimationOptions(duration: 1000));
      }

      // Auto-update address text ONLY if user hasn't manually picked a city/pin yet
      if (!isManualLocation) {
        _reverseGeocode(pos.latitude, pos.longitude);
      }
    } catch (e) {
      debugPrint("GPS Fix Error: $e");
    }
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$mapboxToken";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['features'].isNotEmpty) {
        widget.onUpdate(data['features'][0]['place_name'].split(',')[0]);
      }
    }
  }

  // ================= 2. BUTTON LOGIC (EDIT & WHERE TO) =================

  // Function for the "EDIT" button
  Future<void> _handleEditPickup() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => const PickupLocationScreen()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => isManualLocation = true); // Lock the text box from GPS updates
      widget.onUpdate(result); // Update UI with selected city or pin address

      // Move Map Camera to the new manual address
      final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(result)}.json?access_token=$mapboxToken&limit=1";
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['features'].isNotEmpty) {
          final c = data['features'][0]['center'];
          pickupPoint = Point(coordinates: Position(c[0], c[1]));
          mapboxMap?.flyTo(CameraOptions(center: pickupPoint!, zoom: 15.5), MapAnimationOptions(duration: 1000));
        }
      }
    }
  }

  // Function for "WHERE TO?" (Destination)
  Future<void> _handleDestination(String address) async {
    showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));

    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(address)}.json?access_token=$mapboxToken&limit=1";
    final res = await http.get(Uri.parse(url));
    
    Navigator.pop(context); // Close loading

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['features'].isNotEmpty) {
        final c = data['features'][0]['center'];
        dropPoint = Point(coordinates: Position(c[0], c[1]));
        setState(() => destinationAddress = address);

        // Auto-popup Ride Booking
        Navigator.push(context, MaterialPageRoute(builder: (c) => RideBookingScreen(pickup: widget.address, destination: address)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // MAPBOX SDK MAP
          MapWidget(key: const ValueKey("homeMap"), onMapCreated: _onMapCreated),

          // DRAGGABLE UI SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.45,
            maxChildSize: 0.95,
            builder: (context, controller) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 25),

                  // 1. PICKUP BOX
                  GestureDetector(
                    onTap: _handleEditPickup,
                    child: _buildTile(Icons.my_location, "PICK UP", widget.address, true),
                  ),

                  const SizedBox(height: 12),

                  // 2. WHERE TO BOX
                  GestureDetector(
                    onTap: () async {
                      final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationSearchScreen(title: "Destination")));
                      if (res != null) _handleDestination(res);
                    },
                    child: _buildTile(Icons.search, "WHERE TO?", destinationAddress, destinationAddress != "Enter Destination"),
                  ),

                  const SizedBox(height: 30),

                  // 3. SERVICES GRID (6 IMAGES)
                  _buildHeader("Services"),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _svcItem("Bike", "1 Person", "assets/images/bike.png", Icons.directions_bike),
                      _svcItem("Auto", "3 Persons", "assets/images/auto.png", Icons.electric_rickshaw),
                      _svcItem("Car", "4 Seater", "assets/images/car4.png", Icons.directions_car),
                      _svcItem("Car", "6 Seater", "assets/images/car6.png", Icons.airport_shuttle),
                      _svcItem("Pillion", "Sharing", "assets/images/pillion.png", Icons.moped),
                      _svcItem("Corp Ride", "6 Seater", "assets/images/corp.png", Icons.business),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _parcelCard(),

                  const SizedBox(height: 30),

                  // 4. RECENT SEARCHES
                  const Text("RECENT SEARCHES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 15),
                  _recentItem("Secunderabad, Hyderabad", "5th Block, Indiranagar", "2.2 km"),
                  _recentItem("Tech Mahendra Office", "Block 7, Kukatpally", "2.6 km"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= UI BUILDERS =================

  Widget _buildTile(IconData icon, String label, String value, bool showEdit) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
    child: Row(children: [
      Icon(icon, color: AppColors.primaryBlue, size: 22),
      const SizedBox(width: 15),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2E3E5C)), maxLines: 1, overflow: TextOverflow.ellipsis),
      ])),
      if (showEdit) const Text("Edit", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13)),
    ]),
  );

  Widget _buildHeader(String t) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(t, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    Row(children: [
      const Text("Cash Back Mode", style: TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(width: 8),
      CupertinoSwitch(value: isCashBackMode, activeTrackColor: AppColors.primaryBlue, onChanged: (v) => setState(() => isCashBackMode = v))
    ])
  ]);

  Widget _svcItem(String n, String s, String asset, IconData backup) => Container(
    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFF3F4F6))),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(asset, height: 35, errorBuilder: (c, e, s) => Icon(backup, size: 30, color: Colors.blueGrey)),
      const SizedBox(height: 5),
      Text(n, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      Text(s, style: const TextStyle(color: Colors.grey, fontSize: 9)),
    ]),
  );

  Widget _parcelCard() => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
    child: const Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Parcel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text("Max 4kgs", style: TextStyle(color: Colors.grey, fontSize: 12))]),
      Spacer(),
      Icon(Icons.inventory_2, color: Colors.orange, size: 35),
    ]),
  );

  Widget _recentItem(String t, String s, String dist) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(children: [
      const Icon(Icons.access_time, color: Colors.grey, size: 20),
      const SizedBox(width: 15),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(s, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
      Text(dist, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
    ]),
  );
}
