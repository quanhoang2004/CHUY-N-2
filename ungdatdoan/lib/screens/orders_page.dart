import 'package:flutter/material.dart';
import '../app_state.dart';
import 'checkout_page.dart';
import '../widgets/quantity_button.dart';

class OrdersPage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const OrdersPage({
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
    final orderedFoods = appState.orderedFoods;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Text(
            'Đơn hàng',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: orderedFoods.isEmpty
                ? const Center(
              child: Text('Chưa có món nào trong giỏ hàng'),
            )
                : ListView.separated(
              itemCount: orderedFoods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, index) {
                final food = orderedFoods[index];
                final qty = appState.getFoodQuantity(food.id);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: food.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          food.emoji,
                          style: const TextStyle(fontSize: 38),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.category,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_formatPrice(food.price)} đ',
                              style: const TextStyle(
                                color: Color(0xFFEE4D2D),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          QuantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              appState.decreaseQuantity(food.id);
                              onStateChanged();
                            },
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '$qty',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          QuantityButton(
                            icon: Icons.add,
                            onTap: () {
                              appState.increaseQuantity(food.id);
                              onStateChanged();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (orderedFoods.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  _priceRow('Tạm tính', appState.cartTotal),
                  const SizedBox(height: 8),
                  _priceRow('Phí giao hàng', appState.deliveryFee),
                  const SizedBox(height: 8),
                  _priceRow('Thuế', appState.taxFee),
                  const Divider(height: 24),
                  _priceRow('Tổng cộng', appState.grandTotal, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutPage(
                        appState: appState,
                        onStateChanged: onStateChanged,
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                ),
                child: const Text('Thanh toán'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          '${_formatPrice(value)} đ',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}