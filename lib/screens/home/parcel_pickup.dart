import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart'; // Ensure buildPrimaryButton is here
import 'pickup_location_screen.dart';
import 'location_search_screen.dart';
import 'parcel_ride_booking_screen.dart';
class ParcelPickupScreen extends StatefulWidget {
  const ParcelPickupScreen({super.key});

  @override
  State<ParcelPickupScreen> createState() => _ParcelPickupScreenState();
}

class _ParcelPickupScreenState extends State<ParcelPickupScreen> {
  bool isEmergency = false;
  String pickupAddress = "Current Location";
  String dropAddress = "Enter drop address";

  // ==========================================
  // 1. ADD DELIVERY DETAILS BOTTOM SHEET
  // ==========================================
  void _showDeliveryDetailsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to expand when keyboard opens
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Keyboard padding
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Add Delivery Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    
                    _fieldLabel("Full Name"),
                    _customTextField(Icons.person_outline, "Enter your name"),
                    
                    const SizedBox(height: 20),
                    _fieldLabel("Mobile Number"),
                    _customTextField(Icons.phone_outlined, "Enter 10 digit mobile number", isPhone: true),
                    
                    const SizedBox(height: 20),
                    _fieldLabel("Parcel Type"),
                    _customTextField(Icons.inventory_2_outlined, "Select type", isDropdown: true),
                    
                    const SizedBox(height: 20),
                    _fieldLabel("Parcel Description"),
                    _customTextField(Icons.description_outlined, "Enter description"),
                    
                    const SizedBox(height: 20),
                    _fieldLabel("Save as"),
                    _customTextField(null, "Example: “Office”"),
                    
                    const SizedBox(height: 40),
                    
                    // ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primaryBlue),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text("Back", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Logic to proceed with booking
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParcelRideBookingScreen(
                                    pickup: pickupAddress,
                                    destination: dropAddress,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            child: const Text("Confirm Drop", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        title: const Text("Parcel", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildEmergencyToggle(),
          const SizedBox(height: 20),
          _buildPickupCard(),
          const SizedBox(height: 15),
          _buildDropCard(),
          const SizedBox(height: 30),
          _buildSectionHeader("RECENT SEARCHES"),
          _buildLocationTile("Secunderabad, Hyderabad", "5th Block, Road No-14", "2.2 km", Icons.access_time),
          _buildLocationTile("Tech Mahendra Office", "Block 7, Kukatpally", "2.6 km", Icons.access_time),
          const SizedBox(height: 20),
          _buildSectionHeader("SAVED ADDRESS"),
          _buildLocationTile("Home", "Indiranagar, Hyderabad", "4.7 km", Icons.home_outlined),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15)),
    );
  }

  Widget _customTextField(IconData? icon, String hint, {bool isPhone = false, bool isDropdown = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        readOnly: isDropdown,
        decoration: InputDecoration(
          prefixIcon: isPhone 
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.phone_outlined, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text("+91", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                ],
              )
            : (icon != null ? Icon(icon, color: Colors.grey, size: 20) : null),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        ),
      ),
    );
  }

  Widget _buildPickupCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: const Color(0xFFF0F4FF), child: Icon(Icons.my_location, color: AppColors.primaryBlue, size: 20)),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("PICK UP", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(pickupAddress, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ])),
              TextButton(
                onPressed: () async {
                   final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const PickupLocationScreen()));
                   if (res != null) setState(() => pickupAddress = res);
                },
                style: TextButton.styleFrom(backgroundColor: const Color(0xFFF0F4FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("Edit", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 55), child: Text("Deepu   9987765443", style: TextStyle(color: Colors.grey, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildDropCard() {
    return GestureDetector(
      onTap: () async {
        final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => LocationSearchScreen(title: "Drop Location", currentPickup: pickupAddress)));
        if (res != null) {
          setState(() => dropAddress = res);
          _showDeliveryDetailsSheet(); // 👉 AUTO-SHOW BOTTOM SHEET
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: const Color(0xFFF0F4FF), child: const Icon(Icons.search, color: AppColors.primaryBlue, size: 20)),
            const SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("WHERE TO?", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(dropAddress, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: dropAddress.contains("Enter") ? Colors.grey : Colors.black)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withOpacity(0.05))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text("Emergency", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        CupertinoSwitch(value: isEmergency, activeTrackColor: AppColors.primaryBlue, onChanged: (v) => setState(() => isEmergency = v))
      ]),
    );
  }

  Widget _buildSectionHeader(String t) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)));

  Widget _buildLocationTile(String title, String sub, String dist, IconData icon) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(backgroundColor: const Color(0xFFF3F4F6), child: Icon(icon, color: Colors.grey, size: 20)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    subtitle: Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 13)),
    trailing: Text(dist, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    onTap: () {
      setState(() => dropAddress = title);
      _showDeliveryDetailsSheet(); // 👉 AUTO-SHOW BOTTOM SHEET
    },
  );
}