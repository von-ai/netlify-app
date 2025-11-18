class WatchItem {
  final String id;
  final String title;
  final String type;
  final String genre;
  final String date;
  final bool isWatched;

  WatchItem({
    required this.id,
    required this.title,
    required this.type,
    required this.isWatched,
    required this.genre,
    required this.date,
  });

  factory WatchItem.fromFirestore(Map<String, dynamic> data, String id) {
    return WatchItem(
      id: id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      genre: data['genre'] ?? '',
      date: data['date'] ?? '',
      isWatched: data['isWatched'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'isWatched': isWatched,
      'date': date,
      'genre': genre,
    };
  }
}
