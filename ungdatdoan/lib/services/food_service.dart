import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<FoodModel>> getFoods() {
    return db.collection('foods').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addFood(FoodModel food) async {
    await db.collection('foods').add(food.toMap());
  }

  Future<void> updateFood(FoodModel food) async {
    await db.collection('foods').doc(food.id).update(food.toMap());
  }

  Future<void> deleteFood(String id) async {
    await db.collection('foods').doc(id).delete();
  }

  Future<void> seedDemoFoods() async {
    final snapshot = await db.collection('foods').limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final foods = [
      const FoodModel(
        id: '',
        name: 'Burger Bò Phô Mai',
        category: 'Burger',
        imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        price: 82000,
        rating: 4.6,
        minutes: 20,
        discount: 40,
        description: 'Burger bò phô mai thơm ngon, thịt nướng mềm, sốt đậm vị.',
        isAvailable: true,
      ),
      const FoodModel(
        id: '',
        name: 'Pizza Margarita',
        category: 'Pizza',
        imageUrl:
        'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3',
        price: 81000,
        rating: 4.5,
        minutes: 25,
        discount: 20,
        description: 'Pizza phô mai mozzarella và sốt cà chua.',
        isAvailable: true,
      ),
      const FoodModel(
        id: '',
        name: 'Gà Rán Giòn Cay',
        category: 'Gà rán',
        imageUrl:
        'https://images.unsplash.com/photo-1562967914-608f82629710',
        price: 69000,
        rating: 4.7,
        minutes: 18,
        discount: 15,
        description: 'Gà rán giòn cay, nóng hổi, ăn kèm sốt đặc biệt.',
        isAvailable: true,
      ),
      const FoodModel(
        id: '',
        name: 'Mì Ý Bò Bằm',
        category: 'Mì Ý',
        imageUrl:
        'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9',
        price: 75000,
        rating: 4.4,
        minutes: 22,
        discount: 10,
        description: 'Mì Ý sốt bò bằm đậm đà.',
        isAvailable: true,
      ),
    ];

    for (final food in foods) {
      await addFood(food);
    }
  }
}