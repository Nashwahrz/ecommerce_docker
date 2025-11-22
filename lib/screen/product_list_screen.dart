// lib/screens/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:pruductservice/model/ModelProduct.dart';
import 'package:pruductservice/screen/add_review_screen.dart';
import 'package:pruductservice/screen/product_detail.dart';
import 'package:pruductservice/providers/cart_provider.dart';
import 'package:pruductservice/screen/cart_product.dart';
import 'package:pruductservice/screen/review_list_screen.dart';
import 'package:pruductservice/screen/user_list_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final String apiUrl = "http://10.117.157.139:3000/products";
  late Future<List<ModelProduct>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  Future<List<ModelProduct>> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Asumsi modelProductFromJson mengkonversi JSON ke List<ModelProduct>
        return modelProductFromJson(response.body);
      } else {
        throw Exception('Gagal mengambil data produk.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan/server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Toko Online Sederhana'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          // Icon Daftar Pengguna
          IconButton(
            icon: const Icon(Icons.people_outline, size: 26),
            tooltip: 'Lihat Daftar Pengguna',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListScreen()),
              );
            },
          ),

          // Cart Icon dengan badge notifikasi
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, size: 26),
                    tooltip: 'Lihat Keranjang',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                  if (cartProvider.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Text(
                          cartProvider.totalItems.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ================== BODY ==================
      body: FutureBuilder<List<ModelProduct>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "Error: ${snapshot.error}. Coba Muat Ulang.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, color: Colors.black38, size: 60),
                  SizedBox(height: 10),
                  Text('Tidak ada produk yang tersedia saat ini.'),
                ],
              ),
            );
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 80), // Tambah padding bawah untuk FAB
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon Produk
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined,
                            color: Colors.indigo, size: 30),
                      ),

                      const SizedBox(width: 15),

                      // Nama Produk & Harga
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${product.price.toDouble().toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =================== TOMBOL REVIEW PER PRODUK ===================
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddReviewScreen(productId: product.id),
                            ),
                          );
                        },
                        child: const Text(
                          "Review",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // ==================== TOMBOL LIHAT SEMUA REVIEW (FAB) ======================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke ReviewListScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewListScreen()),
          );
        },
        icon: const Icon(Icons.reviews_outlined),
        label: const Text("Semua Review"),
        backgroundColor: Colors.blueGrey, // Warna berbeda agar menonjol dari tombol review per produk
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      // Atur lokasi FAB ke bawah kiri
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}