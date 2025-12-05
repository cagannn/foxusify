import 'package:flutter/material.dart';
import '../components/colors.dart';
import 'social_circle_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("- or -", style: TextStyle(color: AppColors.textLight)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialCircleButton(icon: Icons.g_mobiledata, color: Colors.red),
            SizedBox(width: 20),
            SocialCircleButton(icon: Icons.facebook, color: Colors.blue),
          ],
        ),
      ],
    );
  }
}
