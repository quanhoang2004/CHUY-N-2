import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_model.dart';
import '../providers/cart_provider.dart';
import '../services/favorite_service.dart';
import '../services/food_service.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteService = FavoriteService();
    final foodService = FoodService();

    return Scaffold(
      appBar: AppBar(title: const Text('Món yêu thích')),
      body: StreamBuilder<List<String>>(
        stream: favoriteService.getFavoriteIds(),
        builder: (context, favSnapshot) {
          if (!favSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = favSnapshot.data!;

          return StreamBuilder<List<FoodModel>>(
            stream: foodService.getFoods(),
            builder: (context, foodSnapshot) {
              if (!foodSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final foods = foodSnapshot.data!
                  .where((food) => favoriteIds.contains(food.id))
                  .toList();

              if (foods.isEmpty) {
                return const Center(child: Text('Bạn chưa có món yêu thích'));
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodDetailPage(
                            food: food,
                            onAdd: (quantity) {
                              context
                                  .read<CartProvider>()
                                  .addToCart(food, quantity: quantity);
                            },
                          ),
                        ),
                      );
                    },
                    onAdd: () {
                      context.read<CartProvider>().addToCart(food);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}