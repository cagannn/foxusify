import 'package:flutter/material.dart';
import 'package:foxusify/l10n/app_localizations.dart';
import '../../components/colors.dart';
import '../../components/text_styles.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/action_button.dart';
import '../../widgets/social_circle_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundYellow,
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: AppColors.cardCream,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(loc.signup, style: AppTextStyles.header),
                    const SizedBox(height: 5),
                    Text(loc.createAccount, style: AppTextStyles.subHeader),
                    const SizedBox(height: 30),

                    CustomInputField(
                      hintText: loc.username,
                      icon: Icons.person_outline,
                    ),
                    CustomInputField(
                      hintText: loc.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomInputField(
                      hintText: loc.password,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    CustomInputField(
                      hintText: loc.confirmPass,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),
                    ActionButton(text: loc.createAccount, onPressed: () {}),

                    const SizedBox(height: 20),
                    const Text("or", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialCircleButton(
                          icon: Icons.g_mobiledata,
                          color: Colors.red,
                        ),
                        SizedBox(width: 20),
                        SocialCircleButton(
                          icon: Icons.facebook,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        loc.login,
                        style: TextStyle(
                          color: AppColors.darkOrange,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
