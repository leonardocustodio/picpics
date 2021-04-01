import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:picPics/asset_entity_image_provider.dart';
import 'package:picPics/fade_image_builder.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/services.dart';
import 'package:picPics/search/search_map_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';

const kGoogleApiKey = 'AIzaSyCtoIN8xt9PDMmjTP5hILTzZ0XNdsojJCw';
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class AddLocationScreen extends StatefulWidget {
  static const id = 'add_location_screen';

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  AppStore appStore;
  GalleryStore galleryStore;
  PicStore get picStore => galleryStore.currentPic;

  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  Geolocation selectedGeolocation;

  static final LatLng nullLocation = LatLng(0.0, 0.0);
  static final LatLng rioDeJaneiro = LatLng(-22.951911, -52.2126759);

  static final CameraPosition _initialCamera = CameraPosition(
    target: rioDeJaneiro,
    zoom: 0.0,
  );

  void saveLocation(BuildContext context) {
    if (selectedGeolocation != null) {
      //print(selectedGeolocation.fullJSON.toString());

      String location;
      String city;
      String state;
      String country;

      for (var components
          in selectedGeolocation.fullJSON["address_components"]) {
        var types = components["types"];
        if (types.contains("establishment")) {
          //print('find establishment: ${components["long_name"]}');
          location = components["long_name"];
          continue;
        } else if (types.contains("locality")) {
          //print('locality: ${components["long_name"]}');
          city = components["long_name"];
          continue;
        } else if (types.contains("administrative_area_level_2")) {
          //print('find administrative_area_level_2: ${components["long_name"]}');
          city = components["long_name"];
          continue;
        } else if (types.contains("administrative_area_level_1")) {
          //print('find administrative_area_level_1: ${components["long_name"]}');
          state = components["long_name"];
          continue;
        } else if (types.contains("country")) {
          //print('country: ${components["long_name"]}');
          country = components["long_name"];
          break;
        }
      }

      if (location != null) {
        LatLng latLng = selectedGeolocation.coordinates;
        picStore.saveLocation(
          lat: latLng.latitude,
          long: latLng.longitude,
          specific: location,
          general: city,
        );
      } else {
        LatLng latLng = selectedGeolocation.coordinates;
        picStore.saveLocation(
          lat: latLng.latitude,
          long: latLng.longitude,
          specific: city,
          general: country,
        );
      }
    }

    Navigator.pop(context);
  }

  void getUserPosition() async {
    //print('getting current location');

    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

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

    //print('finished');
  }

  void findInitialCamera() async {
    LatLng latLng;

    if (picStore.latitude != null && picStore.longitude != null) {
      latLng = LatLng(picStore.latitude, picStore.longitude);
    } else if (picStore.originalLatitude != null &&
        picStore.originalLongitude != null) {
      latLng = LatLng(picStore.originalLatitude, picStore.originalLongitude);
    }

    if (latLng != null && latLng != nullLocation) {
      final destination = Marker(
        markerId: MarkerId('user-destination'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            devicePixelRatio: 2.5,
          ),
          'lib/images/pin.png',
        ),
        position: latLng,
      );

      final GoogleMapController controller = await _mapController.future;
      _markers.clear();
      setState(() {
        _markers.add(destination);
      });

      //print(latLng);

      final CameraPosition position = CameraPosition(
        target: latLng == nullLocation ? rioDeJaneiro : latLng,
        zoom: latLng == nullLocation ? 0.0 : 14.0,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(position));
    }
  }

  @override
  void initState() {
    super.initState();
    Analytics.sendCurrentScreen(Screen.add_location_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = AppStore.to;
    galleryStore = GalleryStore.to;
    findInitialCamera();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final AssetEntityImageProvider imageProvider =
        AssetEntityImageProvider(picStore, isOriginal: true);
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
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
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
                            width: height * 0.17,
                            height: height * 0.17,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: ExtendedImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                loadStateChanged: (ExtendedImageState state) {
                                  Widget loader;
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      loader = const ColoredBox(
                                          color: kGreyPlaceholder);
                                      break;
                                    case LoadState.completed:
                                      loader = FadeImageBuilder(
                                        child: () {
                                          return RepaintBoundary(
                                            child: state.completedWidget,
                                          );
                                        }(),
                                      );
                                      break;
                                    case LoadState.failed:
                                      loader = Container();
                                      break;
                                  }
                                  return loader;
                                },
                              ),

                              // Container(),
                              // ImageItem(
                              //   entity: picStore.entity,
                              //   size: 140,
                              // ),
                            ),
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.only(
                              left: 14.0, right: 0, bottom: 0.0, top: 14.0),
                          onPressed: () {
                            getUserPosition();
                          },
                          child: Image.asset(
                              'lib/images/getcurrentlocationico.png'),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        //print('saving location...');
                        saveLocation(context);
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
                            S.of(context).save_location,
                            textScaleFactor: 1.0,
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
            Container(
              color: kWhiteColor,
              child: SafeArea(
                child: SearchMapPlaceWidget(
                  apiKey: kGoogleApiKey,
                  placeholder: S.of(context).search,
                  language:
                      appStore.appLanguage.value.split('_')[0], // arrumar isso
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

                    final GoogleMapController controller =
                        await _mapController.future;
                    _markers.clear();
                    setState(() {
                      _markers.add(destination);
                    });

                    controller.animateCamera(
                        CameraUpdate.newLatLng(geolocation.coordinates));
                    controller.animateCamera(
                        CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
