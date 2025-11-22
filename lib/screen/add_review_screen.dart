import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelReview.dart';
import 'package:pruductservice/services/review_service.dart';

class AddReviewScreen extends StatefulWidget {
  final int productId;

  const AddReviewScreen({super.key, required this.productId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final reviewController = TextEditingController();
  final ratingController = TextEditingController();

  late Future<List<ModelReview>> reviews;

  @override
  void initState() {
    super.initState();
    // 1. Memuat review hanya untuk ID produk ini
    reviews = ReviewService.getReviewsByProductId(widget.productId);
  }

  void refreshReviews() {
    setState(() {
      // Muat ulang review
      reviews = ReviewService.getReviewsByProductId(widget.productId);
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("➕ Tambah Review Produk"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Produk ID yang Direview: ${widget.productId}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),

            // === Form Input ===
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: "Tulis Review Anda",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.comment_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ratingController,
              decoration: const InputDecoration(
                labelText: "Rating (1–5)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star),
                hintText: "Masukkan angka 1 sampai 5",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // === Tombol Simpan ===
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Simpan Review"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  // Validasi rating sederhana
                  final parsedRating = int.tryParse(ratingController.text);
                  if (parsedRating == null || parsedRating < 1 || parsedRating > 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Rating harus berupa angka antara 1 dan 5!"),
                          backgroundColor: Colors.orange),
                    );
                    return; // Hentikan proses jika input tidak valid
                  }

                  final success = await ReviewService.addReview(
                    widget.productId,
                    reviewController.text,
                    parsedRating,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("✅ Review berhasil ditambahkan"),
                          backgroundColor: Colors.green),
                    );

                    reviewController.clear();
                    ratingController.clear();
                    refreshReviews();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("❌ Gagal menambah review. Periksa koneksi atau server."),
                          backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Daftar Review untuk Produk Ini:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(), // Tambahkan garis pemisah

            // === Daftar Review ===
            Expanded(
              child: FutureBuilder<List<ModelReview>>(
                future: reviews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.indigo));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error memuat review: ${snapshot.error}'));
                  }

                  final allReviews = snapshot.data ?? [];

                  // =========================================================
                  // 2. LOGIKA PEMFILTERAN SISI CLIENT
                  // Pastikan review yang ditampilkan memiliki product_id yang sama
                  // Asumsi ModelReview memiliki properti 'productId' (sesuai JSON POST)
                  // =========================================================
                  final filteredReviews = allReviews.where(
                          (r) => r.productId == widget.productId
                  ).toList();

                  if (filteredReviews.isEmpty) {
                    return const Center(
                        child: Text("Belum ada review untuk produk ini."));
                  }

                  return ListView.builder(
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final r = filteredReviews[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.indigo),
                          title: Text(
                            "Rating: ⭐ ${r.rating}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(r.review),
                          trailing: Text("ID Produk: ${r.productId}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}