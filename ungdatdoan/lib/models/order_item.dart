class OrderItem {
  final String id;
  final String orderCode;
  final int totalAmount;
  final String paymentMethod;
  final String status;
  final String createdAt;
  final String customerName;
  final String phone;
  final String address;
  final String note;

  const OrderItem({
    required this.id,
    required this.orderCode,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.note,
  });

  OrderItem copyWith({
    String? id,
    String? orderCode,
    int? totalAmount,
    String? paymentMethod,
    String? status,
    String? createdAt,
    String? customerName,
    String? phone,
    String? address,
    String? note,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderCode': orderCode,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'note': note,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      orderCode: map['orderCode'] ?? '',
      totalAmount: map['totalAmount'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      customerName: map['customerName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      note: map['note'] ?? '',
    );
  }
}