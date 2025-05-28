// main.dart

import 'package:flutter/material.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Screens
import 'package:my_app/screens/auth/register_screen.dart';
import 'package:my_app/screens/onboarding/onboarding_screen.dart';
import 'package:my_app/screens/auth/login_screen.dart';
import 'package:my_app/screens/home_page/home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Network',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),      
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
