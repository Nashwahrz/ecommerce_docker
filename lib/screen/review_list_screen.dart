import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelReview.dart';
import 'package:pruductservice/screen/add_review_screen.dart';
import 'package:pruductservice/services/review_service.dart';

class ReviewListScreen extends StatefulWidget {
  // 1. UBAH DARI 'required int productId' MENJADI 'final int? productId'
  final int? productId;

  const ReviewListScreen({super.key, this.productId}); // Hapus 'required'

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  late Future<List<ModelReview>> reviews;

  @override
  void initState() {
    super.initState();
    reviews = _fetchReviews(); // Panggil fungsi fetching yang fleksibel
  }

  // 2. FUNGSI FETCHING FLEKSIBEL
  Future<List<ModelReview>> _fetchReviews() {
    if (widget.productId != null) {
      // Jika productId ada, ambil review HANYA untuk produk tersebut
      return ReviewService.getReviewsByProductId(widget.productId!);
    } else {
      // Jika productId null, ambil SEMUA review
      return ReviewService.getReviews();
    }
  }

  void refreshData() {
    setState(() {
      reviews = _fetchReviews(); // Gunakan fungsi fetching yang fleksibel
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan judul berdasarkan apakah ada productId
    final String title = widget.productId != null
        ? "Review Produk #${widget.productId}"
        : "Daftar Semua Review";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<ModelReview>>(
        future: reviews,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Gagal memuat review: ${snapshot.error.toString()}'),
              ),
            );
          }

          // Tidak ada review
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                widget.productId != null
                    ? "Belum ada review untuk produk ini."
                    : "Tidak ada review sama sekali.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final r = data[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(
                      r.rating.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text("⭐ Rating: ${r.rating}"),
                  subtitle: Text(r.review),
                  // Tampilkan ID Produk HANYA jika ini adalah daftar SEMUA review
                  trailing: widget.productId == null
                      ? Text(
                    "ID Produk: ${r.productId}",
                    style: const TextStyle(fontSize: 12, color: Colors.indigo),
                  )
                      : null, // Sembunyikan jika sudah spesifik per produk
                ),
              );
            },
          );
        },
      ),

      // 3. SEMBUNYIKAN FAB JIKA INI ADALAH LAYAR SEMUA REVIEW
      floatingActionButton: widget.productId != null
          ? FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah Review"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        onPressed: () async {
          // Navigasi menggunakan MaterialPageRoute (lebih aman jika Anda belum setup named routes)
          // Asumsi: AddReviewScreen menerima productId melalui konstruktor
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(productId: widget.productId!),
            ),
          );

          refreshData(); // Refresh setelah tambah
        },
      )
          : null, // Jika productId null (Semua Review), FAB disembunyikan
    );
  }
}