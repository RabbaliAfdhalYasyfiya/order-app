import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'screen/pages/auth/login_page.dart';
import 'screen/pages/splash_page.dart';
import 'screen/pages/welcome_page.dart';
import 'screen/main_page.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _currentScreen;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      setState(() {
        _currentScreen = const WelcomePage();
      });

      await prefs.setBool('isFirstTime', false);
    } else {
      _checkAuthState();
    }
  }

  void _checkAuthState() {
    final userRef = FirebaseFirestore.instance;
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          await Future.delayed(const Duration(milliseconds: 2500));
          setState(() {
            _currentScreen = const LoginPage();
          });

          
        } else {
          final userSnapshot = await userRef.collection('tenants').doc(user.uid).get();
          await Future.delayed(const Duration(milliseconds: 2500));
          setState(() {
            if (userSnapshot.exists) {
              _currentScreen = const MainPage();
            } else {
              _currentScreen = const WelcomePage();
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: lightMode,
      home: _currentScreen ?? const SplashPage(),
    );
  }
}
