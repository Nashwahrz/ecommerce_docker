import 'package:flutter/material.dart';
import 'package:pruductservice/services/review_service.dart';


class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final productIdController = TextEditingController();
  final reviewController = TextEditingController();
  final ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Review")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: productIdController,
              decoration: InputDecoration(labelText: "Product ID"),
            ),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(labelText: "Review"),
            ),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(labelText: "Rating (1–5)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await ReviewService.addReview(
                  int.parse(productIdController.text),
                  reviewController.text,
                  int.parse(ratingController.text),
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Review berhasil ditambahkan")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menambah review")),
                  );
                }
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
