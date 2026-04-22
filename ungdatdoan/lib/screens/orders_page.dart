import 'package:flutter/material.dart';
import '../app_state.dart';
import 'checkout_page.dart';
import '../widgets/food_emoji_art.dart';
import '../widgets/quantity_button.dart';

class OrdersPage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const OrdersPage({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

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
                final qty = appState.getFoodQuantity(food.id!);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: food.color,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          FoodEmojiArt(emoji: food.emoji, size: 72),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('${food.price} đ'),
                          const Spacer(),
                          QuantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              appState.decreaseQuantity(food.id!);
                              onStateChanged();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('$qty'),
                          ),
                          QuantityButton(
                            icon: Icons.add,
                            onTap: () {
                              appState.increaseQuantity(food.id!);
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
                  _priceRow('Phí giao hàng', appState.deliveryFee),
                  _priceRow('Thuế', appState.taxFee),
                  const Divider(),
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
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
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
          '${value.toStringAsFixed(0)} đ',
          style: TextStyle(fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
        ),
      ],
    );
  }
}