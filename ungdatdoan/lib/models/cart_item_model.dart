import 'food_model.dart';

class CartItemModel {
  final FoodModel food;
  int quantity;

  CartItemModel({
    required this.food,
    required this.quantity,
  });

  int get total => food.price * quantity;
}