import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelUser.dart';
import 'package:pruductservice/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Oh no! Semua field harus diisi!"), backgroundColor: Colors.redAccent)
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      ModelUser newUser = ModelUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      final result = await UserService().register(newUser);

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hot Dog! Registrasi Berhasil!"), backgroundColor: Colors.green)
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Registrasi Gagal"))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e"))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mickey's Clubhouse", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Mickey Style
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.mouse, color: Colors.yellow, size: 60),
                    const Text(
                      "REGISTER",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _buildMickeyTextField(
                    controller: _nameController,
                    label: "Your Name",
                    icon: Icons.person,
                    accentColor: Colors.red,
                  ),
                  const SizedBox(height: 15),
                  _buildMickeyTextField(
                    controller: _emailController,
                    label: "Disney Email",
                    icon: Icons.email,
                    accentColor: Colors.black,
                  ),
                  const SizedBox(height: 15),
                  _buildMickeyTextField(
                    controller: _passwordController,
                    label: "Secret Password",
                    icon: Icons.lock,
                    accentColor: Colors.yellow[700]!,
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),

                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Mickey's Pants Color
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "SIGN UP NOW",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("See Ya Real Soon!", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Custom Textfield
  Widget _buildMickeyTextField({
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}