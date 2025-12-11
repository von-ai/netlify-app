import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:project_mobile/models/watch_item.dart';

class HomeProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<WatchItem>> get updatedStream {
    return _firestore
        .collection('watchlist')
        .where(
          'updatedAt',
          isGreaterThan: DateTime.now().subtract(const Duration(days: 3)),
        )
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => WatchItem.fromFirestore(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<WatchItem>> get newAddedStream {
    return _firestore
        .collection('watchlist')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => WatchItem.fromFirestore(d.data(), d.id))
              .toList(),
        );
  }

  Stream<Map<String, dynamic>> get userStream {
    final userId = FirebaseFirestore.instance.app.options.projectId;
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((d) => d.data() ?? {});
  }
}
