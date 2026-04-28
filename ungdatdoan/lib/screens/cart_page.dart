import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Giỏ hàng đang trống'))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final item = cart.items[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          item.food.imageUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 72,
                              height: 72,
                              color: const Color(0xFFFFE4D8),
                              child: const Icon(Icons.fastfood),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text('${formatPrice(item.food.price)} đ'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              cart.decrease(item.food.id);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cart.increase(item.food.id);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                row('Tạm tính', cart.subTotal),
                const SizedBox(height: 8),
                row('Phí giao hàng', cart.deliveryFee),
                if (cart.discountAmount > 0) ...[
                  const SizedBox(height: 8),
                  row('Giảm giá', -cart.discountAmount),
                ],
                const Divider(height: 24),
                row('Tổng cộng', cart.finalTotal, bold: true),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFEE4D2D),
                    ),
                    child: const Text('Đi tới thanh toán'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget row(String label, int price, {bool bold = false}) {
    final isMinus = price < 0;
    final value = price.abs();

    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          '${isMinus ? '-' : ''}${formatPrice(value)} đ',
          style: TextStyle(
            color: isMinus ? Colors.green : Colors.black,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}