import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/text_styles.dart';
import '../../widgets/auth_template.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/action_button.dart';
import '../../widgets/social_login_section.dart';
import '../signup_screen/signup_screen.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AuthTemplate(
      logoTopPosition: 0.12,
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(loc.hello, style: AppTextStyles.header),
          const SizedBox(height: 8),
          Text(loc.pleaseLogin, style: AppTextStyles.subHeader),
          const SizedBox(height: 40),

          CustomInputField(hintText: loc.email, icon: Icons.email_outlined),
          CustomInputField(
            hintText: loc.password,
            icon: Icons.lock_outline,
            isPassword: true,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                loc.forgetPass,
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          ),

          const SizedBox(height: 20),
          ActionButton(text: loc.login, onPressed: () {}),
          const SizedBox(height: 30),

          const SocialLoginSection(),

          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            ),
            child: Text(
              loc.createAccount,
              style: TextStyle(
                color: AppColors.darkOrange,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
