import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:picpics/asset_entity_image_provider.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/fade_image_builder.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/search/search_map_place.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/pic_store.dart';
import 'package:picpics/stores/user_controller.dart';
import 'package:picpics/utils/app_logger.dart';

const kGoogleApiKey = 'AIzaSyCtoIN8xt9PDMmjTP5hILTzZ0XNdsojJCw';
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen(this.currentPic, {super.key});
  static const id = 'add_location_screen';
  final PicStore? currentPic;

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  PicStore get picStore => widget.currentPic!;

  final _mapController = Completer<GoogleMapController>();
  final _markers = <Marker>{};
  Geolocation? selectedGeolocation;

  static const LatLng nullLocation = LatLng(0, 0);
  static const LatLng rioDeJaneiro = LatLng(-22.951911, -52.2126759);

  static const CameraPosition _initialCamera = CameraPosition(
    target: rioDeJaneiro,
  );

  void saveLocation(BuildContext context) {
    if (selectedGeolocation != null) {
      //AppLogger.d(selectedGeolocation.fullJSON.toString());

      String? location;
      String? city;
      // String? state;
      String? country;

      for (final components
          in selectedGeolocation!.fullJSON!['address_components'] as List<dynamic>) {
        final types = components['types'] as List<dynamic>;
        if (types.contains('establishment')) {
          AppLogger.d('find establishment: ${components["long_name"]}');
          location = components['long_name'] as String?;
          continue;
        } else if (types.contains('locality')) {
          AppLogger.d('locality: ${components["long_name"]}');
          city = components['long_name'] as String?;
          continue;
        } else if (types.contains('administrative_area_level_2')) {
          AppLogger.d(
              'find administrative_area_level_2: ${components["long_name"]}',);
          city = components['long_name'] as String?;
          continue;
        } else if (types.contains('administrative_area_level_1')) {
          AppLogger.d(
              'find administrative_area_level_1: ${components["long_name"]}',);
          // state = components['long_name'] as String?;
          continue;
        } else if (types.contains('country')) {
          AppLogger.d('country: ${components["long_name"]}');
          country = components['long_name'] as String?;
          break;
        }
      }

      if (location != null) {
        final latLng = selectedGeolocation!.coordinates as LatLng;
        picStore.saveLocation(
          lat: latLng.latitude,
          long: latLng.longitude,
          specific: location,
          general: city,
        );
      } else {
        final latLng = selectedGeolocation!.coordinates as LatLng;
        picStore.saveLocation(
          lat: latLng.latitude,
          long: latLng.longitude,
          specific: city,
          general: country,
        );
      }
    }

    Get.back<void>();
  }

  Future<void> getUserPosition() async {
    AppLogger.d('getting current location');

    final position = await Geolocator.getCurrentPosition();

    final geolocation = LatLng(position.latitude, position.longitude);

    final destination = Marker(
      markerId: const MarkerId('user-destination'),
      icon: await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'lib/images/pin.png',
      ),
      position: geolocation,
    );

    final controller = await _mapController.future;
    _markers.clear();
    setState(() {
      _markers.add(destination);
    });

    await controller.animateCamera(CameraUpdate.newLatLng(geolocation));

    AppLogger.d('finished');
  }

  Future<void> findInitialCamera() async {
    LatLng? latLng;

    if (picStore.latitude.value != null && picStore.longitude.value != null) {
      latLng = LatLng(picStore.latitude.value!, picStore.longitude.value!);
    } else if (picStore.originalLatitude != null &&
        picStore.originalLongitude != null) {
      latLng = LatLng(picStore.originalLatitude!, picStore.originalLongitude!);
    }

    if (latLng != null && latLng != nullLocation) {
      final destination = Marker(
        markerId: const MarkerId('user-destination'),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            devicePixelRatio: 2.5,
          ),
          'lib/images/pin.png',
        ),
        position: latLng,
      );

      final controller = await _mapController.future;
      _markers.clear();
      setState(() {
        _markers.add(destination);
      });

      AppLogger.d(latLng);

      final position = CameraPosition(
        target: latLng == nullLocation ? rioDeJaneiro : latLng,
        zoom: latLng == nullLocation ? 0.0 : 14.0,
      );
      await controller.animateCamera(CameraUpdate.newCameraPosition(position));
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
    findInitialCamera();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final imageProvider = AssetEntityImageProvider(picStore);
    return Scaffold(
      key: homeScaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              padding: const EdgeInsets.only(left: 10, bottom: 226),
              markers: _markers,
              initialCameraPosition: _initialCamera,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: _mapController.complete,
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => Get.back<void>(),
                          child: SizedBox(
                            width: height * 0.17,
                            height: height * 0.17,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ExtendedImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                loadStateChanged: (ExtendedImageState state) {
                                  Widget loader;
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      loader = const ColoredBox(
                                          color: kGreyPlaceholder,);
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
                              left: 14, top: 14,),
                          onPressed: getUserPosition,
                          child: Image.asset(
                              'lib/images/getcurrentlocationico.png',),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        AppLogger.d('saving location...');
                        saveLocation(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 44,
                        child: Center(
                          child: Obx(
                            () => Text(
                              LangControl.to.S.value.save_location,
                              textScaler: const TextScaler.linear(1),
                              style: const TextStyle(
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
                    ),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: kWhiteColor,
              child: SafeArea(
                child: Obx(
                  () => SearchMapPlaceWidget(
                    apiKey: kGoogleApiKey,
                    placeholder: LangControl.to.S.value.search,
                    language: UserController.to.appLanguage.value
                        .split('_')[0], // arrumar isso
                    onSelected: (place) async {
                      final geolocation = await place.geolocation;
                      selectedGeolocation = geolocation;

                      final destination = Marker(
                        markerId: const MarkerId('user-destination'),
                        icon: await BitmapDescriptor.fromAssetImage(
                          const ImageConfiguration(
                            devicePixelRatio: 2.5,
                          ),
                          'lib/images/pin.png',
                        ),
                        position: geolocation.coordinates as LatLng,
                      );

                      final controller = await _mapController.future;
                      _markers.clear();
                      setState(() {
                        _markers.add(destination);
                      });

                      await controller.animateCamera(
                          CameraUpdate.newLatLng(geolocation.coordinates as LatLng),);
                      await controller.animateCamera(
                          CameraUpdate.newLatLngBounds(geolocation.bounds as LatLngBounds, 0),);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
