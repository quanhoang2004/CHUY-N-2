import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/auth/login_page.dart';
import 'screens/cart_page.dart';
import 'screens/home_page.dart';
import 'screens/order_history_page.dart';
import 'screens/profile_page.dart';
import 'screens/search_page.dart';
import 'screens/favorite_page.dart';
import 'screens/admin_food_page.dart';
import 'screens/admin_order_page.dart';
import 'screens/admin_order_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primary = Color(0xFFEE4D2D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopeeFood Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        return const MainPage();
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  bool get isAdmin {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return email == 'admin@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const CartPage(),
      isAdmin ? const AdminFoodPage() : const SearchPage(),
      const FavoritePage(),
      isAdmin ? const AdminOrderPage() : const OrderHistoryPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(33),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _nav(Icons.home_outlined, 'Trang chủ', 0),
                _nav(Icons.shopping_cart_outlined, 'Giỏ hàng', 1),
                _nav(
                  isAdmin ? Icons.storefront_outlined : Icons.search,
                  isAdmin ? 'Admin' : 'Tìm kiếm',
                  2,
                ),
                _nav(Icons.favorite_border, 'Yêu thích', 3),
                _nav(Icons.receipt_long_outlined, 'Đơn hàng', 4),
                _nav(Icons.person_outline, 'Tài khoản', 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nav(IconData icon, String label, int index) {
    final selected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 10 : 0,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? const Color(0xFFEE4D2D) : Colors.white,
              size: 20,
            ),
            if (selected) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}