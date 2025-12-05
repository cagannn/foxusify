import 'package:flutter/material.dart';
import '../components/colors.dart';

class SocialCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SocialCircleButton({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
