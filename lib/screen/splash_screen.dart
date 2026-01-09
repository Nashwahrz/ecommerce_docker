import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pruductservice/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _mickeyPositionX = -0.6;
  double _opacity = 0.0;
  double _logoOpacity = 0.0;
  bool _showButton = false;
  bool _isNavigated = false; // Flag agar tidak navigasi double

  late AnimationController _animationController;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    // 1. Jalankan Animasi Mickey & Logo
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _mickeyPositionX = 0.35;
          _logoOpacity = 1.0;
        });
        _animationController.forward();
      }
    });

    // 2. Munculkan tombol setelah 2 detik
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showButton = true);
    });

    // 3. AUTO-NAVIGATE: Pindah otomatis ke Login setelah 6 detik
    Timer(const Duration(seconds: 6), () {
      _navigateToLogin();
    });
  }

  // Fungsi navigasi agar tidak bentrok antara tombol dan auto-timer
  void _navigateToLogin() {
    if (!_isNavigated && mounted) {
      _isNavigated = true;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 900),
          pageBuilder: (_, __, ___) =>  LoginScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Kastil Lebih Besar & Tetap Elegan
          Positioned(
            top: screenHeight * 0.05, // Posisi agak ke atas
            right: -40, // Melebar ke luar layar sedikit agar estetik
            child: Opacity(
              opacity: 0.06, // Sedikit lebih tegas dari sebelumnya
              child: Image.asset(
                'asset/kastil.png',
                width: screenWidth * 0.8, // Ukuran 80% lebar layar
              ),
            ),
          ),

          // 2. Mickey Berjalan (Area Atas)
          AnimatedPositioned(
            duration: const Duration(seconds: 3),
            curve: Curves.easeInOutQuart,
            left: screenWidth * _mickeyPositionX,
            top: screenHeight * 0.22,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  Image.asset('asset/miki.png', height: 130),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.elliptical(40, 3)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Logo & Judul Boutique (Tengah)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: AnimatedOpacity(
                opacity: _logoOpacity,
                duration: const Duration(seconds: 1),
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMinimalistMickey(),
                      const SizedBox(height: 20),
                      const Text(
                        "MICKEY",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 10,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "MART",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Tombol & Auto-skip Hint (Bawah)
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: AnimatedOpacity(
              opacity: _showButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _navigateToLogin, // Navigasi manual
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: const Text(
                        "BELANJA SEKARANG",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Entering Clubhouse Shop...",
                    style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalistMickey() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
      ],
    );
  }
}