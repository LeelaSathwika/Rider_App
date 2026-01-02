import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart' as mb;
import 'dart:async';
import '../../constants.dart';
import '../../widgets/shared_widgets.dart';

class PinLocationScreen extends StatefulWidget {
  const PinLocationScreen({super.key});

  @override
  State<PinLocationScreen> createState() => _PinLocationScreenState();
}

class _PinLocationScreenState extends State<PinLocationScreen> {
  LatLng _center = const LatLng(17.3850, 78.4867);
  String _pinnedAddr = "Loading address...";
  final mb.GeoCoding geoCoding = mb.GeoCoding(apiKey: mapboxToken);
  Timer? _timer;

  void _onMove(MapCamera pos) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 700), () async {
      final res = await geoCoding.getAddress((lat: pos.center.latitude, long: pos.center.longitude));
      res.fold((s) => setState(() {
        _pinnedAddr = s.first.placeName ?? "";
        _center = pos.center;
      }), (f) => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pin Location", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15,
              onPositionChanged: (p, g) => _onMove(p),
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            ],
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: Icon(Icons.location_on, color: AppColors.primaryBlue, size: 50),
            ),
          ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                child: Row(children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_pinnedAddr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2))
                ]),
              ),
              const SizedBox(height: 15),
              buildPrimaryButton(
                text: "Confirm Pin Location",
                onPressed: () => Navigator.pop(context, _pinnedAddr),
              ),
            ]),
          )
        ],
      ),
    );
  }
}