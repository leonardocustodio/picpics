class Secret {
  String photoId, photoPath, thumbPath;
  final DateTime createDateTime;
  final double originalLatitude, originalLongitude;
  final String nonce;

  Secret({
    this.photoId,
    this.photoPath,
    this.thumbPath,
    this.createDateTime,
    this.originalLatitude,
    this.originalLongitude,
    this.nonce,
  });
}
