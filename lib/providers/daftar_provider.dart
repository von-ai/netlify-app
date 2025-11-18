import 'package:flutter/foundation.dart';
import '../models/watch_item.dart';

class DaftarProvider with ChangeNotifier {
  final List<WatchItem> _items = [
    WatchItem(
      id: '1',
      title: 'Attack on Titan',
      type: 'Anime',
      genre: 'Action',
      date: '2013',
      isWatched: false,
    ),
    WatchItem(
      id: '2',
      title: 'One Piece',
      type: 'Anime',
      genre: 'Adventure',
      date: '1999',
      isWatched: false,
    ),
    WatchItem(
      id: '3',
      title: 'Demon Slayer',
      type: 'Anime',
      genre: 'Action',
      date: '2019',
      isWatched: false,
    ),
    WatchItem(
      id: '4',
      title: 'Jujutsu Kaisen',
      type: 'Anime',
      genre: 'Action',
      date: '2020',
      isWatched: false,
    ),
    WatchItem(
      id: '5',
      title: 'Frieren',
      type: 'Anime',
      genre: 'Fantasy',
      date: '2023',
      isWatched: false,
    ),
  ];

  List<WatchItem> _filteredItems = [];

  DaftarProvider() {
    _filteredItems = List.from(_items);
  }

  List<WatchItem> get filteredItems => _filteredItems;

  void search(String query) {
    if (query.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where(
            (item) => item.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void removeItem(WatchItem item) {
    _items.remove(item);
    _filteredItems.remove(item);
    notifyListeners();
  }
}
