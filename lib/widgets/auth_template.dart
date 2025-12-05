import 'package:flutter/material.dart';
import '../components/colors.dart';
import 'login_logo.dart';

class AuthTemplate extends StatelessWidget {
  final Widget formContent;
  final double logoTopPosition;

  const AuthTemplate({
    super.key,
    required this.formContent,
    this.logoTopPosition = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundYellow,
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: size.height * logoTopPosition,
              left: 0,
              right: 0,
              child: const Center(child: AppLogo(size: 150)),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.85,
                  minHeight: size.height * 0.6,
                ),
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                decoration: const BoxDecoration(
                  color: AppColors.cardCream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(child: formContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
