import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({super.key});

  static const List<String> orderStatuses = [
    'Đang chuẩn bị',
    'Đang giao',
    'Đã giao',
    'Đã hủy',
  ];

  static const List<String> paymentStatuses = [
    'Chưa thanh toán',
    'Đã thanh toán',
  ];

  String formatPrice(int price) {
    final text = price.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }

    return buffer.toString().split('').reversed.join();
  }

  Color orderStatusColor(String status) {
    switch (status) {
      case 'Đang chuẩn bị':
        return Colors.orange;
      case 'Đang giao':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  Color paymentStatusColor(String status) {
    return status == 'Đã thanh toán' ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin quản lý đơn hàng'),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(
              child: Text('Chưa có đơn hàng nào'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final order = orders[index];

              final currentOrderStatus =
              orderStatuses.contains(order.status)
                  ? order.status
                  : orderStatuses.first;

              final currentPaymentStatus =
              paymentStatuses.contains(order.paymentStatus)
                  ? order.paymentStatus
                  : paymentStatuses.first;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn: ${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text('Khách hàng: ${order.userEmail}'),
                    Text('SĐT: ${order.phone}'),
                    Text('Địa chỉ: ${order.address}'),

                    if (order.note.isNotEmpty)
                      Text('Ghi chú: ${order.note}'),

                    const SizedBox(height: 8),

                    Text('Phương thức thanh toán: ${order.paymentMethod}'),

                    Text(
                      'Trạng thái thanh toán: ${order.paymentStatus}',
                      style: TextStyle(
                        color: paymentStatusColor(order.paymentStatus),
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    if (order.couponCode.isNotEmpty)
                      Text('Mã giảm giá: ${order.couponCode}'),

                    Text('Phí giao hàng: ${formatPrice(order.deliveryFee)} đ'),

                    if (order.discountAmount > 0)
                      Text(
                        'Giảm giá: -${formatPrice(order.discountAmount)} đ',
                        style: const TextStyle(color: Colors.green),
                      ),

                    const SizedBox(height: 8),

                    Text(
                      'Tổng tiền: ${formatPrice(order.totalAmount)} đ',
                      style: const TextStyle(
                        color: Color(0xFFEE4D2D),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),

                    const Divider(height: 24),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Trạng thái đơn:',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DropdownButton<String>(
                          value: currentOrderStatus,
                          items: orderStatuses.map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: orderStatusColor(status),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            if (value == null) return;

                            await orderService.updateOrderStatus(
                              orderId: order.id,
                              status: value,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Đã cập nhật đơn thành: $value',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Thanh toán:',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DropdownButton<String>(
                          value: currentPaymentStatus,
                          items: paymentStatuses.map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: paymentStatusColor(status),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            if (value == null) return;

                            await orderService.updatePaymentStatus(
                              orderId: order.id,
                              paymentStatus: value,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Đã cập nhật thanh toán: $value',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}