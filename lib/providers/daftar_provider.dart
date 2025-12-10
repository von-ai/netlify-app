import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/watch_item.dart';

class DaftarProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<WatchItem> _items = [];
  List<WatchItem> _filteredItems = [];

  List<WatchItem> get items => _items;
  List<WatchItem> get filteredItems => _filteredItems;

  DaftarProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
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

  Future<void> addItem(WatchItem item) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('watchlist')
        .add(item.toMap());
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
    } catch (e) {
      debugPrint("Error delete item: $e");
    }
  }
}
