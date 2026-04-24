import 'package:flutter/material.dart';
import '../../app_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLoginSuccess;

  const LoginPage({
    super.key,
    required this.appState,
    required this.onLoginSuccess,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final success = await widget.appState.login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      widget.onLoginSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai email hoặc mật khẩu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCDEAAF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🍔', style: TextStyle(fontSize: 46)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Admin mẫu: admin@gmail.com / 123456',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 28),
                const Text('Email', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration('Nhập email'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Mật khẩu', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: _inputDecoration('Nhập mật khẩu').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Mật khẩu phải từ 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: handleLogin,
                    style: FilledButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Đăng nhập'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterPage(
                            appState: widget.appState,
                            onRegisterSuccess: widget.onLoginSuccess,
                          ),
                        ),
                      );
                    },
                    child: const Text('Chưa có tài khoản? Đăng ký'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }
}