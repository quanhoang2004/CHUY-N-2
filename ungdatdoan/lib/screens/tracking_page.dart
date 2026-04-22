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
            Text('Mã đơn: ${order.orderCode}'),
            Text('Khách hàng: ${order.customerName}'),
            Text('SĐT: ${order.phone}'),
            Text('Địa chỉ: ${order.address}'),
            Text('Tổng tiền: ${order.totalAmount} đ'),
            Text('Trạng thái: ${order.status}'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (_, index) {
                  final done = index <= currentIndex;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: done ? Colors.green : Colors.grey.shade300,
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
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child: Text(order.status == 'Đã giao'
                    ? 'Đơn hàng đã giao'
                    : 'Cập nhật trạng thái'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}