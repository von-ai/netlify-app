import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/watch_item.dart';

class DaftarProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<WatchItem> _items = [];
  List<WatchItem> _filteredItems = [];

  List<WatchItem> get filteredItems => _filteredItems;

  DaftarProvider() {
    fetchItems();
  }

  void fetchItems() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _firestore
        .collection('users')
        .doc(uid)
        .collection('watchlist')
        .snapshots()
        .listen((snapshot) {
          _items = snapshot.docs
              .map((doc) => WatchItem.fromFirestore(doc.data(), doc.id))
              .toList();

          _filteredItems = List.from(_items);
          notifyListeners();
        });
  }

  void search(String query) {
    if (query.trim().isEmpty) {
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

  Future<void> removeItem(WatchItem item) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('watchlist')
          .doc(item.id)
          .delete();

      _items.remove(item);
      _filteredItems.remove(item);
      notifyListeners();
    } catch (e) {
      debugPrint("Error delete item: $e");
    }
  }

  Future<void> addItem(WatchItem item) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('watchlist')
          .add(item.toMap());

      final newItem = WatchItem(
        id: doc.id,
        title: item.title,
        type: item.type,
        genre: item.genre,
        date: item.date,
        isWatched: item.isWatched,
        episodes: item.episodes,
      );

      _items.add(newItem);
      _filteredItems = List.from(_items);

      notifyListeners();
    } catch (e) {
      debugPrint("Error add item: $e");
    }
  }
}
