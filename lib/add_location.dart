import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/pic_screen.dart';
import 'package:flutter/services.dart';
import 'package:search_map_place/search_map_place.dart';
import 'dart:math';

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
//            Container(
//              color: kWhiteColor,
//              child: SafeArea(
//                bottom: false,
//                child: Container(
//                  height: 48.0,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      SizedBox(
//                        width: 19.0,
//                      ),
//                      CupertinoButton(
//                        padding: const EdgeInsets.all(0),
//                        onPressed: () {
//                          Navigator.pop(context);
//                        },
//                        child: Image.asset('lib/images/backarrowgray.png'),
//                      ),
//                      Expanded(
//                        child: TextField(
//                          onSubmitted: (text) {
//                            print('text: $text');
////                            makePredictions();
//                          },
//                          textAlignVertical: TextAlignVertical.center,
//                          maxLines: 1,
//                          style: TextStyle(
//                            fontFamily: 'Lato',
//                            color: Color(0xff606566),
//                            fontSize: 16,
//                            fontWeight: FontWeight.w400,
//                            fontStyle: FontStyle.normal,
//                            letterSpacing: -0.4099999964237213,
//                          ),
//                          decoration: InputDecoration(
//                            contentPadding: const EdgeInsets.all(0),
//                            prefixIcon: Image.asset('lib/images/searchico.png'),
//                            border: OutlineInputBorder(borderSide: BorderSide.none),
//                            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
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
                    Container(
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
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width * 0.05,
              child: SearchMapPlaceWidget(
                apiKey: kGoogleApiKey,
                onSelected: (place) async {
                  final geolocation = await place.geolocation;

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
                  setState(() {
                    _markers.add(destination);
                  });

                  controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                  controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
