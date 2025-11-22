import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelReview.dart';
import 'package:pruductservice/services/review_service.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  late Future<List<ModelReview>> reviews;

  @override
  void initState() {
    super.initState();
    reviews = ReviewService.getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Review")),
      body: FutureBuilder<List<ModelReview>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada review"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final r = data[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("⭐ Rating: ${r.rating}"),
                  subtitle: Text(r.review),
                  trailing: Text("Product: ${r.productId}"),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, "/add-review");
          setState(() {
            reviews = ReviewService.getReviews(); // Refresh setelah tambah
          });
        },
      ),
    );
  }
}
