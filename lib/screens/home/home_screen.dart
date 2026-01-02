import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';
import 'pickup_location_screen.dart';
import 'location_search_screen.dart'; // Import the new search screen

class HomeScreen extends StatefulWidget {
  final String address;
  final Function(String) onUpdate;
  const HomeScreen({super.key, required this.address, required this.onUpdate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isCashBackMode = false;
  
  // State for destination address
  String destinationAddress = "Enter Destination"; 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(17.3850, 78.4867),
            initialZoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
          ],
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                
                // 1. PICKUP TILE
                GestureDetector(
                  onTap: () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PickupLocationScreen()));
                    if (res != null) widget.onUpdate(res);
                  },
                  child: _buildTile(Icons.my_location, "PICK UP", widget.address, true),
                ),
                
                const SizedBox(height: 10),
                
                // 2. DESTINATION TILE (WHERE TO?) - Now Interactive
                GestureDetector(
                  onTap: () async {
                    final res = await Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const LocationSearchScreen(title: "Destination")
                      )
                    );
                    if (res != null) {
                      setState(() {
                        destinationAddress = res;
                      });
                    }
                  },
                  child: _buildTile(
                    Icons.search, 
                    "WHERE TO?", 
                    destinationAddress, 
                    destinationAddress != "Enter Destination" // Show edit if address is selected
                  ),
                ),
                
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(children: [
                      const Text("Cash Back Mode", style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                      const SizedBox(width: 8),
                      CupertinoSwitch(
                        value: isCashBackMode,
                        activeColor: AppColors.primaryBlue,
                        onChanged: (v) => setState(() => isCashBackMode = v),
                      )
                    ])
                  ],
                ),
                const SizedBox(height: 15),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _svcItem("Bike", "1 Person", Icons.directions_bike),
                    _svcItem("Auto", "3 Persons", Icons.electric_rickshaw),
                    _svcItem("Car", "4 Seater", Icons.directions_car),
                    _svcItem("Car", "6 Seater", Icons.airport_shuttle),
                    _svcItem("Pillion", "Sharing", Icons.moped),
                    _svcItem("Corp Ride", "6 Seater", Icons.business_center),
                  ],
                ),
                const SizedBox(height: 15),
                _parcelCard(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTile(IconData i, String l, String v, bool edit) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
    child: Row(children: [
      Icon(i, color: AppColors.primaryBlue),
      const SizedBox(width: 15),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(v, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
      ])),
      if (edit) const Text("Edit", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold))
    ]),
  );

  Widget _svcItem(String t, String s, IconData i) => Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(12)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(i, color: Colors.blueGrey, size: 30),
        Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(s, style: const TextStyle(color: Colors.grey, fontSize: 10))
      ],
    ),
  );

  Widget _parcelCard() => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
    child: Row(children: [
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Parcel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text("Max 4kgs", style: TextStyle(color: Colors.grey, fontSize: 12))
      ]),
      const Spacer(),
      Container(
        width: 70, height: 60,
        decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.inventory_2, color: Colors.orange, size: 40),
      ),
    ]),
  );
}