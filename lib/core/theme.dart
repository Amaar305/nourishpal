import 'package:flutter/material.dart';

class AppColors {
  // tuned to match the mock
  static const seed = Color(0xFF1C6B3D); // deep green seed
  static const green = Color(0xFF2E7D4A);
  static const cream = Color(0xFFF7F4EE);
  static const card = Color(0xFFF2EFE7);
  static const peach = Color(0xFFF6D9B8);
}

ThemeData buildTheme() {
  final base = ThemeData(colorSchemeSeed: AppColors.seed, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.cream,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF3EDE4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        minimumSize: const Size.fromHeight(52),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      foregroundColor: Colors.black87,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
  );
}
