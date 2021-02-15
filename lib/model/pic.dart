class Pic {
  final String photoId;
  final DateTime createdAt;
  final double originalLatitude, originalLongitude;
  double latitude, longitude;
  String specificLocation, generalLocation, base64encoded;
  final List<String> tags;
  bool isPrivate, deletedFromCameraRoll, isStarred;

  Pic({
    this.photoId,
    this.createdAt,
    this.originalLatitude,
    this.originalLongitude,
    this.latitude,
    this.longitude,
    this.specificLocation,
    this.generalLocation,
    this.tags,
    this.isPrivate,
    this.deletedFromCameraRoll,
    this.isStarred,
    this.base64encoded,
  });
}
