import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_model.dart';
import '../providers/cart_provider.dart';
import '../services/food_service.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_page.dart';
import '../widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FoodService foodService = FoodService();

  String searchText = '';
  String selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    foodService.seedDemoFoods();
  }

  List<String> getCategories(List<FoodModel> foods) {
    return ['Tất cả', ...foods.map((e) => e.category).toSet()];
  }

  List<FoodModel> filterFoods(List<FoodModel> foods) {
    return foods.where((food) {
      final matchSearch =
          food.name.toLowerCase().contains(searchText.toLowerCase()) ||
              food.category.toLowerCase().contains(searchText.toLowerCase());

      final matchCategory =
          selectedCategory == 'Tất cả' || food.category == selectedCategory;

      return matchSearch && matchCategory;
    }).toList();
  }

  void openFoodDetail(FoodModel food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailPage(
          food: food,
          onAdd: (quantity) {
            context.read<CartProvider>().addToCart(food, quantity: quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${food.name} đã thêm vào giỏ'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: StreamBuilder<List<FoodModel>>(
          stream: foodService.getFoods(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            }

            final allFoods = snapshot.data ?? [];
            final categories = getCategories(allFoods);
            final foods = filterFoods(allFoods);

            return CustomScrollView(
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
                              backgroundColor: Color(0xFFFFE4D8),
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
                                  Text(
                                    'Hà Nội',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                IconButton.filled(
                                  onPressed: () {},
                                  icon: const Icon(Icons.shopping_cart_outlined),
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFFF7F7F7),
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                                if (cart.totalQuantity > 0)
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: CircleAvatar(
                                      radius: 9,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '${cart.totalQuantity}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
                              setState(() => searchText = value);
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
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 120,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFEE4D2D),
                                Color(0xFFFF7A45),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Deal ăn ngon\nGiảm đến 50%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text('🍔🍟🥤', style: TextStyle(fontSize: 36)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8),
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
                            itemCount: categories.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(width: 10),
                            itemBuilder: (_, index) {
                              final category = categories[index];
                              final selected = selectedCategory == category;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
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
                                  child: Center(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: selected
                                            ? const Color(0xFFEE4D2D)
                                            : Colors.black87,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: const SectionHeader(
                      title: 'Món nổi bật',
                      actionLabel: 'Xem tất cả',
                    ),
                  ),
                ),
                if (foods.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('Không có món phù hợp')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final food = foods[index];

                          return FoodCard(
                            food: food,
                            onTap: () => openFoodDetail(food),
                            onAdd: () {
                              context.read<CartProvider>().addToCart(food);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${food.name} đã thêm vào giỏ'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
                        childCount: foods.length,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}