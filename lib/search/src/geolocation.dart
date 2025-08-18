part of search_map_place;

class Geolocation {
  Geolocation(this._coordinates, this._bounds);

  Geolocation.fromJSON(Map<String, dynamic> geolocationJSON) {
    _coordinates = geolocationJSON['results'][0]['geometry']['location'];
    _bounds = geolocationJSON['results'][0]['geometry']['viewport'];
    fullJSON = geolocationJSON['results'][0] as Map<String, dynamic>;
  }

  /// Property that holds the JSON response that contains the location of the place.
  dynamic _coordinates;

  /// Property that holds the JSON response that contains the viewport of the place.
  dynamic _bounds;

  /// Has the full JSON response received from the Geolocation API. Can be used to extract extra information of the location. More info on the [Geolocation API documentation](https://developers.google.com/maps/documentation/geolocation/intro)
  ///
  /// All of its information can be accessed like a regular [Map]. For example:
  /// ```
  /// fullJSON["adress_components"][2]["short_name"]
  /// ```
  Map<String, dynamic>? fullJSON;

  /// If you have the `google_maps_flutter` package, this method will return the coordinates of the place as
  /// a `LatLng` object. Otherwise, it'll be returned as Map.
  dynamic get coordinates {
    try {
      return LatLng(_coordinates['lat'] as double, _coordinates['lng'] as double);
    } catch (e) {
      AppLogger.d(
          'You appear to not have the `google_maps_flutter` package installed. In this case, this method will return an object with the latitude and longitude',);
      return _coordinates;
    }
  }

  /// If you have the `google_maps_flutter` package, this method will return the coordinates of the place as
  /// a `LatLngBounds` object. Otherwise, it'll be returned as Map.
  dynamic get bounds {
    try {
      return LatLngBounds(
        southwest:
            LatLng(_bounds['southwest']['lat'] as double, _bounds['southwest']['lng'] as double),
        northeast:
            LatLng(_bounds['northeast']['lat'] as double, _bounds['northeast']['lng'] as double),
      );
    } catch (e) {
      AppLogger.d(
          'You appear to not have the `google_maps_flutter` package installed. In this case, this method will return an object with southwest and northeast bounds',);
      return _bounds;
    }
  }
}
