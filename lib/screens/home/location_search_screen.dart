import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'dart:async';
import '../../constants.dart';

class LocationSearchScreen extends StatefulWidget {
  final String title;
  const LocationSearchScreen({super.key, required this.title});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  List<mb.MapBoxPlace> _searchResults = [];
  Timer? _debounce;
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  final TextEditingController _searchController = TextEditingController();

  // This function runs every time a letter is typed
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Debounce waits for user to stop typing for 600ms before calling API (saves money/hits)
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.length > 2) {
        final res = await geoCoding.getPlaces(query);
        res.fold(
          (success) => setState(() => _searchResults = success),
          (failure) => null,
        );
      } else {
        setState(() => _searchResults = []);
      }
    });
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Set ${widget.title}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: AppColors.primaryBlue),
                  hintText: "Enter ${widget.title} address",
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20), 
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchResults = []);
                        }
                      ) 
                    : null,
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // Real-time Results List
          Expanded(
            child: _searchResults.isEmpty && _searchController.text.length > 2
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined, color: AppColors.textGray),
                        title: Text(
                          place.text ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          place.placeName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Return selected address back to Home Screen
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
}