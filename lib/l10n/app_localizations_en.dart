// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Foxusify';

  @override
  String get hello => 'Hello';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get pleaseLogin => 'Please login to your account.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get forgetPass => 'Forgot Password?';

  @override
  String get createAccount => 'Create a new account';

  @override
  String get username => 'Username';

  @override
  String get confirmPass => 'Confirm Your Password';

  @override
  String get home => 'Home';

  @override
  String get placement => 'Placement';

  @override
  String get profile => 'Profile';

  @override
  String get passwordDoNotMatch =>
      'Confirm password havew to same as your password';
}
