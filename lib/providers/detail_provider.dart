import 'package:flutter/foundation.dart';
import '../models/watch_item.dart';
import '../services/watchlist_service.dart';

class DetailProvider with ChangeNotifier {
  final WatchlistService _service = WatchlistService();

  WatchItem? _item;
  bool _loading = false;

  WatchItem? get item => _item;
  bool get loading => _loading;

  Future<void> loadDetail(String id) async {
    _loading = true;
    notifyListeners();

    _item = await _service.getItemById(id);

    _loading = false;
    notifyListeners();
  }
}
