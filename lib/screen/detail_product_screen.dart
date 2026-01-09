import 'package:flutter/material.dart';
import '../model/ModelProduct.dart';
import '../model/ModelReview.dart';
import '../services/review_service.dart';
import 'add_review_screen.dart';

class DetailProductScreen extends StatefulWidget {
  final Datum product;
  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final ReviewService _reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product Detail",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk (Frame Mickey Style)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.mouse, size: 100, color: Colors.grey),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 15,
                      child: const Icon(Icons.favorite, color: Colors.white, size: 15),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detail Harga & Nama
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.product.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text("Rp ${widget.product.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 15),

            const Text("Clubhouse Description:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 5),
            Text(widget.product.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),

            const Divider(height: 40, thickness: 2, color: Colors.black12),

            // BAGIAN DAFTAR REVIEW
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                const Text("What Friends Say:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),

            FutureBuilder<List<Data>>(
              future: _reviewService.getProductReviews(widget.product.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                } else if (snapshot.hasError) {
                  return const Text("Oh no! Gagal memuat review");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No reviews yet. Be the first, pal!",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final review = snapshot.data![index];
                    return Card(
                      elevation: 0,
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black12)
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Row(
                          children: List.generate(5, (i) => Icon(
                            Icons.star,
                            size: 14,
                            color: i < review.rating ? Colors.amber : Colors.grey[300],
                          )),
                        ),
                        subtitle: Text(review.review, style: const TextStyle(color: Colors.black87)),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // TOMBOL TAMBAH REVIEW (MELAYANG STYLE)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReviewScreen(
                    productId: widget.product.id,
                    productName: widget.product.name,
                  ),
                ),
              );
              setState(() {});
            },
            icon: const Icon(Icons.rate_review, color: Colors.white),
            label: const Text("WRITE A REVIEW",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ),
    );
  }
}