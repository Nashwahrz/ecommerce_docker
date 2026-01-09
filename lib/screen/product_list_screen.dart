import 'package:flutter/material.dart';
import 'package:pruductservice/screen/add_product_screen.dart';
import 'package:pruductservice/screen/edit_product_screen.dart';
import 'package:pruductservice/screen/cart_screen.dart';
import 'package:pruductservice/screen/detail_product_screen.dart';
import 'package:pruductservice/services/product_service.dart';
import 'package:pruductservice/services/cart_service.dart';
import '../model/ModelProduct.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _service = ProductService();
  final CartService _cartService = CartService();
  late Future<ModelProduct> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _service.getProducts();
  }

  void _refresh() {
    setState(() {
      _futureProducts = _service.getProducts();
    });
  }

  void _addToCart(Datum product) async {
    bool success = await _cartService.addToCart(
        product.id, product.name, product.price, 1);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Congrat! ${product.name} masuk keranjang!"),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: "LIHAT",
            textColor: Colors.yellow,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Oh no! Gagal menambah keranjang"),
            backgroundColor: Colors.red),
      );
    }
  }

  void _deleteProduct(int id) async {
    bool success = await _service.deleteProduct(id);
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Produk dihapus")));
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Mickey's Shop",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.yellow),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
        ],
      ),
      body: FutureBuilder<ModelProduct>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("Produk kosong, See Ya Real Soon!"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.data.length,
            itemBuilder: (context, index) {
              final product = snapshot.data!.data[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 2), // Aksen Merah
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProductScreen(product: product),
                      ),
                    );
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.yellow, // Sepatu Mickey
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mouse, color: Colors.black),
                  ),
                  title: Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(
                    "Rp ${product.price}\n${product.description}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () => _addToCart(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProductScreen(product: product)),
                          );
                          if (result == true) _refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(product.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red, // Celana Mickey
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Produk?"),
        content: const Text("Gosh! Data ini akan hilang selamanya."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.black))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(id);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, shape: const StadiumBorder()),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}