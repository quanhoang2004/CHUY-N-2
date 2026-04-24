import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/food_item.dart';
import '../widgets/food_detail_page.dart';

class SearchPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const SearchPage({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();

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
    final foods = widget.appState.searchedFoods;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    widget.appState.searchText = value;
                    widget.onStateChanged();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm món ăn, danh mục...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.text.isEmpty
                        ? null
                        : IconButton(
                      onPressed: () {
                        controller.clear();
                        widget.appState.searchText = '';
                        widget.onStateChanged();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: foods.isEmpty
                    ? const Center(
                  child: Text(
                    'Không tìm thấy món phù hợp',
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
                    final isFav = widget.appState.isFavorite(food.id);

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
                                        widget.appState.addToCart(
                                          food,
                                          quantity: quantity,
                                        );
                                        widget.onStateChanged();
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
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('${food.rating}'),
                                      const SizedBox(width: 10),
                                      Text('${food.minutes} phút'),
                                    ],
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
                                  await widget.appState.toggleFavorite(food.id);
                                  widget.onStateChanged();
                                  setState(() {});
                                },
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? Colors.red
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  widget.appState.addToCart(food);
                                  widget.onStateChanged();
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