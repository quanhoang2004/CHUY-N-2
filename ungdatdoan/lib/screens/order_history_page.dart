import 'package:flutter/material.dart';
import '../app_state.dart';

class OrderHistoryPage extends StatelessWidget {
  final AppState appState;

  const OrderHistoryPage({
    super.key,
    required this.appState,
  });

  String _formatPrice(num price) {
    final text = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    final orders = appState.orderHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final order = orders[index];
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
                  'Mã đơn: ${order.orderCode}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Khách hàng: ${order.customerName}'),
                Text('SĐT: ${order.phone}'),
                Text('Địa chỉ: ${order.address}'),
                Text('Thanh toán: ${order.paymentMethod}'),
                Text('Trạng thái: ${order.status}'),
                Text('Tổng tiền: ${_formatPrice(order.totalAmount)} đ'),
              ],
            ),
          );
        },
      ),
    );
  }
}