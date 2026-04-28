import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService userService = UserService();

  User? get currentUser => _auth.currentUser;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userService.createUserIfNotExists();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'Email không hợp lệ';
      }

      if (e.code == 'user-not-found') {
        return 'Tài khoản chưa tồn tại. Vui lòng đăng ký trước.';
      }

      if (e.code == 'wrong-password') {
        return 'Sai mật khẩu';
      }

      if (e.code == 'invalid-credential') {
        return 'Email hoặc mật khẩu không đúng';
      }

      if (e.code == 'network-request-failed') {
        return 'Lỗi mạng. Vui lòng kiểm tra Internet.';
      }

      return e.message ?? 'Đăng nhập thất bại';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userService.createUserIfNotExists();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email này đã được đăng ký';
      }

      if (e.code == 'weak-password') {
        return 'Mật khẩu quá yếu, vui lòng nhập từ 6 ký tự trở lên';
      }

      if (e.code == 'invalid-email') {
        return 'Email không hợp lệ';
      }

      if (e.code == 'network-request-failed') {
        return 'Lỗi mạng. Vui lòng kiểm tra Internet.';
      }

      return e.message ?? 'Đăng ký thất bại';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'Email không hợp lệ';
      }

      if (e.code == 'user-not-found') {
        return 'Không tìm thấy tài khoản với email này';
      }

      if (e.code == 'network-request-failed') {
        return 'Lỗi mạng. Vui lòng kiểm tra Internet.';
      }

      return e.message ?? 'Không gửi được email đặt lại mật khẩu';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}