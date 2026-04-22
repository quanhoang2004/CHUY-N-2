import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/admin_food_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/home_page.dart';
import 'screens/order_history_page.dart';
import 'screens/orders_page.dart';
import 'screens/profile_page.dart';
import 'widgets/nav_item_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng giao đồ ăn',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      ),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  final AppState appState = AppState();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    await appState.init();
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!appState.isLoggedIn) {
      return LoginPage(
        appState: appState,
        onLoginSuccess: () {
          setState(() {});
        },
      );
    }

    return MainScreen(
      appState: appState,
      onRefresh: () {
        setState(() {});
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onRefresh;

  const MainScreen({
    super.key,
    required this.appState,
    required this.onRefresh,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        appState: widget.appState,
        onGoOrders: () {
          setState(() {
            currentIndex = 1;
          });
        },
        onStateChanged: () async {
          await widget.appState.loadFoods();
          widget.onRefresh();
          setState(() {});
        },
      ),
      OrdersPage(
        appState: widget.appState,
        onStateChanged: () {
          widget.onRefresh();
          setState(() {});
        },
      ),
      widget.appState.isAdmin
          ? AdminFoodPage(
        appState: widget.appState,
        onStateChanged: () async {
          await widget.appState.loadFoods();
          widget.onRefresh();
          setState(() {});
        },
      )
          : const SearchPlaceholderPage(),
      const FavoritePlaceholderPage(),
      ProfilePage(
        appState: widget.appState,
        onLogout: () async {
          await widget.appState.logout();
          widget.onRefresh();
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(33),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavItemButton(
                  icon: Icons.home_outlined,
                  label: 'Trang chủ',
                  selected: currentIndex == 0,
                  onTap: () => setState(() => currentIndex = 0),
                ),
                NavItemButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Đơn hàng',
                  selected: currentIndex == 1,
                  onTap: () => setState(() => currentIndex = 1),
                ),
                NavItemButton(
                  icon: widget.appState.isAdmin
                      ? Icons.storefront_outlined
                      : Icons.search,
                  label: widget.appState.isAdmin ? 'Quản lý' : 'Tìm kiếm',
                  selected: currentIndex == 2,
                  onTap: () => setState(() => currentIndex = 2),
                ),
                NavItemButton(
                  icon: Icons.favorite_border,
                  label: 'Yêu thích',
                  selected: currentIndex == 3,
                  onTap: () => setState(() => currentIndex = 3),
                ),
                NavItemButton(
                  icon: Icons.person_outline,
                  label: 'Tài khoản',
                  selected: currentIndex == 4,
                  onTap: () => setState(() => currentIndex = 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchPlaceholderPage extends StatelessWidget {
  const SearchPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tìm kiếm',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class FavoritePlaceholderPage extends StatelessWidget {
  const FavoritePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Yêu thích',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}