import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/food_service.dart';

class AdminFoodPage extends StatefulWidget {
  const AdminFoodPage({super.key});

  @override
  State<AdminFoodPage> createState() => _AdminFoodPageState();
}

class _AdminFoodPageState extends State<AdminFoodPage> {
  final foodService = FoodService();

  void openFoodForm({FoodModel? food}) {
    final nameController = TextEditingController(text: food?.name ?? '');
    final categoryController = TextEditingController(text: food?.category ?? '');
    final imageController = TextEditingController(text: food?.imageUrl ?? '');
    final priceController =
    TextEditingController(text: food == null ? '' : food.price.toString());
    final descController = TextEditingController(text: food?.description ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  food == null ? 'Thêm món mới' : 'Sửa món',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                _field(nameController, 'Tên món'),
                _field(categoryController, 'Danh mục'),
                _field(imageController, 'Link ảnh'),
                _field(priceController, 'Giá', number: true),
                _field(descController, 'Mô tả'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () async {
                      final newFood = FoodModel(
                        id: food?.id ?? '',
                        name: nameController.text.trim(),
                        category: categoryController.text.trim(),
                        imageUrl: imageController.text.trim(),
                        price: int.tryParse(priceController.text.trim()) ?? 0,
                        rating: food?.rating ?? 4.5,
                        minutes: food?.minutes ?? 20,
                        discount: food?.discount ?? 0,
                        description: descController.text.trim(),
                        isAvailable: true,
                      );

                      if (food == null) {
                        await foodService.addFood(newFood);
                      } else {
                        await foodService.updateFood(newFood);
                      }

                      if (mounted) Navigator.pop(context);
                    },
                    child: Text(food == null ? 'Thêm món' : 'Lưu thay đổi'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _field(
      TextEditingController controller,
      String hint, {
        bool number = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: hint,
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin quản lý món'),
        actions: [
          IconButton(
            onPressed: () => openFoodForm(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<FoodModel>>(
        stream: foodService.getFoods(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final foods = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: foods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final food = foods[index];

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
                        food.imageUrl,
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
                            food.name,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(food.category),
                          Text(
                            '${formatPrice(food.price)} đ',
                            style: const TextStyle(color: Color(0xFFEE4D2D)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => openFoodForm(food: food),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        await foodService.deleteFood(food.id);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}