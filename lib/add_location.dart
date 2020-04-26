import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/pic_screen.dart';
import 'package:flutter/services.dart';
import 'package:picPics/search/search_map_place.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:picPics/image_item.dart';

const kGoogleApiKey = 'AIzaSyCtoIN8xt9PDMmjTP5hILTzZ0XNdsojJCw';
//GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddLocationScreen extends StatefulWidget {
  static const id = 'add_location_screen';

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _AddLocationScreenState extends State<AddLocationScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  Geolocation selectedGeolocation;

  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

//  Future<void> _goToPosition(double lat, double long) async {
//    final CameraPosition position =
//        CameraPosition(bearing: 192.8334901395799, target: LatLng(lat, long), tilt: 59.440717697143555, zoom: 19.151926040649414);
//
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(position));
//  }

//  Future<void> displayPrediction(Prediction p) async {
//    if (p != null) {
//      // get detail (lat/lng)
//      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
//      final lat = detail.result.geometry.location.lat;
//      final lng = detail.result.geometry.location.lng;
//
//      print('lat $lat - long $lng');
//
//      _goToPosition(lat, lng);
//    }

  void saveLocation() {
    if (selectedGeolocation != null) {
      print(selectedGeolocation.fullJSON.toString());

      String location;
      String city;
      String state;
      String country;

      for (var components in selectedGeolocation.fullJSON["address_components"]) {
        var types = components["types"];
        if (types.contains("establishment")) {
          print('find establishment: ${components["long_name"]}');
          location = components["long_name"];
          continue;
        } else if (types.contains("locality")) {
          print('locality: ${components["long_name"]}');
          city = components["long_name"];
          continue;
        } else if (types.contains("administrative_area_level_2")) {
          print('find administrative_area_level_2: ${components["long_name"]}');
          city = components["long_name"];
          continue;
        } else if (types.contains("administrative_area_level_1")) {
          print('find administrative_area_level_1: ${components["long_name"]}');
          state = components["long_name"];
          continue;
        } else if (types.contains("country")) {
          print('country: ${components["long_name"]}');
          country = components["long_name"];
          break;
        }
      }
    }
  }

  void getCurrentPosition() async {
    print('getting current location');

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    final geolocation = LatLng(position.latitude, position.longitude);

    final destination = Marker(
      markerId: MarkerId('user-destination'),
      icon: await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'lib/images/pin.png',
      ),
      position: geolocation,
    );

    final GoogleMapController controller = await _mapController.future;
    _markers.clear();
    setState(() {
      _markers.add(destination);
    });

    controller.animateCamera(CameraUpdate.newLatLng(geolocation));
    print('finished');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              padding: const EdgeInsets.only(left: 10.0, bottom: 226.0),
              mapType: MapType.normal,
              markers: _markers,
              initialCameraPosition: _initialCamera,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 140.0,
                            height: 140.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: ImageItem(
                                entity: DatabaseManager.instance.selectedPhoto,
                                size: 140,
                              ),
                            ),
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.only(left: 14.0, right: 0, bottom: 0.0, top: 14.0),
                          onPressed: () {
                            getCurrentPosition();
                          },
                          child: Image.asset('lib/images/getcurrentlocationico.png'),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        print('saving location...');
                        saveLocation();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: 44.0,
                        child: Center(
                          child: Text(
                            "Confirmar localização",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: kWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SearchMapPlaceWidget(
              apiKey: kGoogleApiKey,
              onSelected: (place) async {
                final geolocation = await place.geolocation;
                selectedGeolocation = geolocation;

                final destination = Marker(
                  markerId: MarkerId('user-destination'),
                  icon: await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(
                      devicePixelRatio: 2.5,
                    ),
                    'lib/images/pin.png',
                  ),
                  position: geolocation.coordinates,
                );

                final GoogleMapController controller = await _mapController.future;
                _markers.clear();
                setState(() {
                  _markers.add(destination);
                });

                controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          ],
        ),
      ),
    );
  }
}
