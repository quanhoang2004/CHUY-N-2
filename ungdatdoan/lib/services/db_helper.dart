import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            role TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE foods(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            price INTEGER NOT NULL,
            rating REAL NOT NULL,
            kcal INTEGER NOT NULL,
            discount INTEGER NOT NULL,
            minutes INTEGER NOT NULL,
            colorValue INTEGER NOT NULL,
            emoji TEXT NOT NULL,
            description TEXT NOT NULL,
            deliveryMan TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderCode TEXT NOT NULL,
            totalAmount INTEGER NOT NULL,
            paymentMethod TEXT NOT NULL,
            status TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            customerName TEXT NOT NULL,
            phone TEXT NOT NULL,
            address TEXT NOT NULL,
            note TEXT NOT NULL
          )
        ''');
      },
    );
  }
}