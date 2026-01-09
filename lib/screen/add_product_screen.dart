import 'package:flutter/material.dart';
import 'package:pruductservice/services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  final ProductService _productService = ProductService();

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String name = _nameController.text;
      int price = int.parse(_priceController.text);
      String desc = _descController.text;

      bool success = await _productService.addProduct(name, price, desc);

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hot Dog! Produk berhasil ditambahkan!"),
            backgroundColor: Colors.black,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oh no! Gagal menambahkan produk."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Item", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Ikon Dekorasi Mickey di atas Form
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Colors.black, radius: 15),
                  SizedBox(width: 5),
                  CircleAvatar(backgroundColor: Colors.black, radius: 25),
                  SizedBox(width: 5),
                  CircleAvatar(backgroundColor: Colors.black, radius: 15),
                ],
              ),
              const SizedBox(height: 30),

              // Input Nama Produk
              _buildMickeyTextField(
                controller: _nameController,
                label: "Product Name",
                icon: Icons.shopping_bag,
                accentColor: Colors.red,
                validator: (value) => value!.isEmpty ? "Gosh! Nama jangan kosong ya" : null,
              ),
              const SizedBox(height: 20),

              // Input Harga
              _buildMickeyTextField(
                controller: _priceController,
                label: "Price (Rp)",
                icon: Icons.monetization_on,
                accentColor: Colors.black,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Harga harus diisi!";
                  if (int.tryParse(value) == null) return "Gunakan angka saja ya!";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Deskripsi
              _buildMickeyTextField(
                controller: _descController,
                label: "Description",
                icon: Icons.description,
                accentColor: Colors.yellow[800]!,
                maxLines: 3,
                validator: (value) => value!.isEmpty ? "Tulis deskripsinya juga!" : null,
              ),
              const SizedBox(height: 40),

              // Tombol Simpan Mickey Style
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "ADD TO CLUBHOUSE",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("See Ya Real Soon!", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper UI untuk TextField Mickey Style
  Widget _buildMickeyTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accentColor,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, color: accentColor),
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}