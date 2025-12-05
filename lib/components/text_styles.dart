import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle header = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subHeader = TextStyle(
    color: AppColors.textLight,
    fontSize: 14,
  );

  static const TextStyle buttonText = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 1.2,
  );
}
