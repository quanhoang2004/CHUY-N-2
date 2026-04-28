import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get uid => auth.currentUser!.uid;

  Stream<List<String>> getFavoriteIds() {
    return db.collection('favorites').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return [];
      final data = doc.data() ?? {};
      return List<String>.from(data['foodIds'] ?? []);
    });
  }

  Future<void> toggleFavorite(String foodId) async {
    final ref = db.collection('favorites').doc(uid);
    final doc = await ref.get();

    List<String> ids = [];

    if (doc.exists) {
      ids = List<String>.from(doc.data()?['foodIds'] ?? []);
    }

    if (ids.contains(foodId)) {
      ids.remove(foodId);
    } else {
      ids.add(foodId);
    }

    await ref.set({'foodIds': ids});
  }
}