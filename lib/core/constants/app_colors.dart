import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryDarkBlue = Color(0xFF1E40AF);
  static const Color textPrimary = Color(0xFF374151);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFBFDBFE);

  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;
  static const Color info = Colors.blue;
  static const Color purple = Colors.purple;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryDarkBlue],
  );
}