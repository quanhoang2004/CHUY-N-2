import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/food_item.dart';

class AdminFoodPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onStateChanged;

  const AdminFoodPage({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  @override
  State<AdminFoodPage> createState() => _AdminFoodPageState();
}

class _AdminFoodPageState extends State<AdminFoodPage> {
  Future<void> _showFoodDialog({FoodItem? food}) async {
    final nameController = TextEditingController(text: food?.name ?? '');
    final categoryController = TextEditingController(text: food?.category ?? '');
    final priceController = TextEditingController(text: food?.price.toString() ?? '');
    final emojiController = TextEditingController(text: food?.emoji ?? '🍔');
    final descriptionController =
    TextEditingController(text: food?.description ?? '');
    final deliveryManController =
    TextEditingController(text: food?.deliveryMan ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(food == null ? 'Thêm món ăn' : 'Sửa món ăn'),
          content: SizedBox(
            width: 360,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Tên món'),
                      validator: (v) => v == null || v.isEmpty ? 'Nhập tên món' : null,
                    ),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Danh mục'),
                      validator: (v) => v == null || v.isEmpty ? 'Nhập danh mục' : null,
                    ),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Giá'),
                      validator: (v) => v == null || v.isEmpty ? 'Nhập giá' : null,
                    ),
                    TextFormField(
                      controller: emojiController,
                      decoration: const InputDecoration(labelText: 'Emoji'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Mô tả'),
                    ),
                    TextFormField(
                      controller: deliveryManController,
                      decoration: const InputDecoration(labelText: 'Người giao'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final item = FoodItem(
                  id: food?.id,
                  name: nameController.text.trim(),
                  category: categoryController.text.trim(),
                  price: int.tryParse(priceController.text.trim()) ?? 0,
                  rating: food?.rating ?? 4.5,
                  kcal: food?.kcal ?? 100,
                  discount: food?.discount ?? 10,
                  minutes: food?.minutes ?? 20,
                  colorValue: food?.colorValue ?? 0xFFCDEAAF,
                  emoji: emojiController.text.trim().isEmpty
                      ? '🍔'
                      : emojiController.text.trim(),
                  description: descriptionController.text.trim(),
                  deliveryMan: deliveryManController.text.trim(),
                );

                if (food == null) {
                  await widget.appState.addFood(item);
                } else {
                  await widget.appState.updateFood(item);
                }

                widget.onStateChanged();
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = widget.appState.foods;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Quản lý món ăn',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton(
                  onPressed: () => _showFoodDialog(),
                  child: const Text('Thêm món'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemCount: foods.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final food = foods[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Text(food.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
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
                              Text(food.category),
                              Text('${food.price} đ'),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showFoodDialog(food: food),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (food.id != null) {
                              await widget.appState.deleteFood(food.id!);
                              widget.onStateChanged();
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}