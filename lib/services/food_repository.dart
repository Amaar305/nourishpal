import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nourishpal/home/models/food_item.dart';

class FoodRepository {
  late Box<FoodItem> _box;

  Future<void> init() async {
    _box = Hive.box<FoodItem>('food_items');
  }

  List<FoodItem> get items => _box.values.toList();

  Future<void> add(FoodItem item) async {
    await _box.add(item);
  }

  int expiringTomorrowCount() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return items.where((e) {
      final d = DateTime(e.expiry.year, e.expiry.month, e.expiry.day);
      return d == tomorrow;
    }).length;
  }

  static String fmt(DateTime d) => DateFormat('d MMM, yyyy').format(d);
}
