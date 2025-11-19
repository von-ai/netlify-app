import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/watch_item.dart';

class WatchlistService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'watchlist',
  );

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
    await _collection.doc(id).update({"isWatched": isWatched});
  }
}
