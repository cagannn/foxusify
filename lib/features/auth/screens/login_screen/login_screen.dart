import 'package:flutter/material.dart';
import 'package:foxusify/features/pomodoro/screens/main_screen/main_screen.dart';
import '../../../../components/colors.dart';
import '../../../../components/text_styles.dart';
import '../../../../widgets/auth_template.dart';
import '../../../../widgets/custom_input_field.dart';
import '../../../../widgets/action_button.dart';
import '../../../../widgets/social_login_section.dart';
import '../signup_screen/signup_screen.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  final supabase = Supabase.instance.client;
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

          CustomInputField(
            hintText: loc.email,
            icon: Icons.email_outlined,
            onChanged: (value) => {_email = value},
          ),
          CustomInputField(
            hintText: loc.password,
            icon: Icons.lock_outline,
            isPassword: true,
            onChanged: (value) => {_password = value},
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
          ActionButton(
            text: loc.login,
            onPressed: () async {
              if (_email.isEmpty || _password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email ve şifre boş olamaz.")),
                );
                ();
                return;
              }
              try {
                final res = await supabase.auth.signInWithPassword(
                  email: _email,
                  password: _password,
                );
                final user = res.user;
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainScreen()),
                  );
                }
              } on AuthApiException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Şifre veya e-posta hatalı.")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Giriş başarısız: ${e.toString()}")),
                );
              }
            },
          ),
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
