import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  final String firstPlaceLatLong;
  final String secondPlaceLatLong;

  MapScreen({required this.firstPlaceLatLong, required this.secondPlaceLatLong});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  late LatLng _origin;
  late LatLng _destination;

  @override
  void initState() {
    super.initState();
    _getLatLngForPlaces();
    _createPolylines();
  }

  // Parse the LatLng strings and create LatLng objects
  void _getLatLngForPlaces() {
    List<String> firstLatLng = widget.firstPlaceLatLong
        .replaceAll("LatLng(", "")
        .replaceAll(")", "")
        .split(",");

    List<String> secondLatLng = widget.secondPlaceLatLong
        .replaceAll("LatLng(", "")
        .replaceAll(")", "")
        .split(",");

    _origin = LatLng(double.parse(firstLatLng[0]), double.parse(firstLatLng[1]));
    _destination = LatLng(double.parse(secondLatLng[0]), double.parse(secondLatLng[1]));
  }

  // Create polyline between origin and destination
  void _createPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAvgyK0kIGtLwJ8jKPTdrb7cJRrgFAimKc", // Replace with your Google Maps API Key
      PointLatLng(_origin.latitude, _origin.longitude),
      PointLatLng(_destination.latitude, _destination.longitude),
      travelMode: TravelMode.driving, // Specify travel mode (driving, walking, etc.)
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));

        print('polylineCoordinates-$polylineCoordinates');
        print('polyline-$polylineCoordinates');
      }
    }

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 6,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route on Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _origin,
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        polylines: _polylines,
        markers: {
          Marker(
            markerId: const MarkerId('origin'),
            position: _origin,
            infoWindow: const InfoWindow(title: "Origin"),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: _destination,
            infoWindow: const InfoWindow(title: "Destination"),
          ),
        },
      ),
    );
  }
}
