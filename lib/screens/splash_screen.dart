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
      body: Stack(
        // Menggunakan Stack untuk menempatkan widget secara berlapis
        children: [
          // Gambar Libera di tengah layar
          Center(
            child: Image.asset(
              'assets/images/libera_splash.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),

          // Teks "from Elsa" diletakkan di bagian bawah layar
          Align(
            alignment:
                Alignment
                    .bottomCenter, // Menempatkan konten di bagian bawah tengah
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 50,
              ), // Jarak dari bawah layar (sisakan sedikit)
              child: Column(
                mainAxisSize:
                    MainAxisSize
                        .min, // Agar Column hanya mengambil ruang secukupnya
                children: const [
                  Text(
                    'from',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey, // Tetap abu-abu untuk "from"
                    ),
                  ),
                  SizedBox(height: 5), // Jarak kecil antara "from" dan "Elsa"
                  Text(
                    'Elsa 😊', // Teks "Elsa" dengan emoji senyum kalem (bukan ketawa)
                    style: TextStyle(
                      fontSize: 28, // Ukuran font "Elsa" sedikit lebih besar
                      fontWeight: FontWeight.bold, // Tebal
                      color: Colors.blue, // Warna biru untuk "Elsa"
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
