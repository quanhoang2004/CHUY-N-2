import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/demo_data.dart';
import 'models/food_item.dart';
import 'models/order_item.dart';
import 'models/user_model.dart';

class AppState {
  List<UserModel> users = [];
  UserModel? currentUser;
  bool isLoggedIn = false;

  List<FoodItem> foods = [];
  List<OrderItem> orderHistory = [];
  OrderItem? currentOrder;

  String selectedCategory = 'Tất cả';
  String searchText = '';

  final Map<String, int> cart = {};
  List<String> favoriteFoodIds = [];

  static const String usersKey = 'users_data';
  static const String foodsKey = 'foods_data';
  static const String ordersKey = 'orders_data';
  static const String currentOrderKey = 'current_order_data';
  static const String loggedInKey = 'is_logged_in';
  static const String currentUserKey = 'current_user_data';
  static const String favoritesKey = 'favorite_food_ids';

  Future<void> init() async {
    try {
      await _loadUsers();
    } catch (e) {
      users = [];
      print('_loadUsers lỗi: $e');
    }

    try {
      await _loadFoods();
    } catch (e) {
      foods = [];
      print('_loadFoods lỗi: $e');
    }

    try {
      await _loadOrders();
    } catch (e) {
      orderHistory = [];
      currentOrder = null;
      print('_loadOrders lỗi: $e');
    }

    try {
      await _loadSession();
    } catch (e) {
      currentUser = null;
      isLoggedIn = false;
      print('_loadSession lỗi: $e');
    }

    try {
      await _loadFavorites();
    } catch (e) {
      favoriteFoodIds = [];
      print('_loadFavorites lỗi: $e');
    }

    if (users.isEmpty) {
      users = [
        const UserModel(
          id: 'admin_1',
          fullName: 'Quản trị viên',
          email: 'admin@gmail.com',
          password: '123456',
          role: 'admin',
        ),
      ];
      await _saveUsers();
    }

    if (foods.isEmpty) {
      foods = List.from(demoFoods);
      await _saveFoods();
    }
  }

  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    users = [];
    currentUser = null;
    isLoggedIn = false;
    foods = [];
    orderHistory = [];
    currentOrder = null;
    selectedCategory = 'Tất cả';
    searchText = '';
    cart.clear();
    favoriteFoodIds = [];
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = users.map((e) => e.toMap()).toList();
    await prefs.setString(usersKey, jsonEncode(data));
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(usersKey);

    if (raw == null || raw.isEmpty) {
      users = [];
      return;
    }

