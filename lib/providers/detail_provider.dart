import 'package:flutter/foundation.dart';
import '../models/watch_item.dart';
import '../services/watchlist_service.dart';

class DetailProvider extends ChangeNotifier {
  final _service = WatchlistService();

  bool loading = false;
  WatchItem? item;

  // WatchItem? get item => _item;
  // bool get loading => _loading;

  Future<void> loadDetail(String id) async {
    loading = true;
    notifyListeners();

    item = await _service.getItemById(id);

    loading = false;
    notifyListeners();
  }

  Future<void> updateWatchedStatus(String id) async {
    if (item == null) return;

    final newStatus = !item!.isWatched;

    await _service.updateWatched(id, newStatus);

    item = item!.copyWith(isWatched: newStatus);
    notifyListeners();
  }
}
