import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/ModelCart.dart';

class CartService {
  // PENTING: Gunakan /cart (tanpa 's') jika rute hapus kamu adalah cart/{id}
  // Namun, cek kembali apakah rute GET & POST kamu juga menggunakan /cart atau /carts
  static const String baseUrl = "http://10.57.107.139:6001/cart";
  static const String userId = "1";

  // --- 1. GET USER CART ---
  Future<List<Item>> getUserCart() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$userId"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Item>.from(data["items"].map((x) => Item.fromJson(x)));
      }
      return [];
    } catch (e) {
      print("Error Fetch: $e");
      return [];
    }
  }

  // --- 2. ADD TO CART ---
  Future<bool> addToCart(int productId, String name, int price, int qty) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          "user_id": userId,
          "product_id": productId.toString(),
          "product_name": name,
          "price": price.toString(),
          "quantity": qty.toString(),
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // --- 3. DELETE ITEM (Sesuai Rute cart/{id}) ---
  Future<bool> deleteItem(int productId) async {
    try {
      // Ini akan menghasilkan URL: http://...:6001/cart/101
      final response = await http.delete(
        Uri.parse("$baseUrl/$productId"),
      );

      print("--- Mickey Debug Delete ---");
      print("Request URL: $baseUrl/$productId");
      print("Status Code: ${response.statusCode}");
      print("Respon Body: ${response.body}");

      // Berhasil jika status 200 (OK) atau 204 (No Content)
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error Delete Service: $e");
      return false;
    }
  }
}