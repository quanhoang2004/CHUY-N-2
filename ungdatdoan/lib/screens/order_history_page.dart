import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

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

  Color statusColor(String status) {
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

  Color paymentColor(String paymentStatus) {
    return paymentStatus == 'Đã thanh toán' ? Colors.green : Colors.orange;
  }

  int statusStep(String status) {
    switch (status) {
      case 'Đang chuẩn bị':
        return 0;
      case 'Đang giao':
        return 1;
      case 'Đã giao':
        return 2;
      case 'Đã hủy':
        return -1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getMyOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final order = orders[index];
              final step = statusStep(order.status);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn: ${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text('SĐT: ${order.phone}'),
                    Text('Địa chỉ: ${order.address}'),
                    if (order.note.isNotEmpty) Text('Ghi chú: ${order.note}'),
                    Text('Thanh toán: ${order.paymentMethod}'),
                    Text(
                      'Trạng thái thanh toán: ${order.paymentStatus}',
                      style: TextStyle(
                        color: paymentColor(order.paymentStatus),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (order.couponCode.isNotEmpty)
                      Text('Mã giảm giá: ${order.couponCode}'),
                    const SizedBox(height: 6),
                    Text(
                      'Tổng tiền: ${formatPrice(order.totalAmount)} đ',
                      style: const TextStyle(
                        color: Color(0xFFEE4D2D),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: statusColor(order.status),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (order.status == 'Đã hủy')
                      const Text(
                        'Đơn hàng đã bị hủy',
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      Row(
                        children: [
                          statusDot('Chuẩn bị', step >= 0),
                          line(step >= 1),
                          statusDot('Đang giao', step >= 1),
                          line(step >= 2),
                          statusDot('Đã giao', step >= 2),
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

  Widget statusDot(String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: active ? const Color(0xFFEE4D2D) : Colors.grey[300],
          child: Icon(
            Icons.check,
            color: active ? Colors.white : Colors.grey,
            size: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget line(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: active ? const Color(0xFFEE4D2D) : Colors.grey[300],
      ),
    );
  }
}