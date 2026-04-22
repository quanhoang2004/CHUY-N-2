import 'package:flutter/material.dart';
import '../app_state.dart';
import 'order_history_page.dart';

class ProfilePage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFCDEAAF),
            child: Icon(Icons.person, size: 42, color: Colors.black),
          ),
          const SizedBox(height: 16),
          Text(
            user?.fullName ?? 'Người dùng',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(user?.email ?? ''),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                _tile(
                  icon: Icons.history,
                  title: 'Lịch sử đơn hàng',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderHistoryPage(appState: appState),
                      ),
                    );
                  },
                ),
                if (appState.isAdmin) const Divider(),
                if (appState.isAdmin)
                  _tile(
                    icon: Icons.admin_panel_settings,
                    title: 'Bạn đang là admin',
                    onTap: () {},
                  ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onLogout,
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Đăng xuất'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}