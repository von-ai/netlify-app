import 'package:flutter/foundation.dart';

class DaftarProvider with ChangeNotifier {
  final List<String> _items = [
    'Attack on Titan',
    'One Piece',
    'Demon Slayer',
    'Jujutsu Kaisen',
    'Frieren',
  ];

  List<String> _filteredItems = [];

  DaftarProvider() {
    _filteredItems = List.from(_items);
  }

  List<String> get filteredItems => _filteredItems;

  void search(String query) {
    if (query.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
