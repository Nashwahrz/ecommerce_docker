import 'package:flutter/material.dart';
import 'package:pruductservice/screen/login_screen.dart';
import 'package:pruductservice/screen/register_screen.dart'; // Pastikan file ini ada
import 'package:pruductservice/screen/splash_screen.dart';
import 'package:pruductservice/screen/user_screen.dart';
import 'package:pruductservice/screen/product_list_screen.dart';
import 'package:pruductservice/screen/review_list_screen.dart';
import 'package:pruductservice/screen/add_review_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Halaman awal saat aplikasi dibuka
      home: SplashScreen(),

      // === ROUTES ===
      // Menggunakan routes memudahkan pindah halaman dengan Navigator.pushNamed
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/user_list': (context) => UserScreen(),
        '/product_list': (context) => ProductListScreen(),
        // '/review_list': (context) => ReviewListScreen(),
        // '/add_review': (context) => AddReviewScreen(),
      },
    );
  }
}