import 'package:flutter/material.dart';
import 'package:pruductservice/services/product_service.dart';
import '../model/ModelProduct.dart';

class EditProductScreen extends StatefulWidget {
  final Datum product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;

  bool _isLoading = false;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descController = TextEditingController(text: widget.product.description);
  }

  void _updateData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      bool success = await _productService.updateProduct(
        widget.product.id,
        _nameController.text,
        int.parse(_priceController.text),
        _descController.text,
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gosh! Produk berhasil diperbarui!"),
            backgroundColor: Colors.black,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oh no! Gagal memperbarui produk."),
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
        title: const Text("Edit Item", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow), // Ikon back jadi kuning
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dekorasi Telinga Mickey (Versi Edit)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Colors.red, radius: 15),
                  SizedBox(width: 5),
                  CircleAvatar(backgroundColor: Colors.black, radius: 25),
                  SizedBox(width: 5),
                  CircleAvatar(backgroundColor: Colors.red, radius: 15),
                ],
              ),
              const SizedBox(height: 10),
              const Text("Update Clubhouse Item",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 30),

              // Input Nama
              _buildMickeyTextField(
                controller: _nameController,
                label: "Product Name",
                icon: Icons.edit,
                accentColor: Colors.black,
                validator: (value) => value!.isEmpty ? "Nama jangan kosong ya!" : null,
              ),
              const SizedBox(height: 20),

              // Input Harga
              _buildMickeyTextField(
                controller: _priceController,
                label: "Price (Rp)",
                icon: Icons.payments,
                accentColor: Colors.yellow[800]!,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Harga harus diisi!" : null,
              ),
              const SizedBox(height: 20),

              // Input Deskripsi
              _buildMickeyTextField(
                controller: _descController,
                label: "Description",
                icon: Icons.notes,
                accentColor: Colors.red,
                maxLines: 3,
                validator: (value) => value!.isEmpty ? "Deskripsinya mana?" : null,
              ),
              const SizedBox(height: 40),

              // Tombol Update
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _updateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Berbeda dengan Add (Merah)
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "SAVE CHANGES",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper konsisten dengan AddProductScreen
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
      ),
      validator: validator,
    );
  }
}