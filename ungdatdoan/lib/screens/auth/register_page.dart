import 'package:flutter/material.dart';
import '../../app_state.dart';

class RegisterPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onRegisterSuccess;

  const RegisterPage({
    super.key,
    required this.appState,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    if (!formKey.currentState!.validate()) return;

    final success = await widget.appState.register(
      fullName: fullNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      widget.onRegisterSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email đã tồn tại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EE),
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Điền đầy đủ thông tin để bắt đầu sử dụng ứng dụng',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                const Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: fullNameController,
                  decoration: _inputDecoration('Nhập họ và tên'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                const Text('Xác nhận mật khẩu', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: _inputDecoration('Nhập lại mật khẩu'),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: handleRegister,
                    style: FilledButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Đăng ký'),
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