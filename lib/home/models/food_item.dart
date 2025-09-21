import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 0)
class FoodItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String quantity;

  @HiveField(2)
  final DateTime expiry;

  @HiveField(3)
  final String category;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.expiry,
    required this.category,
  });
}
