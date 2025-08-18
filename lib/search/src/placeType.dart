part of search_map_place;

class PlaceType {
  const PlaceType(this.apiString);
  final String apiString;

  static const geocode = PlaceType('geocode');
  static const address = PlaceType('address');
  static const establishment = PlaceType('establishment');
  static const region = PlaceType('(region)');
  static const cities = PlaceType('(cities)');
}
