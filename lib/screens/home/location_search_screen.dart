import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import '../../constants.dart';

class LocationSearchScreen extends StatefulWidget {
  final String title; // Pass "Pickup" or "Destination"
  const LocationSearchScreen({super.key, required this.title});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  
  List<mb.MapBoxPlace> _searchResults = [];
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // logic to fetch places as user types
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    // Debounce: Wait 600ms after user stops typing to call API (saves money/credits)
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      setState(() => _isLoading = true);
      
      final res = await geoCoding.getPlaces(query);
      
      res.fold(
        (success) => setState(() {
          _searchResults = success;
          _isLoading = false;
        }),
        (failure) => setState(() => _isLoading = false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Set ${widget.title}",
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 1. SEARCH INPUT FIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // Professional light grey
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search city, street or landmark",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: AppColors.primaryBlue),
                  suffixIcon: _searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchResults = []);
                        },
                      ) 
                    : null,
                ),
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading) const LinearProgressIndicator(color: AppColors.primaryBlue, minHeight: 2),

          const Divider(height: 1),

          // 2. SUGGESTIONS LIST
          Expanded(
            child: _searchResults.isEmpty && _searchController.text.length > 2 && !_isLoading
                ? _buildNoResults()
                : ListView.separated(
                    itemCount: _searchResults.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: const Icon(Icons.location_on_outlined, color: Colors.grey),
                        ),
                        title: Text(
                          place.text ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text(
                          place.placeName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        onTap: () {
                          // Return selected address string to previous screen
                          Navigator.pop(context, place.placeName);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("No locations found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}