    try {
      final decoded = jsonDecode(raw) as List;
      users = decoded
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      users = [];
      await prefs.remove(usersKey);
      print('JSON users lỗi: $e');
    }
  }

  Future<void> _saveFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final data = foods.map((e) => e.toMap()).toList();
    await prefs.setString(foodsKey, jsonEncode(data));
  }

  Future<void> _loadFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(foodsKey);

    if (raw == null || raw.isEmpty) {
      foods = [];
      return;
    }

    try {
      final decoded = jsonDecode(raw) as List;
      foods = decoded
          .map((e) => FoodItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      foods = [];
      await prefs.remove(foodsKey);
      print('JSON foods lỗi: $e');
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = orderHistory.map((e) => e.toMap()).toList();
    await prefs.setString(ordersKey, jsonEncode(data));

    if (currentOrder != null) {
      await prefs.setString(currentOrderKey, jsonEncode(currentOrder!.toMap()));
    } else {
      await prefs.remove(currentOrderKey);
    }
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final rawOrders = prefs.getString(ordersKey);
    if (rawOrders != null && rawOrders.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawOrders) as List;
        orderHistory = decoded
            .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      } catch (e) {
        orderHistory = [];
        await prefs.remove(ordersKey);
        print('JSON orders lỗi: $e');
      }
    } else {
      orderHistory = [];
    }

    final rawCurrent = prefs.getString(currentOrderKey);
    if (rawCurrent != null && rawCurrent.isNotEmpty) {
      try {
        currentOrder = OrderItem.fromMap(
          Map<String, dynamic>.from(jsonDecode(rawCurrent)),
        );
      } catch (e) {
        currentOrder = null;
        await prefs.remove(currentOrderKey);
        print('JSON currentOrder lỗi: $e');
      }
    } else {
      currentOrder = null;
    }
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loggedInKey, isLoggedIn);

    if (currentUser != null) {
      await prefs.setString(currentUserKey, jsonEncode(currentUser!.toMap()));
    } else {
      await prefs.remove(currentUserKey);
    }
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool(loggedInKey) ?? false;
    final raw = prefs.getString(currentUserKey);

    if (raw == null || raw.isEmpty) {
      currentUser = null;
      return;
    }

    try {
      currentUser = UserModel.fromMap(
        Map<String, dynamic>.from(jsonDecode(raw)),
      );
    } catch (e) {
      currentUser = null;
      isLoggedIn = false;
      await prefs.remove(currentUserKey);
      await prefs.setBool(loggedInKey, false);
      print('JSON currentUser lỗi: $e');
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoritesKey, favoriteFoodIds);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteFoodIds = prefs.getStringList(favoritesKey) ?? [];
  }

  bool get isAdmin => currentUser?.role == 'admin';

  List<String> get categories {
    return ['Tất cả', ...foods.map((e) => e.category).toSet()];
  }

  List<FoodItem> get filteredFoods {
    return foods.where((food) {
      final matchCategory =
          selectedCategory == 'Tất cả' || food.category == selectedCategory;
      final matchSearch =
      food.name.toLowerCase().contains(searchText.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  List<FoodItem> get searchedFoods {
    if (searchText.trim().isEmpty) return foods;
    return foods.where((food) {
      return food.name.toLowerCase().contains(searchText.toLowerCase()) ||
          food.category.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }

  List<FoodItem> get favoriteFoods {
    return foods.where((food) => favoriteFoodIds.contains(food.id)).toList();
  }

  bool isFavorite(String foodId) {
    return favoriteFoodIds.contains(foodId);
  }

  Future<void> toggleFavorite(String foodId) async {
    if (favoriteFoodIds.contains(foodId)) {
      favoriteFoodIds.remove(foodId);
    } else {
      favoriteFoodIds.add(foodId);
    }
    await _saveFavorites();
  }

  int get cartCount => cart.values.fold(0, (sum, item) => sum + item);

  List<FoodItem> get orderedFoods {
    return foods.where((food) => cart.containsKey(food.id)).toList();
  }

  double get cartTotal {
    double total = 0;
    for (final food in foods) {
      total += food.price * (cart[food.id] ?? 0);
    }
    return total;
  }

  double get deliveryFee => cart.isEmpty ? 0 : 15000;
  double get taxFee => cartTotal * 0.08;
  double get grandTotal => cartTotal + deliveryFee + taxFee;

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final exists = users.any(
          (u) => u.email.trim().toLowerCase() == email.trim().toLowerCase(),
    );

    if (exists) return false;

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: email.trim(),
      password: password.trim(),
      role: 'user',
    );

    users.add(user);
    currentUser = user;
    isLoggedIn = true;

    await _saveUsers();
    await _saveSession();
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = users.firstWhere(
            (u) =>
        u.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            u.password == password.trim(),
      );

      currentUser = user;
      isLoggedIn = true;
      await _saveSession();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    currentUser = null;
    isLoggedIn = false;
    cart.clear();
    searchText = '';
    selectedCategory = 'Tất cả';
    await _saveSession();
  }

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

  int getFoodQuantity(String foodId) => cart[foodId] ?? 0;

  String _generateOrderCode() {
    final random = Random();
    final number = 100000 + random.nextInt(900000);
    return 'FD$number';
  }

  Future<void> checkout({
    required String paymentMethod,
    required String customerName,
    required String phone,
    required String address,
    required String note,
  }) async {
    if (cart.isEmpty) return;

    final order = OrderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderCode: _generateOrderCode(),
      totalAmount: grandTotal.toInt(),
      paymentMethod: paymentMethod,
      status: 'Đang chuẩn bị',
      createdAt: DateTime.now().toIso8601String(),
      customerName: customerName,
      phone: phone,
      address: address,
      note: note,
    );

    currentOrder = order;
    orderHistory.insert(0, order);
    cart.clear();

    await _saveOrders();
  }

  Future<void> advanceOrderStatus() async {
    if (currentOrder == null) return;

    const statuses = [
      'Đang chuẩn bị',
      'Đã lấy hàng',
      'Đang giao',
      'Đã giao',
    ];

    final currentIndex = statuses.indexOf(currentOrder!.status);
    if (currentIndex >= 0 && currentIndex < statuses.length - 1) {
      final updated = currentOrder!.copyWith(
        status: statuses[currentIndex + 1],
      );

      currentOrder = updated;

      final historyIndex = orderHistory.indexWhere((e) => e.id == updated.id);
      if (historyIndex != -1) {
        orderHistory[historyIndex] = updated;
      }

      await _saveOrders();
    }
  }

  Future<void> addFood(FoodItem food) async {
    foods.insert(0, food);
    await _saveFoods();
  }

  Future<void> updateFood(FoodItem food) async {
    final index = foods.indexWhere((e) => e.id == food.id);
    if (index != -1) {
      foods[index] = food;
      await _saveFoods();
    }
  }

  Future<void> deleteFood(String foodId) async {
    foods.removeWhere((e) => e.id == foodId);
    cart.remove(foodId);
    favoriteFoodIds.remove(foodId);
    await _saveFoods();
    await _saveFavorites();
  }
}