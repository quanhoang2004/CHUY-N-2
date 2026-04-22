import 'package:flutter/material.dart';

class FoodItem {
  final int? id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final int kcal;
  final int discount;
  final int minutes;
  final int colorValue;
  final String emoji;
  final String description;
  final String deliveryMan;

  const FoodItem({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.kcal,
    required this.discount,
    required this.minutes,
    required this.colorValue,
    required this.emoji,
    required this.description,
    required this.deliveryMan,
  });

  Color get color => Color(colorValue);

  FoodItem copyWith({
    int? id,
    String? name,
    String? category,
    int? price,
    double? rating,
    int? kcal,
    int? discount,
    int? minutes,
    int? colorValue,
    String? emoji,
    String? description,
    String? deliveryMan,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      kcal: kcal ?? this.kcal,
      discount: discount ?? this.discount,
      minutes: minutes ?? this.minutes,
      colorValue: colorValue ?? this.colorValue,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      deliveryMan: deliveryMan ?? this.deliveryMan,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'kcal': kcal,
      'discount': discount,
      'minutes': minutes,
      'colorValue': colorValue,
      'emoji': emoji,
      'description': description,
      'deliveryMan': deliveryMan,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: map['price'] ?? 0,
      rating: (map['rating'] as num).toDouble(),
      kcal: map['kcal'] ?? 0,
      discount: map['discount'] ?? 0,
      minutes: map['minutes'] ?? 0,
      colorValue: map['colorValue'] ?? 0,
      emoji: map['emoji'] ?? '🍔',
      description: map['description'] ?? '',
      deliveryMan: map['deliveryMan'] ?? '',
    );
  }
}