import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nourishpal/home/home.dart';
import 'package:nourishpal/login/login.dart';
import 'package:nourishpal/splash/pages/splash_page.dart';

class AppRouter {
  static GoRouter router(GlobalKey<NavigatorState> key) => GoRouter(
    navigatorKey: key,
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/welcome', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(path: '/add', builder: (_, __) => const AddFoodPage()),
    ],
  );
}
