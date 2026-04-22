import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/food_item.dart';
import 'models/order_item.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';
import 'services/food_service.dart';
import 'services/order_service.dart';

class AppState {
  final AuthService authService = AuthService();
  final FoodService foodService = FoodService();
  final OrderService orderService = OrderService();

  String selectedCategory = 'Tất cả';
  String searchText = '';
  final Map<int, int> cart = {};

  List<FoodItem> foods = [];
  List<OrderItem> orderHistory = [];
  OrderItem? currentOrder;

  UserModel? currentUser;
  bool isLoggedIn = false;

  static const String loggedInKey = 'is_logged_in';
  static const String currentUserEmailKey = 'current_user_email';
  static const String currentUserNameKey = 'current_user_name';
  static const String currentUserRoleKey = 'current_user_role';
  static const String currentUserIdKey = 'current_user_id';

  Future<void> init() async {
    await authService.seedAdmin();
    await foodService.seedFoodsIfEmpty();
    await loadFoods();
    await loadOrders();
    await _loadSession();
  }

  Future<void> loadFoods() async {
    foods = await foodService.getFoods();
  }

  Future<void> loadOrders() async {
    orderHistory = await orderService.getOrders();
    if (orderHistory.isNotEmpty) {
      currentOrder = orderHistory.first;
    }
  }

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

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loggedInKey, isLoggedIn);

    if (currentUser != null) {
      await prefs.setInt(currentUserIdKey, currentUser!.id ?? 0);
      await prefs.setString(currentUserEmailKey, currentUser!.email);
      await prefs.setString(currentUserNameKey, currentUser!.fullName);
      await prefs.setString(currentUserRoleKey, currentUser!.role);
    } else {
      await prefs.remove(currentUserIdKey);
      await prefs.remove(currentUserEmailKey);
      await prefs.remove(currentUserNameKey);
      await prefs.remove(currentUserRoleKey);
    }
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool(loggedInKey) ?? false;

    if (isLoggedIn) {
      currentUser = UserModel(
        id: prefs.getInt(currentUserIdKey),
        fullName: prefs.getString(currentUserNameKey) ?? '',
        email: prefs.getString(currentUserEmailKey) ?? '',
        password: '',
        role: prefs.getString(currentUserRoleKey) ?? 'user',
      );
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final ok = await authService.register(
      UserModel(
        fullName: fullName.trim(),
        email: email.trim(),
        password: password.trim(),
        role: 'user',
      ),
    );

    if (!ok) return false;

    currentUser = await authService.login(email.trim(), password.trim());
    isLoggedIn = currentUser != null;
    await _saveSession();
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    currentUser = await authService.login(email.trim(), password.trim());
    isLoggedIn = currentUser != null;
    await _saveSession();
    return isLoggedIn;
  }

  Future<void> logout() async {
    currentUser = null;
    isLoggedIn = false;
    cart.clear();
    await _saveSession();
  }

  bool get isAdmin => currentUser?.role == 'admin';

  void addToCart(FoodItem food, {int quantity = 1}) {
    if (food.id == null) return;
    cart[food.id!] = (cart[food.id!] ?? 0) + quantity;
  }

  void increaseQuantity(int foodId) {
    cart[foodId] = (cart[foodId] ?? 0) + 1;
  }

  void decreaseQuantity(int foodId) {
    if (!cart.containsKey(foodId)) return;
    final newValue = (cart[foodId] ?? 0) - 1;
    if (newValue <= 0) {
      cart.remove(foodId);
    } else {
      cart[foodId] = newValue;
    }
  }

  int getFoodQuantity(int foodId) => cart[foodId] ?? 0;

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

    final newId = await orderService.addOrder(order);
    currentOrder = order.copyWith(id: newId);

    await loadOrders();
    cart.clear();
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
      currentOrder = currentOrder!.copyWith(
        status: statuses[currentIndex + 1],
      );

      await orderService.updateOrder(currentOrder!);
      await loadOrders();
    }
  }

  Future<void> addFood(FoodItem food) async {
    await foodService.addFood(food);
    await loadFoods();
  }

  Future<void> updateFood(FoodItem food) async {
    await foodService.updateFood(food);
    await loadFoods();
  }

  Future<void> deleteFood(int id) async {
    await foodService.deleteFood(id);
    cart.remove(id);
    await loadFoods();
  }
}