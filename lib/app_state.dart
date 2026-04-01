import 'dart:math';
import 'data/demo_data.dart';
import 'models/food_item.dart';
import 'models/order_item.dart';

class AppState {
  String selectedCategory = 'All';
  String searchText = '';
  final Map<String, int> cart = {};

  final List<OrderItem> orderHistory = [];
  OrderItem? currentOrder;

  List<String> get categories {
    return ['All', ...demoFoods.map((e) => e.category).toSet()];
  }

  List<FoodItem> get filteredFoods {
    return demoFoods.where((food) {
      final matchCategory =
          selectedCategory == 'All' || food.category == selectedCategory;
      final matchSearch =
      food.name.toLowerCase().contains(searchText.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  int get cartCount {
    return cart.values.fold(0, (sum, item) => sum + item);
  }

  double get cartTotal {
    double total = 0;
    for (final food in demoFoods) {
      total += food.price * (cart[food.id] ?? 0);
    }
    return total;
  }

  double get deliveryFee => cart.isEmpty ? 0 : 2.50;

  double get taxFee => cartTotal * 0.08;

  double get grandTotal => cartTotal + deliveryFee + taxFee;

  void addToCart(FoodItem food, {int quantity = 1}) {
    cart[food.id] = (cart[food.id] ?? 0) + quantity;
  }

  void increaseQuantity(String foodId) {
    cart[foodId] = (cart[foodId] ?? 0) + 1;
  }

  void decreaseQuantity(String foodId) {
    if (!cart.containsKey(foodId)) return;
    final newValue = (cart[foodId] ?? 0) - 1;
    if (newValue <= 0) {
      cart.remove(foodId);
    } else {
      cart[foodId] = newValue;
    }
  }

  int getFoodQuantity(String foodId) {
    return cart[foodId] ?? 0;
  }

  List<FoodItem> get orderedFoods {
    return demoFoods.where((food) => cart.containsKey(food.id)).toList();
  }

  String _generateOrderCode() {
    final random = Random();
    final number = 100000 + random.nextInt(900000);
    return 'FD$number';
  }

  void checkout(String paymentMethod) {
    if (cart.isEmpty) return;

    final order = OrderItem(
      orderCode: _generateOrderCode(),
      totalAmount: grandTotal,
      paymentMethod: paymentMethod,
      status: 'Preparing',
      createdAt: DateTime.now(),
    );

    currentOrder = order;
    orderHistory.insert(0, order);
    cart.clear();
  }

  void advanceOrderStatus() {
    if (currentOrder == null) return;

    const statuses = [
      'Preparing',
      'Picked Up',
      'On The Way',
      'Delivered',
    ];

    final currentIndex = statuses.indexOf(currentOrder!.status);
    if (currentIndex >= 0 && currentIndex < statuses.length - 1) {
      final updated = currentOrder!.copyWith(
        status: statuses[currentIndex + 1],
      );

      currentOrder = updated;

      final historyIndex =
      orderHistory.indexWhere((e) => e.orderCode == updated.orderCode);
      if (historyIndex != -1) {
        orderHistory[historyIndex] = updated;
      }
    }
  }

  double itemTotal(FoodItem food) {
    return (cart[food.id] ?? 0) * food.price;
  }
}