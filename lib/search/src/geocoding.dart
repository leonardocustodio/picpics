part of search_map_place;

class Geocoding {
  Geocoding({required this.apiKey, this.language = 'en'});
  String apiKey;
  String language;

  Future<dynamic> getGeolocation(String adress) async {
    final trimmedAdress = adress.replaceAllMapped(' ', (m) => '+');
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$trimmedAdress&key=$apiKey&language=$language';
    final response = await http.get(Uri.parse(url));
    final json = JSON.jsonDecode(response.body);
    if (json['error_message'] == null) {
      return Geolocation.fromJSON(json);
    } else {
      var error = json['error_message'];
      if (error == 'This API project is not authorized to use this API.') {
        error +=
            ' Make sure both the Geolocation and Geocoding APIs are activated on your Google Cloud Platform';
      }
      throw Exception(error);
    }
  }
}
