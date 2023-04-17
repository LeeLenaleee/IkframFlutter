import 'package:bezetting_indeler/screens/auth_screen.dart';
import 'package:bezetting_indeler/screens/main_screen.dart';
import 'package:bezetting_indeler/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indeler',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('nl', 'NL')],
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.amber,
        // accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        accentIconTheme: IconTheme.of(context).copyWith(
          color: Colors.deepPurple,
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapShot) {
          if (userSnapShot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          if (userSnapShot.hasData) {
            return MainScreen();
          }

          return AuthScreen();
        },
      ),
      routes: {},
    );
  }
}
