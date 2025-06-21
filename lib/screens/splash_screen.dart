import 'package:flutter/material.dart';
import 'package:novel_app/screens/main_navigation_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainPage();
  }

  Future<void> _navigateToMainPage() async {
    await Future.delayed(const Duration(seconds: 6));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/libera_splash.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),

            // ),
          ],
        ),
      ),
    );
  }
}
