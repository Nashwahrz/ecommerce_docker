// lib/screens/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:pruductservice/model/ModelProduct.dart';
import 'package:pruductservice/screen/product_detail.dart';
import 'package:pruductservice/providers/cart_provider.dart';
import 'package:pruductservice/screen/cart_product.dart';
import 'package:pruductservice/screen/review_list_screen.dart';
// Asumsi: Tambahkan impor untuk UserListScreen
import 'package:pruductservice/screen/user_list_screen.dart'; // <<< IMPOR BARU

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
        throw Exception('Gagal mengambil data produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
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
          // 1. Icon Daftar Pengguna (BARU DITAMBAHKAN)
          IconButton(
            icon: const Icon(Icons.people_outline, size: 26),
            tooltip: 'Lihat Daftar Pengguna',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListScreen()), // Navigasi ke UserListScreen
              );
            },
          ),

          // 2. Cart Icon dengan badge notifikasi
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, size: 26),
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
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ================= LIST PRODUK ==================
      body: FutureBuilder<List<ModelProduct>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.indigo),
                  SizedBox(height: 10),
                  Text("Memuat produk...", style: TextStyle(color: Colors.indigo)),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Gagal memuat: ${snapshot.error}. Pastikan server Anda berjalan.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Coba muat ulang data
                        setState(() {
                          _futureProducts = _fetchProducts();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final products = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Icon Produk
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: Colors.indigo, size: 30),
                            ),
                            const SizedBox(width: 15),
                            // Nama dan Harga Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Harga: Rp ${product.price.toDouble().toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Trailing
                            const Icon(Icons.chevron_right, color: Colors.black54, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, color: Colors.black38, size: 60),
                  SizedBox(height: 10),
                  Text(
                    'Tidak ada produk yang tersedia saat ini.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            );
          }
        },
      ),

      // ==================== Floating Action Button untuk Review ======================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewListScreen()),
          );
        },
        icon: const Icon(Icons.rate_review_outlined),
        label: const Text("Lihat Review"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}