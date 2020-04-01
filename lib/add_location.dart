import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/pic_screen.dart';

class AddLocationScreen extends StatefulWidget {
  static const id = 'add_location_screen';

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: const EdgeInsets.only(left: 10.0, bottom: 226.0),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            color: kWhiteColor,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 48.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 19.0,
                    ),
                    Container(
                      width: 9.333307266235352,
                      height: 18.66599464416504,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 21.0,
                    ),
                    Container(
                      width: 18.0002498626709,
                      height: 18,
                      decoration: new BoxDecoration(
                        color: kSecondaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Ilha bela",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff606566),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.4099999964237213,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Container(
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
        ],
      ),
    );
  }
}
