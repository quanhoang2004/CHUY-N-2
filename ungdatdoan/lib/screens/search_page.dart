import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_model.dart';
import '../providers/cart_provider.dart';
import '../services/food_service.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final foodService = FoodService();
  String keyword = '';

  List<FoodModel> filterFoods(List<FoodModel> foods) {
    if (keyword.trim().isEmpty) return foods;

    return foods.where((food) {
      return food.name.toLowerCase().contains(keyword.toLowerCase()) ||
          food.category.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  void openDetail(FoodModel food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailPage(
          food: food,
          onAdd: (quantity) {
            context.read<CartProvider>().addToCart(food, quantity: quantity);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm món ăn'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => keyword = value),
              decoration: InputDecoration(
                hintText: 'Nhập tên món hoặc danh mục...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<FoodModel>>(
              stream: foodService.getFoods(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final foods = filterFoods(snapshot.data!);

                if (foods.isEmpty) {
                  return const Center(child: Text('Không tìm thấy món ăn'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: foods.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (_, index) {
                    final food = foods[index];

                    return FoodCard(
                      food: food,
                      onTap: () => openDetail(food),
                      onAdd: () {
                        context.read<CartProvider>().addToCart(food);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${food.name} đã thêm vào giỏ')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}