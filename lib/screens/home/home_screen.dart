import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Official Mapbox SDK
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo; // Alias to prevent conflict
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'location_search_screen.dart';
import 'pickup_location_screen.dart';
import 'ride_booking_screen.dart';
import 'parcel_pickup.dart';
import 'corporate_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final String address;
  final Function(String) onUpdate;

  const HomeScreen({super.key, required this.address, required this.onUpdate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ================= UI STATE =================
  bool isCashBackMode = false;
  String destinationAddress = "Enter Destination";
  MapboxMap? mapboxMap;
  bool isManualLocation = false;
  Point? pickupPoint;

  @override
  void initState() {
    super.initState();
    // Initialize Mapbox Token
    MapboxOptions.setAccessToken(mapboxToken);
  }

  // ================= 1. MAP & GPS LOGIC =================
  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;

    // A. Force Permission Popup on Mobile
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }

    // B. Enable Professional Blue Pulsing Dot
    await mapboxMap!.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingMaxRadius: 15.0,
      ),
    );

    // C. Add 3D Buildings
    _add3DBuildings();

    _setInitialLocation();
  }

  void _add3DBuildings() async {
    mapboxMap?.style.styleLayerExists("3d-buildings").then((exists) async {
      if (!exists) {
        await mapboxMap?.style.addLayer(FillExtrusionLayer(
          id: "3d-buildings",
          sourceId: "composite",
          sourceLayer: "building",
          minZoom: 15.0,
          fillExtrusionHeightExpression: ['get', 'height'],
          fillExtrusionBaseExpression: ['get', 'min_height'],
          fillExtrusionOpacity: 0.6,
          fillExtrusionColor: Colors.grey.shade300.value,
        ));
      }
    });
  }

  Future<void> _setInitialLocation() async {
    try {
      final pos = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      pickupPoint = Point(coordinates: Position(pos.longitude, pos.latitude));

      if (mapboxMap != null) {
        // Fly to user with Tilt (Pitch) for detailed 3D look
        await mapboxMap!.flyTo(
          CameraOptions(center: pickupPoint!, zoom: 16.0, pitch: 45.0),
          MapAnimationOptions(duration: 1500),
        );
      }

      if (!isManualLocation) {
        _reverseGeocode(pos.latitude, pos.longitude);
      }
    } catch (e) {
      debugPrint("GPS Error: $e");
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

  Future<void> _handleEditPickup() async {
    final String? result = await Navigator.push(context, MaterialPageRoute(builder: (c) => const PickupLocationScreen()));
    if (result != null && result.isNotEmpty) {
      setState(() => isManualLocation = true);
      widget.onUpdate(result);
      _geocodeAndMoveCamera(result);
    }
  }

  Future<void> _handleDestinationSelection(String address) async {
    showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));
    
    // Geocode destination to get coordinates
    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(address)}.json?access_token=$mapboxToken&limit=1";
    final res = await http.get(Uri.parse(url));
    Navigator.pop(context); // Close loader

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['features'].isNotEmpty) {
        setState(() => destinationAddress = address);
        // 👉 DIRECTLY REDIRECT TO BOOKING SCREEN
        Navigator.push(context, MaterialPageRoute(builder: (c) => RideBookingScreen(pickup: widget.address, destination: address)));
      }
    }
  }

  Future<void> _geocodeAndMoveCamera(String addr) async {
    final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(addr)}.json?access_token=$mapboxToken&limit=1";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['features'].isNotEmpty) {
        final c = data['features'][0]['center'];
        pickupPoint = Point(coordinates: Position(c[0], c[1]));
        mapboxMap?.flyTo(CameraOptions(center: pickupPoint!, zoom: 16.0, pitch: 45.0), MapAnimationOptions(duration: 1500));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. THE DETAILED MAP
          MapWidget(
            key: const ValueKey("homeMap"),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
          ),

          // 2. DRAGGABLE UI SHEET
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

                  // PICKUP TILE
                  _buildInputTile(Icons.my_location, "PICK UP", widget.address, true, _handleEditPickup),

                  const SizedBox(height: 12),

                  // WHERE TO TILE
                  _buildInputTile(Icons.search, "WHERE TO?", destinationAddress, false, () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => LocationSearchScreen(title: "Destination", currentPickup: widget.address)));
                    if (res != null) _handleDestinationSelection(res);
                  }),

                  const SizedBox(height: 30),
                  _buildSectionHeader("Services"),
                  const SizedBox(height: 15),

                  // SERVICES GRID (6 IMAGES)
                  GridView.count(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, childAspectRatio: 0.85, mainAxisSpacing: 10, crossAxisSpacing: 10,
                    children: [
                      _svcItem("Bike", "1 Person", "assets/images/bike.png", Icons.directions_bike),
                      _svcItem("Auto", "3 Persons", "assets/images/auto.png", Icons.electric_rickshaw),
                      _svcItem("Car", "4 Seater", "assets/images/car4.png", Icons.directions_car),
                      _svcItem("Car", "6 Seater", "assets/images/car6.png", Icons.airport_shuttle),
                      _svcItem("Pillion", "Sharing", "assets/images/pillion.png", Icons.moped),
                      _svcItem("Corporate Ride", "6 Seater", "assets/images/corp.png", Icons.business, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CorporateDetailsScreen()),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),
                  
                  // PARCEL CARD WITH IMAGE
                  _parcelCard(),

                  const SizedBox(height: 30),
                  const Text("RECENT SEARCHES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 15),
                  _recentItem("Secunderabad, Hyderabad", "5th Block, Road No-14", "2.2 km"),
                  _recentItem("Kukatpally Office", "Block 7, Kukatpally", "2.6 km"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildInputTile(IconData i, String l, String v, bool edit, VoidCallback? onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(15), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
      child: Row(children: [
        Icon(i, color: AppColors.primaryBlue, size: 22), const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2E3E5C)), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        if (edit) const Text("Edit", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget _svcItem(String n, String s, String path, IconData backupIcon, [VoidCallback? onTap]) {
  return GestureDetector(
    onTap: onTap, // Handles the click
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Image.asset(
            path, 
            height: 35, 
            errorBuilder: (c, e, s) => Icon(backupIcon, size: 30, color: Colors.blueGrey[700]),
          ),
          const SizedBox(height: 5),
          Text(n, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(s, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        ],
      ),
    ),
  );
}

  Widget _parcelCard() => GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ParcelPickupScreen())),
    child: Container(
      padding: const EdgeInsets.all(15), decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Parcel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text("Max 4kgs", style: TextStyle(color: Colors.grey, fontSize: 12))]),
        const Spacer(),
        Image.asset('assets/images/parcel.png', height: 45, errorBuilder: (c,e,s) => const Icon(Icons.inventory_2, color: Colors.orange)),
      ]),
    ),
  );

  Widget _buildSectionHeader(String t) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(t, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    CupertinoSwitch(value: isCashBackMode, activeTrackColor: AppColors.primaryBlue, onChanged: (v) => setState(() => isCashBackMode = v))
  ]);

  Widget _recentItem(String t, String s, String d) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Row(children: [const Icon(Icons.access_time, color: Colors.grey, size: 20), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(s, style: const TextStyle(color: Colors.grey, fontSize: 12))])), Text(d, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))]));
}