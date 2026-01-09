// // lib/screens/product_detail_screen.dart
//
// import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';   // <-- tidak dipakai, jadi bisa dihapus/komen
//
// import 'package:pruductservice/model/ModelProduct.dart';
// // import 'package:pruductservice/providers/cart_provider.dart'; // <-- komen juga kalau belum dipakai
//
// class ProductDetailScreen extends StatelessWidget {
//   final ModelProduct product;
//
//   const ProductDetailScreen({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//
//     // final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     // ↑↑↑ ini di-nonaktifkan dulu
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product.name),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(product.name,
//                 style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text(
//               'Rp ${product.price.toStringAsFixed(0)}',
//               style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.deepPurple),
//             ),
//             const Divider(height: 30),
//             const Text('Deskripsi:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text(product.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//
//       // --- Bagian tambah keranjang di-nonaktifkan ---
//       /*
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton.icon(
//           onPressed: () {
//             cartProvider.addToCart(product);
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('${product.name} berhasil ditambahkan ke keranjang!'),
//                 duration: const Duration(seconds: 1),
//               ),
//             );
//           },
//           icon: const Icon(Icons.add_shopping_cart),
//           label: const Text('Tambah ke Keranjang'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 15),
//           ),
//         ),
//       ),
//       */
//     );
//   }
// }
