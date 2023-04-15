import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;

  const MapScreen(
      {Key? key, required this.startLocation, required this.endLocation})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<LatLng> _routeCoords = [];

  @override
  void initState() {
    super.initState();
    _getDirections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: widget.startLocation,
          zoom: 14.0,
        ),
        markers: _createMarkers(),
        polylines: _createPolylines(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('startLocation'),
        position: widget.startLocation,
      ),
      Marker(
        markerId: MarkerId('endLocation'),
        position: widget.endLocation,
      ),
    };
  }

  Set<Polyline> _createPolylines() {
    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: _routeCoords,
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  Future<void> _getDirections() async {
    final apiKey = 'AIzaSyCY8J7h0Q-5Q1UDP9aY0EOy_WZBPESNBBg';
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.startLocation.latitude},${widget.startLocation.longitude}&destination=${widget.endLocation.latitude},${widget.endLocation.longitude}&mode=driving&key=${apiKey}';

    final response = await http.get(Uri.parse(apiUrl));
    final responseBody = json.decode(response.body);

    if (responseBody['status'] == 'OK') {
      final List<LatLng> coords = _convertToLatLng(
          responseBody['routes'][0]['overview_polyline']['points']);
      setState(() {
        _routeCoords = coords;
      });
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> _convertToLatLng(String encoded) {
    List<dynamic> points = PolylinePoints().decodePolyline(encoded);

    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}
