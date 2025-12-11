import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/models/watch_item.dart';

class WatchlistService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference get _collection =>
      _firestore.collection('users').doc(userId).collection('watchlist');

  Future<void> addItem(WatchItem item) async {
    await _collection.add(item.toMap());
  }

  Stream<List<WatchItem>> getItems() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return WatchItem.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> deleteItem(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> updateWatched(String id, bool isWatched) async {
    await _collection.doc(id).update({
      "isWatched": isWatched,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<WatchItem?> getItemById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;

    return WatchItem.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> updateCurrentEpisode(String id, int newEpisode) async {
    await _collection.doc(id).update({
      "currentEpisode": newEpisode,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateMood(String id, String mood) async {
    await _collection.doc(id).update({
      "mood": mood,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
