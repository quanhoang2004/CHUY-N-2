import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addReview({
    required String foodId,
    required String foodName,
    required int rating,
    required String comment,
  }) async {
    final user = auth.currentUser;
    if (user == null) return;

    await db.collection('reviews').add({
      'foodId': foodId,
      'foodName': foodName,
      'userId': user.uid,
      'userEmail': user.email ?? '',
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getReviewsByFood(String foodId) {
    return db
        .collection('reviews')
        .where('foodId', isEqualTo: foodId)
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      reviews.sort((a, b) {
        final aTime = a['createdAt'];
        final bTime = b['createdAt'];

        if (aTime is Timestamp && bTime is Timestamp) {
          return bTime.compareTo(aTime);
        }

        return 0;
      });

      return reviews;
    });
  }
}