import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get uid => auth.currentUser!.uid;

  Future<void> createUserIfNotExists() async {
    final user = auth.currentUser;
    if (user == null) return;

    final ref = db.collection('users').doc(user.uid);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'uid': user.uid,
        'email': user.email ?? '',
        'fullName': '',
        'phone': '',
        'address': '',
        'role': user.email == 'admin@gmail.com' ? 'admin' : 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<Map<String, dynamic>> getMyProfile() {
    return db.collection('users').doc(uid).snapshots().map((doc) {
      return doc.data() ?? {};
    });
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String address,
  }) async {
    await db.collection('users').doc(uid).update({
      'fullName': fullName,
      'phone': phone,
      'address': address,
    });
  }
}