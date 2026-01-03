import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

const String MAPBOX_TOKEN =
    "pk.eyJ1IjoicmFqZW5kcmE5OTUwIiwiYSI6ImNtajhsajg0MDAxYnYzcHF0c3Z1bjM0OGIifQ.VQCWQADfuUyVO_6Qch8jUQ";

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointManager;

  bool womenOnly = false;
  int selectedIndex = 4;

  final Point pickup =
  Point(coordinates: Position(77.5946, 12.9716));
  final Point drop =
  Point(coordinates: Position(77.6046, 12.9816));

  static const routeSourceId = "route-source";
  static const routeLayerId = "route-layer";

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(MAPBOX_TOKEN);
  }

  // ---------------- MAP CREATED ----------------
  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;

    await mapboxMap!.setCamera(
      CameraOptions(center: pickup, zoom: 15),
    );

    pointManager =
    await mapboxMap!.annotations.createPointAnnotationManager();

    await _addMarkers();
    await _drawRoute();
  }

  // ---------------- MARKERS ----------------
  Future<void> _addMarkers() async {
    await pointManager?.deleteAll();

    await pointManager?.create(
      PointAnnotationOptions(
        geometry: pickup,
        iconSize: 1.4,
      ),
    );

    await pointManager?.create(
      PointAnnotationOptions(
        geometry: drop,
        iconSize: 1.4,
      ),
    );
  }

  // ---------------- ROUTE ----------------
  Future<void> _drawRoute() async {
    final url =
        "https://api.mapbox.com/directions/v5/mapbox/driving/"
        "${pickup.coordinates.lng},${pickup.coordinates.lat};"
        "${drop.coordinates.lng},${drop.coordinates.lat}"
        "?geometries=geojson&overview=full&access_token=$MAPBOX_TOKEN";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final coords = data["routes"][0]["geometry"]["coordinates"];

    final geoJsonString = jsonEncode({
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": coords,
      }
    });

    final style = mapboxMap!.style;

    if (!await style.styleSourceExists(routeSourceId)) {
      await style.addSource(
        GeoJsonSource(id: routeSourceId, data: geoJsonString),
      );

      await style.addLayer(
        LineLayer(
          id: routeLayerId,
          sourceId: routeSourceId,
          lineColor: const Color(0xFF114BBE).value,
          lineWidth: 6,
          lineJoin: LineJoin.ROUND,
          lineCap: LineCap.ROUND,
        ),
      );
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// MAP (FIXED HEIGHT – ZOOM WORKS)
          SizedBox(
            height: height * 0.42,
            child: Stack(
              children: [
                MapWidget(
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  onMapCreated: _onMapCreated,
                ),

                /// BACK BUTTON
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// RIDE NOW + WOMEN ONLY
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 6),
                const Text("Ride Now",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Text("Women Only"),
                Switch(
                  value: womenOnly,
                  onChanged: (v) => setState(() => womenOnly = v),
                ),
              ],
            ),
          ),

          /// VEHICLE LIST (ONLY THIS SCROLLS)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _rideTile("Bike", "3min away · Drop 1.45 pm", "₹45", 0),
                _rideTile("Auto", "5min away · Drop 1.45 pm", "₹45", 1),
                _rideTile(
                    "Near by Grouping", "5min away · Drop 1.45 pm", "₹45", 2),
                _rideTile(
                    "Near by Grouping", "3min away · Drop 1.45 pm", "₹90", 3),
                _rideTile(
                  "Mini AC",
                  "1min away · Drop 1.45 pm",
                  "₹120",
                  4,
                  fastest: true,
                ),
                _rideTile(
                    "Mini Non AC", "3min away · Drop 1.45 pm", "₹90", 5),
              ],
            ),
          ),

          /// CASH / OFFERS (EXACT STYLE)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _chip(Icons.money, "CASH"),
                const SizedBox(width: 12),
                _chip(Icons.local_offer, "OFFERS"),
              ],
            ),
          ),

          /// BOOK RIDE BUTTON
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF114BBE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Book Ride",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- WIDGETS ----------------
  Widget _rideTile(String title, String subtitle, String price, int index,
      {bool fastest = false}) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fastest ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
            selected ? const Color(0xFF114BBE) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_car),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                      if (fastest)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "FASTEST",
                            style:
                            TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Text(price,
                style:
                const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(text,
                style:
                const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
