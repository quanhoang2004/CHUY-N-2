import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/home_page.dart';
import 'screens/orders_page.dart';
import 'widgets/nav_item_button.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF7F5EE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCDEAAF),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AppState appState = AppState();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        appState: appState,
        onGoOrders: () {
          setState(() {
            currentIndex = 1;
          });
        },
        onStateChanged: () {
          setState(() {});
        },
      ),
      OrdersPage(
        appState: appState,
        onStateChanged: () {
          setState(() {});
        },
      ),
      const PlaceholderScreen(title: 'Search'),
      const PlaceholderScreen(title: 'Saved'),
      const PlaceholderScreen(title: 'Profile'),
    ];

    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
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
                  label: 'Home',
                  selected: currentIndex == 0,
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                ),
                NavItemButton(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Orders',
                  selected: currentIndex == 1,
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                ),
                NavItemButton(
                  icon: Icons.search,
                  label: 'Search',
                  selected: currentIndex == 2,
                  onTap: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                ),
                NavItemButton(
                  icon: Icons.bookmark_border,
                  label: 'Saved',
                  selected: currentIndex == 3,
                  onTap: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                ),
                NavItemButton(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  selected: currentIndex == 4,
                  onTap: () {
                    setState(() {
                      currentIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}