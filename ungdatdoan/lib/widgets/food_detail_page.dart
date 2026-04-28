import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/review_service.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodModel food;
  final void Function(int quantity) onAdd;

  const FoodDetailPage({
    super.key,
    required this.food,
    required this.onAdd,
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final ReviewService reviewService = ReviewService();
  final commentController = TextEditingController();

  int quantity = 1;
  int selectedRating = 5;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
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

  Future<void> submitReview() async {
    if (commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung đánh giá')),
      );
      return;
    }

    await reviewService.addReview(
      foodId: widget.food.id,
      foodName: widget.food.name,
      rating: selectedRating,
      comment: commentController.text.trim(),
    );

    commentController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi đánh giá')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: 330,
            width: double.infinity,
            child: Image.network(
              food.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFFFFE4D8),
                  child: const Center(
                    child: Icon(Icons.fastfood, size: 90),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: IconButton.filled(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.62,
            minChildSize: 0.62,
            maxChildSize: 0.92,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(food.category),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text('${food.rating}'),
                        const SizedBox(width: 16),
                        const Icon(Icons.timer_outlined, size: 18),
                        const SizedBox(width: 4),
                        Text('${food.minutes} phút'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '${formatPrice(food.price)} đ',
                      style: const TextStyle(
                        color: Color(0xFFEE4D2D),
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Mô tả',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(food.description),
                    const SizedBox(height: 24),

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
                                    setState(() => quantity--);
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => quantity++);
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
                                widget.onAdd(quantity);
                                Navigator.pop(context);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
                                'Thêm ${formatPrice(food.price * quantity)} đ',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    const Text(
                      'Đánh giá món ăn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = star;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: star <= selectedRating
                                ? Colors.orange
                                : Colors.grey[300],
                          ),
                        );
                      }),
                    ),

                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Nhập đánh giá của bạn...',
                        filled: true,
                        fillColor: const Color(0xFFF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: submitReview,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFEE4D2D),
                        ),
                        child: const Text('Gửi đánh giá'),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Nhận xét gần đây',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),

                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: reviewService.getReviewsByFood(food.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final reviews = snapshot.data!;

                        if (reviews.isEmpty) {
                          return const Text('Chưa có đánh giá nào');
                        }

                        return Column(
                          children: reviews.map((review) {
                            final rating = review['rating'] ?? 5;

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['userEmail'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        Icons.star,
                                        size: 16,
                                        color: index < rating
                                            ? Colors.orange
                                            : Colors.grey[300],
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(review['comment'] ?? ''),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}