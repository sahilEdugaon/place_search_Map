// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapSearchWidget extends StatefulWidget {
//   const MapSearchWidget({super.key});
//
//   @override
//   _MapSearchWidgetState createState() => _MapSearchWidgetState();
// }
//
// class _MapSearchWidgetState extends State<MapSearchWidget> {
//   final TextEditingController _firstController = TextEditingController();
//   final TextEditingController _secondController = TextEditingController();
//   GoogleMapController? _mapController;
//   LatLng? _currentPosition;
//
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return; // Location services are not enabled, don't continue
//     }
//
//     // Request location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return; // Permission denied, don't continue
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return; // Permissions are denied forever, don't continue
//     }
//
//     // Get the current position
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//     });
//
//     // Move the map camera to the current position
//     if (_mapController != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: _currentPosition!, zoom: 15.0),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Map Widget
//         // Google Map Widget
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: _currentPosition ?? LatLng(25.276987, 55.296249), // Default location
//             zoom: 15.0,
//           ),
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//             if (_currentPosition != null) {
//               _mapController!.animateCamera(
//                 CameraUpdate.newCameraPosition(
//                   CameraPosition(target: _currentPosition!, zoom: 15.0),
//                 ),
//               );
//             }
//           },
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//         ),
//         // Search Overlay
//         Positioned(
//           top: 50.0,
//           left: 10.0,
//           right: 10.0,
//           child: _buildSearchOverlay(),
//         ),
//         // Next Button
//         Positioned(
//           bottom: 20.0,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
//                 backgroundColor: Colors.deepPurple,
//               ),
//               child: Text('Next', style: TextStyle(fontSize: 18.0,color: Colors.white)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSearchOverlay() {
//     return Card(
//       elevation: 5.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildTextField(
//               controller: _firstController,
//               labelText: 'Al Nahda 1',
//               icon: Icons.my_location,
//               iconColor: Colors.blueAccent,
//               dotColor: Colors.green,
//             ),
//             SizedBox(height: 10),
//             _buildTextField(
//               controller: _secondController,
//               labelText: '2130 St - Port Saeed, Dubai',
//               subLabelText: 'United Arab Emirates',
//               icon: Icons.search,
//               iconColor: Colors.black54,
//               dotColor: Colors.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     String? subLabelText,
//     required IconData icon,
//     required Color iconColor,
//     required Color dotColor,
//   }) {
//     return Row(
//       children: [
//         Column(
//           children: [
//             _buildDot(dotColor),
//             _buildVerticalDottedLine(),
//           ],
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: controller,
//                   decoration: InputDecoration(
//                     labelText: labelText,
//                     suffixIcon: Icon(icon, color: iconColor),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                 ),
//                 if (subLabelText != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: Text(
//                       subLabelText,
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDot(Color color) {
//     return Container(
//       width: 10,
//       height: 10,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
//
//   Widget _buildVerticalDottedLine() {
//     return Container(
//       height: 30,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(3, (index) => _buildDot(Colors.grey[400]!)),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _firstController.dispose();
//     _secondController.dispose();
//     super.dispose();
//   }
// }
