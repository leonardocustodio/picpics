class TagModel {
  TagModel({
    required this.key,
    required this.title,
    this.count = 0,
    this.time,
  });

  String key;
  String title;
  int count;
  DateTime? time;

  TagModel copyWith({
    String? key,
    String? title,
    int? count,
    DateTime? time,
  }) {
    return TagModel(
      key: key ?? this.key,
      title: title ?? this.title,
      count: count ?? this.count,
      time: time ?? this.time,
    );
  }
}
