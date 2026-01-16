import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'dart:async';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
import 'ride_verified_screen.dart';

class ChangeDropLocationScreen extends StatefulWidget {
  final String pickup; // Receives the original user-entered pickup location

  const ChangeDropLocationScreen({super.key, required this.pickup});

  @override
  State<ChangeDropLocationScreen> createState() => _ChangeDropLocationScreenState();
}

class _ChangeDropLocationScreenState extends State<ChangeDropLocationScreen> {
  LatLng _mapCenter = const LatLng(17.3850, 78.4867); // Default: Hyderabad center
  String _selectedAddress = "Fetching address...";
  
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  
  List<mb.MapBoxPlace> _searchResults = [];
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch address for the starting map center immediately
    _fetchAddressFromCoords(_mapCenter);
  }

  // Helper: Reverse Geocoding using new Mapbox 4.x.x Record syntax
  Future<void> _fetchAddressFromCoords(LatLng pos) async {
    final res = await geoCoding.getAddress(
      (lat: pos.latitude, long: pos.longitude), // New Record syntax
    );
    res.fold((success) {
      if (success.isNotEmpty && mounted) {
        setState(() {
          _selectedAddress = success.first.placeName ?? "Unknown location";
        });
      }
    }, (failure) => null);
  }

  // Forward Geocoding: Autocomplete Search
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() { _searchResults = []; _isSearching = false; });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      setState(() => _isSearching = true);
      final res = await geoCoding.getPlaces(query);
      res.fold(
        (success) => setState(() { _searchResults = success; _isSearching = false; }),
        (failure) => setState(() => _isSearching = false),
      );
    });
  }

  // Reverse Geocoding when the user drags the map (Pinning)
  void _onMapCameraMove(MapCamera camera) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _fetchAddressFromCoords(camera.center);
      setState(() => _mapCenter = camera.center);
    });
  }

  // Selecting a result from the autocomplete list
  void _selectSearchResult(mb.MapBoxPlace place) {
    final coords = place.geometry?.coordinates;
    if (coords != null) {
      // Latest Mapbox Record access: coords.lat and coords.long
      final newLatLng = LatLng(coords.lat, coords.long); 
      _mapController.move(newLatLng, 15);
      setState(() {
        _selectedAddress = place.placeName ?? "";
        _mapCenter = newLatLng;
        _searchResults = [];
        _searchController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text("Change Drop Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white, elevation: 0,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.black12, height: 1)),
      ),
      body: Stack(
        children: [
          // 1. THE INTERACTIVE MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _mapCenter,
              initialZoom: 15,
              onPositionChanged: (pos, hasGesture) {
                if (hasGesture) _onMapCameraMove(pos);
              },
            ),
            children: [TileLayer(
              urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxToken',
              additionalOptions: {
                'accessToken': mapboxToken,
                'id': 'mapbox.mapbox-streets-v12',
              },
              // Ensure this matches your package name from build.gradle
              userAgentPackageName: 'com.example.flutter_application_rider',
            
          ),],
          ),

          // 2. THE CENTER PIN (Fixed)
          Center(child: Padding(padding: const EdgeInsets.only(bottom: 35), child: Icon(Icons.location_on, color: AppColors.primaryBlue, size: 50))),

          // 3. FLOATING SEARCH BAR & RESULTS
          Positioned(
            top: 20, left: 20, right: 20,
            child: Column(
              children: [
                Container(
                  height: 55, padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: _searchController, onChanged: _onSearchChanged, decoration: const InputDecoration(hintText: "Search location", border: InputBorder.none))),
                      if (_isSearching) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ],
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    constraints: const BoxConstraints(maxHeight: 280),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.location_on_outlined, size: 20),
                        title: Text(_searchResults[index].text ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(_searchResults[index].placeName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        onTap: () => _selectSearchResult(_searchResults[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 4. BOTTOM CONFIRMATION CARD
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 24),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text("SELECTED LOCATION", style: TextStyle(color: AppColors.textGray, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(_selectedAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  buildPrimaryButton(
                    text: "Confirm Location", 
                    onPressed: () {
                      // Navigate to Verified Screen with both Original Pickup and New Destination
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => RideVerifiedScreen(
                            pickup: widget.pickup, 
                            destination: _selectedAddress,
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}