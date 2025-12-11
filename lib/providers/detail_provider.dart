import 'package:flutter/foundation.dart';
import 'package:project_mobile/models/watch_item.dart';
import 'package:project_mobile/services/watchlist_service.dart';

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

  Future<void> updateEpisode(String id, int newEpisode) async {
    if (item == null) return;

    await _service.updateCurrentEpisode(id, newEpisode);

    item = item!.copyWith(currentEpisode: newEpisode);
    notifyListeners();
  }

  Future<void> updateMood(String id, String mood) async {
    if (item == null) return;

    await _service.updateMood(id, mood);

    item = item!.copyWith(mood: mood);
    notifyListeners();
  }
}
