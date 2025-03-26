import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin<SearchScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(
    37.7749,
    -122.4194,
  ); // Default: San Francisco
   Set<Marker> _markers = {};

  late AnimationController _animationController;
  late SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1.0),
          from: const Duration(seconds: 0),
          to: const Duration(seconds: 2),
          tag: "scale_head",
        )
        .animate(_animationController);
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchLocation(String place) async {
    try {
      List<Location> locations = await locationFromAddress(place);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng newPosition = LatLng(location.latitude, location.longitude);

        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 12),
        );

        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId("searched_location"),
              position: newPosition,
              infoWindow: InfoWindow(title: place),
            ),
          );
        });

        // Restart animation when searching a new location
        _animationController.reset();
        _animationController.forward();
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Transform.scale(
              scale: sequenceAnimation["scale_head"].value,
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: TextEditingController(
                  text: 'Saint Peterburg',
                ),
                googleAPIKey: "YOUR_GOOGLE_MAPS_API_KEY",
                boxDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                inputDecoration: InputDecoration(
                  hintText: 'Search a location',
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,

                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                debounceTime: 500,
                isLatLngRequired: false,
                getPlaceDetailWithLatLng: (prediction) {
                  _searchLocation(prediction.description!);
                },
                itemClick: (prediction) {
                  _searchLocation(prediction.description!);
                },
              ),
            ),
            actions: [
              Transform.scale(
                scale: sequenceAnimation["scale_head"].value,
                child: Container(
                  // Profile image
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/filter.png'),
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          // body: GoogleMap(
          //   mapType: MapType.terrain,
          //   onMapCreated: _onMapCreated,
          //   initialCameraPosition: CameraPosition(
          //     target: _initialPosition,
          //     zoom: 10,
          //   ),
          //   markers: _markers,
          // ),
          floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
          Container(
            margin: const EdgeInsets.only(bottom: 90, left:16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
            Transform.scale(
            scale: sequenceAnimation["scale_head"].value,
              child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(93, 91, 88,1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.layers, color: Colors.white),
          )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.scale(
                      scale: sequenceAnimation["scale_head"].value,
                      child:  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(93, 91, 88,1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.near_me_rounded, color: Colors.white),
                    )),
                    Transform.scale(
                      scale: sequenceAnimation["scale_head"].value,
                      child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(93, 91, 88,1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child:Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_list_rounded, color: Colors.white),
                          Text("List of variants", style: TextStyle( color: Colors.white),)
                        ],
                      )
                    ))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
