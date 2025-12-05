import 'package:flutter/material.dart';
import '../components/colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AppLogo({super.key, this.size = 80, this.iconSize = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,

      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
