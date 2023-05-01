class Secret {
  String photoId, photoPath, thumbPath;
  final DateTime createDateTime;
  final double originalLatitude, originalLongitude;
  final String nonce;

  Secret({
    required this.photoId,
    required this.photoPath,
    required this.thumbPath,
    required this.createDateTime,
    required this.originalLatitude,
    required this.originalLongitude,
    required this.nonce,
  });
}
