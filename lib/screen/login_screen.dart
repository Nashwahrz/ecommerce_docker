import 'package:flutter/material.dart';
import 'package:pruductservice/screen/product_list_screen.dart';
import 'package:pruductservice/services/user_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Untuk feedback visual saat login

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gosh! Isi email dan passwordmu dulu ya!"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await UserService().login(_emailController.text, _passwordController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selamat Datang Kembali!"), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Gagal: ${result['message']}"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header: Mickey Head Shape Design
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 50),
                    // Representasi Ikonik Telinga & Kepala Mickey
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMickeyEar(),
                        const SizedBox(width: 10),
                        _buildMickeyEar(),
                      ],
                    ),
                    const Icon(Icons.circle, color: Colors.yellow, size: 80),
                    const SizedBox(height: 10),
                    const Text(
                      "MICKEY LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // Email Input
                  _buildMickeyInput(
                    controller: _emailController,
                    label: "Email Address",
                    icon: Icons.email,
                    accentColor: Colors.black,
                  ),
                  const SizedBox(height: 20),

                  // Password Input
                  _buildMickeyInput(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    accentColor: Colors.red,
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  // Login Button
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Mickey's Pants
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register Link
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                    child: RichText(
                      text: const TextSpan(
                        text: "New to the Club? ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: "Register here!",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Telinga Mickey
  Widget _buildMickeyEar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
      ),
    );
  }

  // Widget Helper untuk Input Box
  Widget _buildMickeyInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accentColor,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: accentColor),
        prefixIcon: Icon(icon, color: accentColor),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
    );
  }
}