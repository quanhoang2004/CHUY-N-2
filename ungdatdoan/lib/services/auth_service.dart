import '../models/user_model.dart';
import 'db_helper.dart';

class AuthService {
  Future<void> seedAdmin() async {
    final db = await DBHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: ['admin@gmail.com'],
      limit: 1,
    );

    if (result.isEmpty) {
      await db.insert(
        'users',
        const UserModel(
          fullName: 'Quản trị viên',
          email: 'admin@gmail.com',
          password: '123456',
          role: 'admin',
        ).toMap(),
      );
    }
  }

  Future<bool> register(UserModel user) async {
    final db = await DBHelper.database;

    final exists = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
      limit: 1,
    );

    if (exists.isNotEmpty) {
      return false;
    }

    await db.insert('users', user.toMap());
    return true;
  }

  Future<UserModel?> login(String email, String password) async {
    final db = await DBHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }
}