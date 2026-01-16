import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'dart:async';
import '../../constants.dart';
import 'pin_location_screen.dart';

class PickupLocationScreen extends StatefulWidget {
  const PickupLocationScreen({super.key});

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  List<mb.MapBoxPlace> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel any pending search tasks
    _searchController.dispose();
    super.dispose();
  }

  // 1. Helper to return the address and CLOSE the screen correctly
  void _selectAndReturn(String address) {
    _debounce?.cancel(); // Stop any pending API calls immediately
    Navigator.pop(context, address); // Send address back to Home Screen
  }

  // 2. Search as you type
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.length > 2) {
        final res = await geoCoding.getPlaces(query);
        res.fold((s) {
          if (mounted) setState(() => _searchResults = s);
        }, (f) => null);
      } else {
        if (mounted) setState(() => _searchResults = []);
      }
    });
  }

  // 3. Working Current Location Logic
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final res = await geoCoding.getAddress((lat: pos.latitude, long: pos.longitude));

      res.fold((success) {
        if (success.isNotEmpty) {
          // Instead of showing it in the list, we return it IMMEDIATELY 
          // to prevent background GPS overwrites.
          _selectAndReturn(success.first.placeName ?? "");
        }
      }, (failure) => debugPrint("Geocoding failed"));

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pickup Location", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, 
        elevation: 0.5, 
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey), 
                  hintText: "Search for location", 
                  border: InputBorder.none
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _act(Icons.my_location, "Current Location", _getCurrentLocation),
                const SizedBox(width: 20),
                _act(Icons.location_on, "Locate on Map", () async {
                  final res = await Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const PinLocationScreen()));
                  if (res != null) {
                    _selectAndReturn(res); // Return result from Pin Screen
                  }
                }),
              ],
            ),
          ),

          const Divider(height: 40),

          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, i) {
                    final place = _searchResults[i];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                      title: Text(place.text ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(place.placeName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => _selectAndReturn(place.placeName ?? ""),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _act(IconData i, String t, VoidCallback tap) => Expanded(
    child: GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(i, color: AppColors.primaryBlue, size: 18),
            const SizedBox(width: 8),
            Flexible(child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))
          ]
        ),
      ),
    ),
  );
}