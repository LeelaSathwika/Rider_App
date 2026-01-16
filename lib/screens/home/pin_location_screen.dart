import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'dart:async';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
//
// class PinLocationScreen extends StatefulWidget {
//   const PinLocationScreen({super.key});
//
//   @override
//   State<PinLocationScreen> createState() => _PinLocationScreenState();
// }
//
// class _PinLocationScreenState extends State<PinLocationScreen> {
//   LatLng _center = const LatLng(17.3850, 78.4867);
//   String _pinnedAddr = "Loading address...";
//   final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
//   Timer? _timer;
//
//   void _onMove(MapCamera pos) {
//     if (_timer?.isActive ?? false) _timer!.cancel();
//     _timer = Timer(const Duration(milliseconds: 700), () async {
//       final res = await geoCoding.getAddress((lat: pos.center.latitude, long: pos.center.longitude));
//       res.fold((s) => setState(() {
//         _pinnedAddr = s.first.placeName ?? "";
//         _center = pos.center;
//       }), (f) => null);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Pin Location", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             options: MapOptions(
//               initialCenter: _center,
//               initialZoom: 15,
//               onPositionChanged: (p, g) => _onMove(p),
//             ),
//             children: [
//               TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
//             ],
//           ),
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 35),
//               child: Icon(Icons.location_on, color: AppColors.primaryBlue, size: 50),
//             ),
//           ),
//           Positioned(
//             bottom: 30, left: 20, right: 20,
//             child: Column(children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
//                 child: Row(children: [
//                   const Icon(Icons.location_on, color: Colors.red, size: 20),
//                   const SizedBox(width: 10),
//                   Expanded(child: Text(_pinnedAddr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2))
//                 ]),
//               ),
//               const SizedBox(height: 15),
//               buildPrimaryButton(
//                 text: "Confirm Pin Location",
//                 onPressed: () => Navigator.pop(context, _pinnedAddr),
//               ),
//             ]),
//           )
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


class PinLocationScreen extends StatefulWidget {
  const PinLocationScreen({super.key});

  @override
  State<PinLocationScreen> createState() => _PinLocationScreenState();
}

class _PinLocationScreenState extends State<PinLocationScreen> {
<<<<<<< HEAD
  // Starting coordinates (Hyderabad center)
  LatLng _center = const LatLng(17.3850, 78.4867);
  String _pinnedAddr = "Loading address...";
  
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  final MapController _mapController = MapController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 1. Fetch the address for the initial center point immediately
    _fetchAddress(_center);
  }

  @override
  void dispose() {
    // 2. CRITICAL: Cancel timer to prevent memory leaks/crashes
    _timer?.cancel();
    super.dispose();
  }

  // Helper function to turn LatLng into a readable string
  Future<void> _fetchAddress(LatLng position) async {
    final res = await geoCoding.getAddress(
      (lat: position.latitude, long: position.longitude),
    );
    res.fold((success) {
      if (success.isNotEmpty && mounted) {
        setState(() {
          _pinnedAddr = success.first.placeName ?? "Unknown Location";
        });
      }
    }, (failure) => null);
  }

  void _onMove(MapCamera pos, bool hasGesture) {
    // 3. Only update address if the USER is dragging the map
    if (!hasGesture) return;

    if (_timer?.isActive ?? false) _timer!.cancel();
    
    _timer = Timer(const Duration(milliseconds: 700), () {
      _fetchAddress(pos.center);
      setState(() {
        _center = pos.center;
      });
=======
  MapboxMap? _mapboxMap;
  Timer? _debounce;

  Point _centerPoint =
  Point(coordinates: Position(78.4867, 17.3850)); // Hyderabad

  String _pinnedAddr = "Loading address...";

  // ================= MAP CREATED =================
  void _onMapCreated(MapboxMap controller) async {
    _mapboxMap = controller;

    await _mapboxMap!.setCamera(
      CameraOptions(
        center: _centerPoint,
        zoom: 15,
      ),
    );
  }

  // ================= CAMERA CHANGE LISTENER =================
  void _onCameraChanged(CameraChangedEventData data) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 700), () async {
      final camera = await _mapboxMap!.getCameraState();
      final center = camera.center;

      _centerPoint = center;

      final double lat =
      (center.coordinates.lat as num).toDouble();
      final double lng =
      (center.coordinates.lng as num).toDouble();

      _reverseGeocode(lat, lng);
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019
    });
  }

  // ================= REVERSE GEOCODING =================
  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final List<Placemark> places =
      await placemarkFromCoordinates(lat, lng);

      if (places.isNotEmpty) {
        final p = places.first;

        setState(() {
          _pinnedAddr =
          "${p.name ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}";
        });
      }
    } catch (_) {}
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text("Set Pickup Location", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white, 
        elevation: 0,
=======
        title: const Text(
          "Pin Location",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
<<<<<<< HEAD
          // THE MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15,
              onPositionChanged: (p, g) => _onMove(p, g),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxToken',
                userAgentPackageName: 'com.example.flutter_application_rider',
              ),
            ],
          ),

          // FIXED CENTER PIN (Blue NexoRyd Style)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Icon(Icons.location_on, color: AppColors.primaryBlue, size: 50),
            ),
          ),

          // BOTTOM ADDRESS CARD
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1), 
                        child: const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 20)
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("PINNED LOCATION", 
                              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(_pinnedAddr, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // CONFIRM BUTTON
                  buildPrimaryButton(
                    text: "Confirm Location",
                    onPressed: () {
                      // Prevent returning the default "Loading..." text
                      if (_pinnedAddr != "Loading address...") {
                        Navigator.pop(context, _pinnedAddr);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
=======
          // ================= MAPBOX MAP =================
          MapWidget(
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
            onCameraChangeListener: _onCameraChanged,
          ),

          // ================= CENTER PIN =================
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: Icon(
                Icons.location_on,
                color: AppColors.primaryBlue,
                size: 50,
              ),
            ),
          ),

          // ================= BOTTOM CARD =================
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _pinnedAddr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                buildPrimaryButton(
                  text: "Confirm Pin Location",
                  onPressed: () =>
                      Navigator.pop(context, _pinnedAddr),
                ),
              ],
>>>>>>> e53c68027767e61c03ff3f45536a904ed71f7019
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
