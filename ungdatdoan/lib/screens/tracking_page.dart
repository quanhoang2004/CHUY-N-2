import 'package:flutter/material.dart';
import '../app_state.dart';

class TrackingPage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const TrackingPage({
    super.key,
    required this.appState,
    required this.onStateChanged,
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
    final order = appState.currentOrder;

    if (order == null) {
      return const Scaffold(
        body: Center(child: Text('Chưa có đơn hàng')),
      );
    }

    final steps = [
      'Đang chuẩn bị',
      'Đã lấy hàng',
      'Đang giao',
      'Đã giao',
    ];

    final currentIndex = steps.indexOf(order.status);

    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mã đơn: ${order.orderCode}'),
                  const SizedBox(height: 6),
                  Text('Khách hàng: ${order.customerName}'),
                  Text('SĐT: ${order.phone}'),
                  Text('Địa chỉ: ${order.address}'),
                  Text('Tổng tiền: ${_formatPrice(order.totalAmount)} đ'),
                  Text('Trạng thái: ${order.status}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tiến trình đơn hàng',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (_, index) {
                  final done = index <= currentIndex;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                      done ? const Color(0xFFEE4D2D) : Colors.grey.shade300,
                      child: Icon(
                        done ? Icons.check : Icons.circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    title: Text(steps[index]),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: order.status == 'Đã giao'
                    ? null
                    : () async {
                  await appState.advanceOrderStatus();
                  onStateChanged();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackingPage(
                          appState: appState,
                          onStateChanged: onStateChanged,
                        ),
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                ),
                child: Text(
                  order.status == 'Đã giao'
                      ? 'Đơn hàng đã giao'
                      : 'Cập nhật trạng thái',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}