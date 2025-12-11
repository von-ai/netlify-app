import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/models/watch_item.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<WatchItem>> getWatchItems(String userId) {
    return _db
        .collection('watchlist')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WatchItem.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addWatchItem(String userId, WatchItem item) async {
    await _db
        .collection('watchlist')
        .doc(userId)
        .collection('items')
        .add(item.toMap());
  }

  Future<void> deleteWatchItem(String userId, String itemId) async {
    await _db
        .collection('watchlist')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Future<void> toggleWatched(String userId, String itemId, bool value) async {
    await _db
        .collection('watchlist')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .update({'isWatched': value});
  }
}
