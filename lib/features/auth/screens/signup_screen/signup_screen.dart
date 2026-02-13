import 'package:flutter/material.dart';
import 'package:foxusify/l10n/app_localizations.dart';
import '../../../../components/colors.dart';
import '../../../../components/text_styles.dart';
import '../../../../widgets/custom_input_field.dart';
import '../../../../widgets/action_button.dart';
import '../../../../widgets/social_circle_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final supabase = Supabase.instance.client;
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

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
                      onChanged: (value) => {username = value},
                      hintText: loc.username,
                      icon: Icons.person_outline,
                    ),
                    CustomInputField(
                      onChanged: (value) => {email = value},
                      hintText: loc.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomInputField(
                      onChanged: (value) => {password = value},
                      hintText: loc.password,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    CustomInputField(
                      onChanged: (value) => {confirmPassword = value},
                      hintText: loc.confirmPass,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),
                    _isLoading 
                    ? const CircularProgressIndicator(color: AppColors.darkOrange)
                    : ActionButton(
                      text: loc.createAccount,
                      onPressed: () async {
                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.passwordDoNotMatch)),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                           // 1. Check if username exists
                            final usedUsername = await supabase
                                .from('profiles')
                                .select()
                                .eq("username", username);
                                
                            if (usedUsername.isNotEmpty) {
                              throw Exception('Bu kullanıcı adı kullanımda.');
                            }

                            // 2. Sign up
                            final response = await supabase.auth.signUp(
                              email: email.trim(),
                              password: password,
                            );

                            final userId = response.user?.id;

                            // 3. Update profile with username
                            if (userId != null) {
                              await supabase.from('profiles').update({
                                'username': username,
                              }).eq('id', userId);
                            
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Hesap oluşturuldu! Giriş yapabilirsiniz.")),
                                );
                                Navigator.pop(context); // Go back to login
                              }
                            }
                        } on AuthApiException catch (e) {
                           if (mounted) {
                            String message = e.message;
                            if (e.message.contains('Rate limit exceeded')) {
                              message = "Çok fazla deneme yaptınız. Lütfen biraz bekleyin.";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                           }
                        } catch (e) {
                          if (mounted) {
                             String message = e.toString();
                             if (message.contains("Exception: ")) {
                               message = message.replaceAll("Exception: ", "");
                             }
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(message)),
                             );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ),

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
