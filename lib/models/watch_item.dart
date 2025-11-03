class WatchItem {
  final String id;
  final String title;
  final String type;
  final bool isWatched;

  WatchItem({
    required this.id,
    required this.title,
    required this.type,
    required this.isWatched,
  });

  factory WatchItem.fromFirestore(Map<String, dynamic> data, String id) {
    return WatchItem(
      id: id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      isWatched: data['isWatched'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'type': type, 'isWatched': isWatched};
  }
}
