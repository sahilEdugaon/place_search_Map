import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'mapScreen.dart';

class LocationSearchWidget extends StatefulWidget {
  const LocationSearchWidget({super.key});

  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  List<String> placeSuggestions = [];
  LatLng? firstLocation;
  LatLng? secondLocation;
  GoogleMapController? mapController;
  bool _isFirstFieldActive = true; // To track which text field is active

  var uuid =  const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    // _firstController.addListener(() {
    //   _onChanged();
    // });
  }


  _onChanged(String input) {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(input);
  }

  void getSuggestion(String input) async {

    print('getSuggestion');
    const String PLACES_API_KEY = "AIzaSyAvgyK0kIGtLwJ8jKPTdrb7cJRrgFAimKc";

    try{
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    }catch(e){
      print('getSuggestion-$e');
    }

  }

  Future<void> _getPlaceSuggestions(String input) async {
    String apiKey = "AIzaSyAvgyK0kIGtLwJ8jKPTdrb7cJRrgFAimKc";
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseUrl?input=$input&key=$apiKey&types=geocode';

    print('input-$input');
    print(request);
    try {
      Response response = await Dio().get(request);

      if (response.data['status'] == 'OK') {
        List predictions = response.data['predictions'];
        print('predictions-$predictions');
        setState(() {
          placeSuggestions = predictions.map<String>((prediction) {
            return prediction['description'];
          }).toList();
        });
      } else {
        print('Error: ${response.data['status']}');
      }
    } catch (e) {
      print('Error fetching place suggestions: $e');
    }
  }

  Future<void> _getFirstPlaceLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      print('locations-$locations');
      if (locations.isNotEmpty) {
        Location location = locations.first;
        print('location-$location');
        firstLocation = LatLng(location.latitude, location.longitude);
        print('firstLocation-$firstLocation');

        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLngZoom(firstLocation!, 14.0));

          setState(() {
            _placeList = [];
          });
        }
      } else {
        print('No location found for the provided address.');
      }
    } catch (e) {
      print('Error getting place location: $e');
    }
  }

  Future<void> _getSecondPlaceLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      print('locations-$locations');
      if (locations.isNotEmpty) {
        Location location = locations.first;
        print('location-$location');
        secondLocation = LatLng(location.latitude, location.longitude);
        print('secondLocation-$secondLocation');

        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLngZoom(secondLocation!, 14.0));

          setState(() {
            _placeList = [];
          });
        }
      } else {
        print('No location found for the provided address.');
      }
    } catch (e) {
      print('Error getting place location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serach Route'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                  children: [
                    Column(
                      children: [
                        _buildDot(Colors.green),
                        _buildVerticalDottedLine(),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: _firstController,
                          onTap: (){
                            setState(() {
                              _isFirstFieldActive = true;
                            });
                          },
                          onChanged: (String value){
                            if (value.isNotEmpty) {
                              _onChanged(value);
                            } else {
                              setState(() {
                                _placeList = [];
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Search First Place',
                            prefixIcon: Icon(Icons.my_location, color: Colors.blueAccent,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: 10),
                  Row(
          children: [
            Column(
              children: [
                _buildDot(Colors.red),
                _buildVerticalDottedLine(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _secondController,
                  onTap: (){
                    setState(() {
                      _isFirstFieldActive = false;
                    });

                  },
                  onChanged: (String value){
                    if (value.isNotEmpty) {
                      _onChanged(value);
                    } else {
                      setState(() {
                        _placeList = [];
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Second Place',
                    prefixIcon: const Icon(Icons.search, color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSubmitted: (value){
                    print('GO Map Screen Place');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          firstPlaceLatLong: firstLocation.toString(),
                          secondPlaceLatLong: secondLocation.toString(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
                ],
              ),
            ),
          ),
          _placeList.isNotEmpty
              ? Expanded(
            //color: Colors.yellow,
            child:ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (_isFirstFieldActive) {
                      print('_getFirstPlaceLocation');
                      _getFirstPlaceLocation(_placeList[index]["description"]!);
                      _firstController.text = _placeList[index]["description"]!;
                    }
                    else {
                      print('_getSecondPlaceLocation');
                      _getSecondPlaceLocation(_placeList[index]["description"]!);
                      _secondController.text = _placeList[index]["description"]!;
                     }
                    },
                  child: Card(
                    elevation: 4, // Optional: to give the card some elevation (shadow)
                    margin: const EdgeInsets.all(5), // Optional: margin around each card
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.blue), // Location icon with color
                      title: Text(
                        _placeList[index]["description"],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Optional: customize text style
                      ),
                    ),
                  ),
                );
              },
            )
          )
              : Container(),


          // ElevatedButton(
          //     onPressed: (){
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MapScreen(
          //             firstPlaceLatLong: firstLocation.toString(),
          //             secondPlaceLatLong: secondLocation.toString(),
          //           ),
          //         ),
          //       );
          //     },
          //     child: Text('Click Me')
          // )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? subLabelText,
    required IconData icon,
    required Color iconColor,
    required Color dotColor,
  }) {
    return Row(
      children: [
        Column(
          children: [
            _buildDot(dotColor),
            _buildVerticalDottedLine(),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: controller,
              onChanged: (String value){
                if (value.isNotEmpty) {
                  _onChanged(value);
                } else {
                  setState(() {
                    _placeList = [];
                  });
                }
              },
              decoration: InputDecoration(
                labelText: labelText,
                prefixIcon: Icon(icon, color: iconColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildVerticalDottedLine() {
    return Container(
      height: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) => _buildDot(Colors.grey[400]!)),
      ),
    );
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }
}
