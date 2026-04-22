import '../data/demo_data.dart';
import '../models/food_item.dart';
import 'db_helper.dart';

class FoodService {
  Future<void> seedFoodsIfEmpty() async {
    final db = await DBHelper.database;
    final result = await db.query('foods', limit: 1);

    if (result.isEmpty) {
      for (final food in demoFoods) {
        await db.insert('foods', food.toMap());
      }
    }
  }

  Future<List<FoodItem>> getFoods() async {
    final db = await DBHelper.database;
    final result = await db.query('foods', orderBy: 'id DESC');
    return result.map((e) => FoodItem.fromMap(e)).toList();
  }

  Future<int> addFood(FoodItem food) async {
    final db = await DBHelper.database;
    return db.insert('foods', food.toMap());
  }

  Future<int> updateFood(FoodItem food) async {
    final db = await DBHelper.database;
    return db.update(
      'foods',
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  Future<int> deleteFood(int id) async {
    final db = await DBHelper.database;
    return db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }
}