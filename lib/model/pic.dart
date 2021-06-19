class Pic {
  final String photoId;
  final DateTime createdAt;
  final double originalLatitude, originalLongitude;
  double latitude, longitude;
  String specificLocation, generalLocation, base64encoded;
  final List<String> tags;
  bool isPrivate, deletedFromCameraRoll, isStarred;

  Pic({
    required this.photoId,
    required this.createdAt,
    required this.originalLatitude,
    required this.originalLongitude,
    required this.latitude,
    required this.longitude,
    required this.specificLocation,
    required this.generalLocation,
    required this.tags,
    required this.isPrivate,
    required this.deletedFromCameraRoll,
    required this.isStarred,
    required this.base64encoded,
  });
}
