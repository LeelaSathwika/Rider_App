import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';

class PinLocationScreen extends StatefulWidget {
  const PinLocationScreen({super.key});

  @override
  State<PinLocationScreen> createState() => _PinLocationScreenState();
}

class _PinLocationScreenState extends State<PinLocationScreen> {
  // Coordinates for initial view (e.g., Hyderabad)
  LatLng _mapCenter = const LatLng(17.3850, 78.4867);
  String _pinnedAddr = "Select location on map";
  
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  List<mb.MapBoxPlace> _searchResults = [];
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch address for the default center immediately
    _fetchAddressFromCoords(_mapCenter);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // ================= 1. GEOCODING LOGIC =================

  // REVERSE: Coordinates -> Address (When dragging map)
  Future<void> _fetchAddressFromCoords(LatLng position) async {
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

  // FORWARD: Search Text -> Suggestions (When typing)
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      setState(() => _isSearching = true);
      final res = await geoCoding.getPlaces(query);
      res.fold(
        (success) => setState(() {
          _searchResults = success;
          _isSearching = false;
        }),
        (failure) => setState(() => _isSearching = false),
      );
    });
  }

  // ================= 2. INTERACTION HANDLERS =================

  // When map is dragged
  void _handleMapMove(MapCamera pos, bool hasGesture) {
    if (!hasGesture) return; // Only trigger if user moves it, not code

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _fetchAddressFromCoords(pos.center);
      setState(() {
        _mapCenter = pos.center;
      });
    });
  }

  // When a search result is clicked
  void _onSuggestionSelected(mb.MapBoxPlace place) {
    final coords = place.geometry?.coordinates;
    if (coords != null) {
      final newLatLng = LatLng(coords.lat, coords.long);
      
      // Move map focus to searched location
      _mapController.move(newLatLng, 16);
      
      setState(() {
        _pinnedAddr = place.placeName ?? "";
        _mapCenter = newLatLng;
        _searchResults = []; // Hide search list
        _searchController.clear();
        FocusScope.of(context).unfocus(); // Close keyboard
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Pin Location", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white, 
        elevation: 0,
      ),
      body: Stack(
        children: [
          // THE MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _mapCenter,
              initialZoom: 15,
              onPositionChanged: (p, g) => _handleMapMove(p, g),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxToken',
                userAgentPackageName: 'com.example.flutter_application_rider',
              ),
            ],
          ),

          // THE FIXED BLUE PIN (Center of screen)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35), 
              child: Icon(Icons.location_on, color: AppColors.primaryBlue, size: 50),
            ),
          ),

          // FLOATING SEARCH BAR & RESULTS
          Positioned(
            top: 20, left: 20, right: 20,
            child: Column(
              children: [
                // Floating Box
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: const InputDecoration(
                            hintText: "Search location",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_isSearching) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ],
                  ),
                ),
                
                // Search Suggestions List
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    constraints: const BoxConstraints(maxHeight: 250),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined, size: 20),
                          title: Text(place.text ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(place.placeName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                          onTap: () => _onSuggestionSelected(place),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // BOTTOM CONFIRMATION CARD
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1), 
                        child: const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 22)
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("SELECTED LOCATION", 
                              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text(_pinnedAddr, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), 
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  buildPrimaryButton(
                    text: "Confirm Pin Location",
                    onPressed: () {
                      if (_pinnedAddr != "Fetching address..." && _pinnedAddr != "Select location on map") {
                        Navigator.pop(context, _pinnedAddr);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}