import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nourishpal/app_router.dart';
import 'package:nourishpal/core/theme.dart';
import 'package:nourishpal/services/food_repository.dart';
import 'package:nourishpal/services/notification_services.dart';

import 'home/models/food_item.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late final FoodRepository foodRepo;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemAdapter());
  await Hive.openBox<FoodItem>('food_items');

  foodRepo = FoodRepository();
  await foodRepo.init();
  await NotificationService().init(foodRepo);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NourishPal',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router(navigatorKey),
    );
  }
}
