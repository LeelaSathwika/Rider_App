import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';
import 'ride_booking_screen.dart'; // IMPORTANT IMPORT

class ScheduleRideScreen extends StatefulWidget {
  const ScheduleRideScreen({super.key});

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  bool isWomenOnly = false;

  final List<String> days = ["Thu, 1 Jan", "Fri, 2 Jan", "Sat, 3 Jan", "Sun, 4 Jan", "Mon, 5 Jan"];
  final List<String> hours = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
  final List<String> minutes = ["00", "15", "30", "45"];
  final List<String> periods = ["AM", "PM"];

  int selectedDay = 2;
  int selectedHour = 3;
  int selectedMin = 1;
  int selectedPeriod = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(17.3850, 78.4867),
              initialZoom: 14,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            ],
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              color: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  _buildHeaderToggles(),
                  _buildSelectionText(),
                  const SizedBox(height: 20),
                  
                  // LIVE SCROLLING WHEELS
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F7FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _buildWheel(days, selectedDay, (i) => setState(() => selectedDay = i), flex: 3),
                            _buildWheel(hours, selectedHour, (i) => setState(() => selectedHour = i)),
                            const Center(child: Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                            _buildWheel(minutes, selectedMin, (i) => setState(() => selectedMin = i)),
                            _buildWheel(periods, selectedPeriod, (i) => setState(() => selectedPeriod = i)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // THE ACTION BUTTON (Confirm & Navigate)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: buildPrimaryButton(
                      text: "Confirm & Schedule",
                      onPressed: () {
                        // GO TO RIDE BOOKING
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RideBookingScreen(
                              pickup: "5th Block, Road No-14, Indiranagar, Hyderabad", 
                              destination: "Koramangala",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWheel(List<String> items, int selectedValue, ValueChanged<int> onChanged, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: selectedValue),
        itemExtent: 50,
        diameterRatio: 1.2,
        onSelectedItemChanged: onChanged,
        selectionOverlay: const SizedBox(),
        children: items.map((item) => Center(
          child: Text(
            item,
            style: TextStyle(
              fontSize: 18,
              fontWeight: items.indexOf(item) == selectedValue ? FontWeight.bold : FontWeight.normal,
              color: items.indexOf(item) == selectedValue ? Colors.black : Colors.grey.shade400,
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildHeaderToggles() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(children: [Icon(Icons.access_time, size: 20), SizedBox(width: 8), Text("Ride Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Icon(Icons.keyboard_arrow_down)]),
          Row(children: [
            const Text("Women Only", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            CupertinoSwitch(value: isWomenOnly, activeColor: AppColors.primaryBlue, onChanged: (v) => setState(() => isWomenOnly = v)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSelectionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Schedule Ride", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 15),
                children: [
                  const TextSpan(text: "You have selected "),
                  TextSpan(
                    text: "${days[selectedDay]}, ${hours[selectedHour]}:${minutes[selectedMin]} ${periods[selectedPeriod]}",
                    style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}