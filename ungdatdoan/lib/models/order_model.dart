import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String userEmail;
  final int totalAmount;
  final int discountAmount;
  final int deliveryFee;
  final String couponCode;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final String address;
  final String phone;
  final String note;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.totalAmount,
    required this.discountAmount,
    required this.deliveryFee,
    required this.couponCode,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.address,
    required this.phone,
    required this.note,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      totalAmount: (map['totalAmount'] as num?)?.toInt() ?? 0,
      discountAmount: (map['discountAmount'] as num?)?.toInt() ?? 0,
      deliveryFee: (map['deliveryFee'] as num?)?.toInt() ?? 0,
      couponCode: map['couponCode'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      status: map['status'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      note: map['note'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}