import 'package:cloud_firestore/cloud_firestore.dart';

class WatchItem {
  final String? id;
  final String title;
  final String type;
  final String genre;
  final String date;
  final bool isWatched;
  final int? episodes;
  final int currentEpisode;
  final String? mood;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  WatchItem({
    this.id,
    required this.title,
    required this.type,
    required this.genre,
    required this.date,
    required this.isWatched,
    this.episodes,
    this.currentEpisode = 0,
    this.mood,
    this.createdAt,
    this.updatedAt,
  });

  WatchItem copyWith({
    String? id,
    String? title,
    String? type,
    String? genre,
    String? date,
    bool? isWatched,
    int? episodes,
    int? currentEpisode,
    String? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      genre: genre ?? this.genre,
      date: date ?? this.date,
      isWatched: isWatched ?? this.isWatched,
      episodes: episodes ?? this.episodes,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory WatchItem.fromFirestore(Map<String, dynamic> data, String id) {
    return WatchItem(
      id: id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      genre: data['genre'] ?? '',
      date: data['date'] ?? '',
      isWatched: data['isWatched'] ?? false,
      episodes: data['episodes'],
      currentEpisode: data['currentEpisode'] ?? 0,
      mood: data['mood'],

      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,

      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'genre': genre,
      'date': date,
      'isWatched': isWatched,
      'episodes': episodes,
      'currentEpisode': currentEpisode,
      'mood': mood,

      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),

      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
