class FoodModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final int price;
  final double rating;
  final int minutes;
  final int discount;
  final String description;
  final bool isAvailable;

  const FoodModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.minutes,
    required this.discount,
    required this.description,
    required this.isAvailable,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map, String id) {
    return FoodModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      minutes: (map['minutes'] as num?)?.toInt() ?? 20,
      discount: (map['discount'] as num?)?.toInt() ?? 0,
      description: map['description'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'minutes': minutes,
      'discount': discount,
      'description': description,
      'isAvailable': isAvailable,
    };
  }
}