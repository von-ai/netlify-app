import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/watch_item.dart';

class HomeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _watchlist =>
      _db.collection("users").doc(_uid).collection("watchlist");

  Stream<DocumentSnapshot> getUserStream() {
    return _db.collection("users").doc(_uid).snapshots();
  }

  Stream<List<WatchItem>> getBaruDitambahkan() {
    return _watchlist
        .where("createdAt", isNotEqualTo: null)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map(
                (doc) => WatchItem.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .where((item) => item.currentEpisode == 0)
              .toList();
        });
  }

  Stream<List<WatchItem>> getBaruDiupdate() {
    return _watchlist
        .where("updatedAt", isNotEqualTo: null)
        .orderBy("updatedAt", descending: true)
        .limit(2)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map(
                (doc) => WatchItem.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .where((item) => item.currentEpisode > 0)
              .toList();
        });
  }

  Future<void> updateEpisode(String id, int episode) async {
    await _watchlist.doc(id).update({
      "currentEpisode": episode,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addItem(Map<String, dynamic> data) async {
    final now = DateTime.now();

    await _watchlist.add({
      ...data,
      "createdAt": now,
      "updatedAt": now,
      "currentEpisode": 0,
    });
  }
}
