import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createOrder({
    required int totalAmount,
    required int deliveryFee,
    required int discountAmount,
    required String couponCode,
    required String paymentMethod,
    required String paymentStatus,
    required String address,
    required String phone,
    required String note,
  }) async {
    final user = auth.currentUser;
    if (user == null) return;

    await db.collection('orders').add({
      'userId': user.uid,
      'userEmail': user.email ?? '',
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'discountAmount': discountAmount,
      'couponCode': couponCode,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': 'Đang chuẩn bị',
      'address': address,
      'phone': phone,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<OrderModel>> getMyOrders() {
    final user = auth.currentUser;
    if (user == null) return Stream.value([]);

    return db
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  Stream<List<OrderModel>> getAllOrders() {
    return db.collection('orders').snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await db.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  Future<void> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
  }) async {
    await db.collection('orders').doc(orderId).update({
      'paymentStatus': paymentStatus,
    });
  }
}