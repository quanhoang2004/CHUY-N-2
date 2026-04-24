import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/food_item.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_page.dart';
import '../widgets/section_header.dart';

class HomePage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onGoOrders;
  final VoidCallback onStateChanged;

  const HomePage({
    super.key,
    required this.appState,
    required this.onGoOrders,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final foods = appState.filteredFoods;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFFFF1E8),
                          child: Icon(
                            Icons.location_on,
                            color: Color(0xFFEE4D2D),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giao đến',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Hà Nội',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.notifications_none),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: onGoOrders,
                          child: Stack(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.shopping_cart_outlined),
                              ),
                              if (appState.cartCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${appState.cartCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          appState.searchText = value;
                          onStateChanged();
                        },
                        decoration: InputDecoration(
                          hintText: 'Tìm món ăn, quán ăn...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEE4D2D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _PromoBanner(onGoOrders: onGoOrders),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  children: [
                    const SectionHeader(
                      title: 'Danh mục',
                      actionLabel: 'Xem tất cả',
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appState.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, index) {
                          final category = appState.categories[index];
                          final selected =
                              appState.selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              appState.selectedCategory = category;
                              onStateChanged();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFFFF1E8)
                                    : const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFFEE4D2D)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _categoryEmoji(category),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      color: selected
                                          ? const Color(0xFFEE4D2D)
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                child: const SectionHeader(
                  title: 'Món nổi bật',
                  actionLabel: 'Xem tất cả',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final FoodItem food = foods[index];
                    return FoodCard(
                      food: food,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FoodDetailPage(
                              food: food,
                              onAddToCart: (quantity) {
                                appState.addToCart(food, quantity: quantity);
                                onStateChanged();
                              },
                            ),
                          ),
                        );
                      },
                      onAdd: () {
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
                    );
                  },
                  childCount: foods.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final VoidCallback onGoOrders;

  const _PromoBanner({required this.onGoOrders});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEE4D2D),
            Color(0xFFFF7A45),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deal ăn ngon\nGiảm đến 50%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Áp dụng cho nhiều món hot hôm nay',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🍔🍟🥤',
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(
                height: 38,
                child: FilledButton(
                  onPressed: onGoOrders,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFEE4D2D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Đặt ngay',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _categoryEmoji(String category) {
  switch (category) {
    case 'Burger':
      return '🍔';
    case 'Pizza':
      return '🍕';
    case 'Thịt':
      return '🍖';
    case 'Hotdog':
      return '🌭';
    default:
      return '🍽️';
  }
}