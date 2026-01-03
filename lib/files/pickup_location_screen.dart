import 'package:flutter/material.dart';

class PickupLocationScreen extends StatelessWidget {
  const PickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pickup Location",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// SEARCH FIELD
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "Search for location",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// QUICK ACTIONS
            Row(
              children: [
                _actionButton(
                  icon: Icons.my_location,
                  title: "Current Location",
                  subtitle: "Use current location",
                ),
                const SizedBox(width: 12),
                _actionButton(
                  icon: Icons.location_on,
                  title: "Locate on Map",
                  subtitle: "Pin your location",
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// RECENT SEARCHES
            const Text(
              "RECENT SEARCHES",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            _locationTile(
              icon: Icons.history,
              title: "Secunderabad, Hyderabad",
              subtitle: "5th Block, Road No-14, Secunderabad, Hyderabad",
              distance: "2.2 km",
            ),
            _locationTile(
              icon: Icons.history,
              title: "Tech Mahendra Office",
              subtitle: "Block 7, Kukatpally, Hyderabad",
              distance: "2.6 km",
            ),
            _locationTile(
              icon: Icons.history,
              title: "Pista House",
              subtitle:
              "Door No - 47/333/A, Block 7, Kukatpally, Main Junction",
              distance: "2.6 km",
            ),

            const SizedBox(height: 24),

            /// SAVED ADDRESS
            const Text(
              "SAVED ADDRESS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            _locationTile(
              icon: Icons.home,
              title: "Home",
              subtitle: "5th Block, Road No-14, Secunderabad, Hyderabad",
              distance: "4.7 km",
            ),
            _locationTile(
              icon: Icons.work,
              title: "Work",
              subtitle: "Block 7, Kukatpally, Hyderabad",
              distance: "8.6 km",
            ),
            _locationTile(
              icon: Icons.place,
              title: "Friends Home",
              subtitle:
              "Door No - 47/333/A, Block 7, Kukatpally, Main Junction",
              distance: "9 km",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ACTION BUTTON
  static Widget _actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// LOCATION TILE
  static Widget _locationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF4F6F9),
            child: Icon(icon, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            distance,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
