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
  Timer? _debounce;
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.length > 2) {
        final res = await geoCoding.getPlaces(query);
        res.fold((s) => setState(() => _searchResults = s), (f) => null);
      } else {
        setState(() => _searchResults = []);
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    bool s = await Geolocator.isLocationServiceEnabled();
    if (!s) return;
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied) return;

    final pos = await Geolocator.getCurrentPosition();
    final res = await geoCoding.getAddress((lat: pos.latitude, long: pos.longitude));
    res.fold((success) => Navigator.pop(context, success.first.placeName), (f) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pickup Location", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0.5, iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(icon: Icon(Icons.search, color: Colors.grey), hintText: "Search for location", border: InputBorder.none),
              ),
            ),
          ),
          if (_searchResults.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _act(Icons.my_location, "Current Location", _getCurrentLocation),
                const SizedBox(width: 20),
                _act(Icons.location_on, "Locate on Map", () async {
                  final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PinLocationScreen()));
                  if (res != null) Navigator.pop(context, res);
                }),
              ]),
            ),
            const Divider(height: 40),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, i) => ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                title: Text(_searchResults[i].text ?? ""),
                subtitle: Text(_searchResults[i].placeName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.pop(context, _searchResults[i].placeName),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _act(IconData i, String t, VoidCallback tap) => Expanded(
    child: GestureDetector(
      onTap: tap,
      child: Row(children: [
        CircleAvatar(radius: 18, backgroundColor: AppColors.primaryBlue.withOpacity(0.08), child: Icon(i, color: AppColors.primaryBlue, size: 18)),
        const SizedBox(width: 8),
        Flexible(child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))
      ]),
    ),
  );
}