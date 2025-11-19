import 'package:flutter/material.dart';
import '../models/watch_item.dart';
import '../services/watchlist_service.dart';

class WatchlistProvider with ChangeNotifier {
  final _service = WatchlistService();
  List<WatchItem> items = [];
  List<WatchItem> filtered = [];

  WatchlistProvider() {
    listenToData();
  }

  void listenToData() {
    _service.getItems().listen((data) {
      items = data;
      filtered = data;
      notifyListeners();
    });
  }

  void search(String query) {
    if (query.isEmpty) {
      filtered = items;
    } else {
      filtered = items
          .where(
            (e) =>
                e.title.toLowerCase().contains(query.toLowerCase()) ||
                e.genre.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> add(WatchItem item) async {
    await _service.addItem(item);
  }

  Future<void> remove(WatchItem item) async {
    await _service.deleteItem(item.id);
  }

  Future<void> toggleWatch(WatchItem item) async {
    await _service.updateWatched(item.id, !item.isWatched);
  }
}
