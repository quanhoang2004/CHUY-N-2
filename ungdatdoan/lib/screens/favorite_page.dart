import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/food_item.dart';
import '../widgets/food_detail_page.dart';

class FavoritePage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const FavoritePage({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

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
    final foods = appState.favoriteFoods;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Món yêu thích',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: foods.isEmpty
                    ? const Center(
                  child: Text(
                    'Bạn chưa lưu món yêu thích nào',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                    : ListView.separated(
                  itemCount: foods.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final FoodItem food = foods[index];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
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
                            child: InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FoodDetailPage(
                                      food: food,
                                      onAddToCart: (quantity) {
                                        appState.addToCart(
                                          food,
                                          quantity: quantity,
                                        );
                                        onStateChanged();
                                      },
                                    ),
                                  ),
                                );
                              },
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
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await appState.toggleFavorite(food.id);
                                  onStateChanged();
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  appState.addToCart(food);
                                  onStateChanged();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${food.name} đã thêm vào giỏ'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEE4D2D),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}