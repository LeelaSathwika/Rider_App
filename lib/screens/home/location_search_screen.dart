import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'dart:async';
import '../../constants.dart';
import 'pin_location_screen.dart';

class LocationSearchScreen extends StatefulWidget {
  final String title; // "Pickup" or "Destination"
  final String currentPickup; // Shows the current pickup in the top card

  const LocationSearchScreen({
    super.key,
    required this.title,
    required this.currentPickup,
  });

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  List<mb.MapBoxPlace> _searchResults = [];
  Timer? _debounce;
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // 1. Search Logic: Fetches results from Mapbox as you type
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

  // 2. Logic for "Current Location" Button
  Future<void> _useCurrentLocation() async {
    setState(() => _isSearching = true);
    try {
      Position pos = await Geolocator.getCurrentPosition();
      final res = await geoCoding.getAddress((lat: pos.latitude, long: pos.longitude));
      res.fold((success) {
        if (success.isNotEmpty) {
          Navigator.pop(context, success.first.placeName);
        }
      }, (f) => null);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
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
        title: Text(widget.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ROUTE INPUT CARD (Timeline UI)
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                // Vertical Timeline Dots and Line
                Column(
                  children: [
                    const Icon(Icons.radio_button_checked, color: Colors.green, size: 20),
                    Container(width: 1, height: 30, color: Colors.black12),
                    const Icon(Icons.radio_button_checked, color: Colors.red, size: 20),
                  ],
                ),
                const SizedBox(width: 15),
                // Text Fields
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.currentPickup,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(height: 30, color: Colors.black12),
                      TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Enter destination",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. QUICK ACTIONS (Horizontal Row)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildQuickAction(
                  icon: Icons.my_location,
                  title: "Current Location",
                  subtitle: "Use current location",
                  onTap: _useCurrentLocation,
                ),
                const SizedBox(width: 15),
                _buildQuickAction(
                  icon: Icons.location_on,
                  title: "Locate on Map",
                  subtitle: "Pin you location",
                  onTap: () async {
                    final res = await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (c) => const PinLocationScreen())
                    );
                    if (res != null) Navigator.pop(context, res);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          const Divider(thickness: 6, color: Color(0xFFF3F4F6)),

          // 3. RESULTS LIST (Search results or Recent/Saved)
          Expanded(
            child: _searchController.text.isNotEmpty 
              ? _buildSearchResults() 
              : _buildRecentAndSaved(),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildQuickAction({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF0F7FF),
              child: Icon(icon, color: AppColors.primaryBlue, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAndSaved() {
    return ListView(
      children: [
        _sectionHeader("RECENT SEARCHES"),
        _locationTile("Secunderabad, Hyderabad", "5th Block, Road No-14, Secunderabad", "2.2 km", Icons.access_time),
        _locationTile("Tech Mahendra Office", "Block 7, Kukatpally, Hyderabad", "2.6 km", Icons.access_time),
        _locationTile("Pista House", "Door No - 47/333/A, Block 7, Kukatpally", "2.6 km", Icons.access_time),
        
        const SizedBox(height: 10),
        _sectionHeader("SAVED ADDRESS"),
        _locationTile("Home", "5th Block, Road No-14, Secunderabad", "4.7 km", Icons.home_outlined),
        _locationTile("Work", "Block 7, Kukatpally, Hyderabad", "8.6 km", Icons.work_outline),
        _locationTile("Friends Home", "Door No - 47/333/A, Block 7, Kukatpally", "9 km", Icons.person_outline),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, i) => ListTile(
        leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
        title: Text(_searchResults[i].text ?? ""),
        subtitle: Text(_searchResults[i].placeName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () => Navigator.pop(context, _searchResults[i].placeName),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
    );
  }

  Widget _locationTile(String title, String sub, String dist, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF3F4F6), 
        child: Icon(icon, color: Colors.grey, size: 20)
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(dist, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      onTap: () => Navigator.pop(context, title),
    );
  }
}