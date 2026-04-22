import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodItem food;
  final ValueChanged<int> onAddToCart;

  const FoodDetailPage({
    super.key,
    required this.food,
    required this.onAddToCart,
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int quantity = 1;

  String _formatPrice(int price) {
    final text = price.toString();
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
    final food = widget.food;
    final total = food.price * quantity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chi tiết món'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            color: food.color.withOpacity(0.18),
            child: Center(
              child: Text(
                food.emoji,
                style: const TextStyle(fontSize: 110),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text('${food.rating}'),
                      const SizedBox(width: 14),
                      const Icon(Icons.timer_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text('${food.minutes} phút'),
                      const SizedBox(width: 14),
                      const Icon(Icons.local_fire_department_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text('${food.kcal} kcal'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${_formatPrice(food.price)} đ',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFEE4D2D),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: FilledButton(
                            onPressed: () {
                              widget.onAddToCart(quantity);
                              Navigator.pop(context);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFEE4D2D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              'Thêm ${_formatPrice(total)} đ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}