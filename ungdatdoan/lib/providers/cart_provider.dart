import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/food_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  String couponCode = '';
  int discountAmount = 0;

  List<CartItemModel> get items => _items.values.toList();

  int get totalQuantity {
    int total = 0;
    for (final item in _items.values) {
      total += item.quantity;
    }
    return total;
  }

  int get subTotal {
    int total = 0;
    for (final item in _items.values) {
      total += item.total;
    }
    return total;
  }

  int get deliveryFee => _items.isEmpty ? 0 : 15000;

  int get finalTotal {
    final total = subTotal + deliveryFee - discountAmount;
    return total < 0 ? 0 : total;
  }

  void addToCart(FoodModel food, {int quantity = 1}) {
    if (_items.containsKey(food.id)) {
      _items[food.id]!.quantity += quantity;
    } else {
      _items[food.id] = CartItemModel(food: food, quantity: quantity);
    }

    notifyListeners();
  }

  void increase(String foodId) {
    if (!_items.containsKey(foodId)) return;
    _items[foodId]!.quantity++;
    notifyListeners();
  }

  void decrease(String foodId) {
    if (!_items.containsKey(foodId)) return;

    if (_items[foodId]!.quantity <= 1) {
      _items.remove(foodId);
    } else {
      _items[foodId]!.quantity--;
    }

    notifyListeners();
  }

  bool applyCoupon(String code) {
    final upperCode = code.trim().toUpperCase();

    if (upperCode == 'GIAM20') {
      couponCode = upperCode;
      discountAmount = (subTotal * 0.2).toInt();
      notifyListeners();
      return true;
    }

    if (upperCode == 'FREESHIP') {
      couponCode = upperCode;
      discountAmount = deliveryFee;
      notifyListeners();
      return true;
    }

    couponCode = '';
    discountAmount = 0;
    notifyListeners();
    return false;
  }

  void clearCoupon() {
    couponCode = '';
    discountAmount = 0;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    clearCoupon();
    notifyListeners();
  }
}