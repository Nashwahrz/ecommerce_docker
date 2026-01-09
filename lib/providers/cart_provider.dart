// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../model/ModelCart.dart'; // Pastikan path ini benar
// import 'dart:io'; // Tambahkan untuk SocketException
//
// class CartProvider with ChangeNotifier {
//   ModelCart? cart;
//
//   // Total item dalam keranjang
//   int get totalItems {
//     if (cart == null) return 0;
//     return cart!.items.fold(0, (sum, item) => sum + item.quantity);
//   }
//
//   // Total harga
//   int get totalPrice {
//     if (cart == null) return 0;
//     return cart!.items.fold(
//         0, (sum, item) => sum + (item.price * item.quantity));
//   }
//
//   // Ambil cart dari API
//   Future<void> getCart() async {
//     try {
//       final url = Uri.parse("http://10.117.157.139:8000/carts");
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         cart = ModelCart.fromJson(jsonDecode(response.body));
//       } else {
//         // Log error status code
//         print("GET Cart Failed with status: ${response.statusCode}");
//         cart = null;
//       }
//
//       notifyListeners();
//     } on SocketException {
//       // Tangani error koneksi jaringan
//       print("Error: Tidak ada koneksi internet.");
//       rethrow;
//     } catch (e) {
//       print("Error fetching cart: $e");
//       rethrow;
//     }
//   }
//
//   // Hapus item dari cart berdasarkan ID item
//   Future<void> deleteItem(int id) async {
//     final url = Uri.parse("http://10.117.157.139:8000/carts/$id");
//
//     try {
//       final response = await http.delete(url);
//
//       if (response.statusCode == 200) {
//         // Penghapusan berhasil, refresh keranjang
//         await getCart();
//       } else {
//         // Jika status code bukan 200, log error yang spesifik
//         print("DELETE Item Failed. ID: $id. Status: ${response.statusCode}. Body: ${response.body}");
//
//         // Lempar exception yang lebih informatif
//         throw Exception("Gagal menghapus item (Status: ${response.statusCode})");
//       }
//     } on SocketException {
//       // Tangani error koneksi jaringan
//       print("Error Jaringan: Gagal terhubung ke server saat menghapus item $id.");
//       throw Exception("Gagal terhubung ke server. Cek koneksi internet dan alamat IP.");
//     } catch (e) {
//       // Tangani semua error lain
//       print("Error tak terduga saat menghapus item $id: $e");
//       rethrow; // Biarkan caller menangani error ini
//     }
//   }
// }