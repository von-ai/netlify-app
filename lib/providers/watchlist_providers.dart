import 'package:flutter/material.dart';
import 'package:project_mobile/models/watch_item.dart';
import 'package:project_mobile/services/watchlist_service.dart';

class WatchlistProvider with ChangeNotifier {
  final WatchlistService _service = WatchlistService();

  List<WatchItem> _items = [];
  List<WatchItem> get items => _items;

  WatchlistProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    _service.getItems().listen((data) {
      _items = data;
      notifyListeners();
    });
  }

  Future<void> add(WatchItem item) async {
    await _service.addItem(item);
  }

  Future<void> delete(String id) async {
    await _service.deleteItem(id);
  }

  Future<void> updateWatched(String id, bool isWatched) async {
    await _service.updateWatched(id, isWatched);
  }
}
