import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/ModelProduct.dart'; // Pastikan path benar

class ProductService {
  // Gunakan IP yang sesuai dengan koneksi Wi-Fi Anda
  static const String baseUrl = "http://10.57.107.139:3000/products";

  // 1. AMBIL SEMUA PRODUK
  Future<ModelProduct> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Karena API Anda mengembalikan { success: true, data: [...] }
        // modelProductFromJson akan bekerja karena model Anda sudah memiliki field 'data'
        return modelProductFromJson(response.body);
      } else {
        throw Exception("Gagal memuat produk: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan koneksi: $e");
    }
  }

  // 2. TAMBAH PRODUK
  Future<bool> addProduct(String name, int price, String description) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "price": price, // Sequelize DataTypes.FLOAT menerima angka
          "description": description,
        }),
      );

      // API Sequelize Anda mengembalikan status 200 melalui helper success()
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("Add Product Error: $e");
      return false;
    }
  }

  // 3. UPDATE PRODUK
  Future<bool> updateProduct(int id, String name, int price, String description) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "price": price,
          "description": description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("Update Product Error: $e");
      return false;
    }
  }

  // 4. HAPUS PRODUK
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("Delete Product Error: $e");
      return false;
    }
  }
}