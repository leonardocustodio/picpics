class Secret {
  Secret({
    required this.photoId,
    required this.photoPath,
    required this.thumbPath,
    required this.createDateTime,
    required this.originalLatitude,
    required this.originalLongitude,
    required this.nonce,
  });
  String photoId;
  String photoPath;
  String thumbPath;
  final DateTime createDateTime;
  final double originalLatitude;
  final double originalLongitude;
  final String nonce;
}
