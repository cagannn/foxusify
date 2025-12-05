import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foxusify/screens/login_screen/login_screen.dart';
import 'package:foxusify/screens/main_screen/main_screen.dart';
import 'package:foxusify/widgets/rounded_navbar.dart';
import 'l10n/app_localizations.dart';

import 'screens/login_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Desteklenen diller
      supportedLocales: const [Locale('en'), Locale('tr')],

      // Lokalizasyon delegeleri
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Cihaz diline göre otomatik seçim
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first; // eşleşmezse ilkini kullan
      },

      home: LoginScreen(),
    );
  }
}
