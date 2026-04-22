import '../models/order_item.dart';
import 'db_helper.dart';

class OrderService {
  Future<int> addOrder(OrderItem order) async {
    final db = await DBHelper.database;
    return db.insert('orders', order.toMap());
  }

  Future<List<OrderItem>> getOrders() async {
    final db = await DBHelper.database;
    final result = await db.query('orders', orderBy: 'id DESC');
    return result.map((e) => OrderItem.fromMap(e)).toList();
  }

  Future<int> updateOrder(OrderItem order) async {
    final db = await DBHelper.database;
    return db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }
}