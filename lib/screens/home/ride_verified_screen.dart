import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_search/mapbox_search.dart' as mb;
import '../../constants.dart';
import 'emergency_sos_screen.dart';
import 'share_trip_screen.dart';

class RideVerifiedScreen extends StatefulWidget {
  final String pickup;
  final String destination;

  const RideVerifiedScreen({super.key, required this.pickup, required this.destination});

  @override
  State<RideVerifiedScreen> createState() => _RideVerifiedScreenState();
}

class _RideVerifiedScreenState extends State<RideVerifiedScreen> {
  String selectedCategory = "Restaurants";
  final List<String> categories = ["All Places", "Restaurants", "Petrol Pumps", "Pharmacy"];
  
  List<mb.MapBoxPlace> _nearbyPlaces = [];
  bool _isLoadingPlaces = true;

  // Example coordinates (In a real app, you'd get these from the Geocoding of pickup/dest)
  final LatLng pickupCoord = const LatLng(17.4000, 78.5000);
  final LatLng destCoord = const LatLng(17.3700, 78.4700);

  @override
  void initState() {
    super.initState();
    // Fetch places along the route on startup
    _fetchPlacesAlongRoute("restaurant");
  }

  // logic to fetch places near the MIDPOINT of the route
  Future<void> _fetchPlacesAlongRoute(String categoryType) async {
    if (!mounted) return;
    setState(() => _isLoadingPlaces = true);

    // 1. Calculate Midpoint to find places "along the route"
    double midLat = (pickupCoord.latitude + destCoord.latitude) / 2;
    double midLng = (pickupCoord.longitude + destCoord.longitude) / 2;

    // 2. Mapbox Search API with Proximity to Midpoint
    final String url = 
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(categoryType)}.json"
        "?limit=5"
        "&proximity=$midLng,$midLat" 
        "&access_token=$mapboxToken";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List features = data['features'];
        
        setState(() {
          // Mapping data correctly to the MapBoxPlace model
          _nearbyPlaces = features.map((f) => mb.MapBoxPlace.fromJson(f)).toList();
          _isLoadingPlaces = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingPlaces = false);
      debugPrint("Route Search Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. MAP LAYER
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                (pickupCoord.latitude + destCoord.latitude) / 2,
                (pickupCoord.longitude + destCoord.longitude) / 2,
              ),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxToken',
                userAgentPackageName: 'com.example.flutter_application_rider',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [pickupCoord, destCoord],
                    color: Colors.red,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(point: pickupCoord, child: const Icon(Icons.location_on, color: Colors.green, size: 30)),
                  Marker(point: destCoord, child: const Icon(Icons.location_on, color: Colors.red, size: 30)),
                ],
              ),
            ],
          ),

          // 2. TOP ACTION BUTTONS
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleMapBtn(Icons.arrow_back, () => Navigator.pop(context)),
                _circleMapBtn(Icons.share, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShareTripScreen()));
                }),
              ],
            ),
          ),

          // 3. SOS BUTTON
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.62,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencySosScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8), boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 4)]),
                child: const Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          // 4. BOTTOM INFO SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, controller) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(24),
                children: [
                  Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 15),

                  // Verified Banner
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: AppColors.primaryBlue, size: 18),
                          SizedBox(width: 8),
                          Text("Your ride has been verified", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildDriverCard(),
                  const SizedBox(height: 25),
                  const Text("Location Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  _buildTimeline(Icons.radio_button_checked, Colors.green, widget.pickup),
                  Padding(padding: const EdgeInsets.only(left: 10), child: Container(width: 2, height: 25, color: Colors.black12)),
                  _buildTimeline(Icons.radio_button_checked, Colors.red, widget.destination),

                  const SizedBox(height: 30),
                  const Text("Places along the route", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // Category Selector
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (c, i) => _buildChip(categories[i]),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // List of Top 5 Places along route
                  if (_isLoadingPlaces)
                    const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                  else
                    ..._nearbyPlaces.map((place) => _placeTile(place)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _circleMapBtn(IconData icon, VoidCallback tap) => Material(
    elevation: 4, shape: const CircleBorder(),
    child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: Icon(icon, color: Colors.black, size: 20), onPressed: tap)),
  );

  Widget _buildDriverCard() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
    child: const Row(children: [
      CircleAvatar(radius: 25, backgroundColor: Colors.orange, child: Text("RK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Rajesh Kumar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text("Bajaj Auto  •  ⭐ 4.8", style: TextStyle(color: Colors.grey, fontSize: 13)),
        Text("KA-90-HV-6953", style: TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
    ]),
  );

  Widget _buildTimeline(IconData icon, Color col, String text) => Row(children: [
    Icon(icon, color: col, size: 20),
    const SizedBox(width: 15),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
  ]);

  Widget _buildChip(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = label);
        String searchKey = label == "Petrol Pumps" ? "gas station" : label.toLowerCase();
        _fetchPlacesAlongRoute(searchKey);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _placeTile(mb.MapBoxPlace place) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      const Icon(Icons.restaurant_menu, color: AppColors.primaryBlue, size: 20),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(place.text ?? "Unnamed", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(place.placeName ?? "Along Route", style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
      ])),
      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    ]),
  );
}