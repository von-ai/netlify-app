class WatchItem {
  final String? id;
  final String title;
  final String type;
  final String genre;
  final String date;
  final bool isWatched;
  final int? episodes;

  WatchItem({
    this.id,
    required this.title,
    required this.type,
    required this.genre,
    required this.date,
    required this.isWatched,
    this.episodes,
  });

  factory WatchItem.fromFirestore(Map<String, dynamic> data, String id) {
    return WatchItem(
      id: id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      genre: data['genre'] ?? '',
      date: data['date'] ?? '',
      isWatched: data['isWatched'] ?? false,
      episodes: data['episodes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'title': title,
      'type': type,
      'genre': genre,
      'date': date,
      'isWatched': isWatched,
    };

    if (episodes != null) {
      map['episodes'] = episodes;
    }

    return map;
  }
}
