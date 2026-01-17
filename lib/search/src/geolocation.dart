part of '../search_map_place.dart';

class Geolocation {
  Geolocation(this._coordinates, this._bounds);

  Geolocation.fromJSON(Map<String, dynamic> geolocationJSON) {
    final results = geolocationJSON['results'] as List<dynamic>;
    final firstResult = results[0] as Map<String, dynamic>;
    final geometry = firstResult['geometry'] as Map<String, dynamic>;
    _coordinates = geometry['location'] as Map<String, dynamic>;
    _bounds = geometry['viewport'] as Map<String, dynamic>;
    fullJSON = firstResult;
  }

  /// Property that holds the JSON response that contains the location of the place.
  Map<String, dynamic>? _coordinates;

  /// Property that holds the JSON response that contains the viewport of the place.
  Map<String, dynamic>? _bounds;

  /// Has the full JSON response received from the Geolocation API. Can be used to extract extra information of the location. More info on the [Geolocation API documentation](https://developers.google.com/maps/documentation/geolocation/intro)
  ///
  /// All of its information can be accessed like a regular [Map]. For example:
  /// ```dart
  /// fullJSON["adress_components"][2]["short_name"]
  /// ```
  Map<String, dynamic>? fullJSON;

  /// If you have the `google_maps_flutter` package, this method will return the coordinates of the place as
  /// a `LatLng` object. Otherwise, it'll be returned as Map.
  LatLng? get coordinates {
    if (_coordinates == null) return null;
    final lat = _coordinates!['lat'] as double?;
    final lng = _coordinates!['lng'] as double?;
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  /// If you have the `google_maps_flutter` package, this method will return the coordinates of the place as
  /// a `LatLngBounds` object. Otherwise, it'll be returned as Map.
  LatLngBounds? get bounds {
    if (_bounds == null) return null;
    final southwest = _bounds!['southwest'] as Map<String, dynamic>?;
    final northeast = _bounds!['northeast'] as Map<String, dynamic>?;
    if (southwest == null || northeast == null) return null;
    final swLat = southwest['lat'] as double?;
    final swLng = southwest['lng'] as double?;
    final neLat = northeast['lat'] as double?;
    final neLng = northeast['lng'] as double?;
    if (swLat == null || swLng == null || neLat == null || neLng == null) {
      return null;
    }
    return LatLngBounds(
      southwest: LatLng(swLat, swLng),
      northeast: LatLng(neLat, neLng),
    );
  }
}
