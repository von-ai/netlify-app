import 'dart:async'; // Diperlukan untuk StreamSubscription
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:project_mobile/models/watch_item.dart';

class DaftarProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<WatchItem> _items = [];
  List<WatchItem> _filteredItems = [];
  
  // Variable untuk menyimpan stream agar bisa di-cancel
  StreamSubscription<QuerySnapshot>? _watchlistSubscription;

  List<WatchItem> get items => _items;
  List<WatchItem> get filteredItems => _filteredItems;

  DaftarProvider() {
    // Panggil loadItems saat provider pertama kali dibuat
    loadItems();
  }

  // --- PERBAIKAN: Method loadItems ditambahkan di sini ---
  void loadItems() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      // Jika user belum login, kosongkan list
      _items = [];
      _filteredItems = [];
      notifyListeners();
      return;
    }

    // Cancel subscription lama sebelum membuat yang baru (mencegah duplikasi data/memory leak)
    _watchlistSubscription?.cancel();

    _watchlistSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('watchlist')
        // .orderBy('timestamp', descending: true) // Aktifkan jika sudah ada field timestamp
        .snapshots()
        .listen((snapshot) {
          _items = snapshot.docs
              .map((doc) => WatchItem.fromFirestore(doc.data(), doc.id))
              .toList();

          _filteredItems = List.from(_items);
          notifyListeners();
        }, onError: (error) {
          debugPrint("Error loading items: $error");
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

  Future<void> updateItem(WatchItem item) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      if ((item.id ?? '').isEmpty) return;

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('watchlist')
          .doc(item.id)
          .update(item.toMap());
          
    } catch (e) {
      debugPrint("Error updating item: $e");
      rethrow;
    }
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

  @override
  void dispose() {
    // Pastikan stream dimatikan saat provider tidak dipakai
    _watchlistSubscription?.cancel();
    super.dispose();
  }
}