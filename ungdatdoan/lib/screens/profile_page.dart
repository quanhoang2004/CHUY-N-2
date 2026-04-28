import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = AuthService();
  final userService = UserService();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool isEditing = false;
  bool loaded = false;

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    await userService.updateProfile(
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );

    setState(() {
      isEditing = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu hồ sơ')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: userService.getMyProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          if (!loaded) {
            fullNameController.text = data['fullName'] ?? '';
            phoneController.text = data['phone'] ?? '';
            addressController.text = data['address'] ?? '';
            loaded = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFFFE4D8),
                  child: Icon(Icons.person, size: 42, color: Colors.black),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vai trò: ${data['role'] ?? 'user'}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: fullNameController,
                        enabled: isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Họ và tên',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      TextField(
                        controller: phoneController,
                        enabled: isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Số điện thoại',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      TextField(
                        controller: addressController,
                        enabled: isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Địa chỉ mặc định',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      if (isEditing) {
                        saveProfile();
                      } else {
                        setState(() {
                          isEditing = true;
                        });
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Text(isEditing ? 'Lưu hồ sơ' : 'Chỉnh sửa hồ sơ'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () async {
                      await auth.logout();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Đăng xuất'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}