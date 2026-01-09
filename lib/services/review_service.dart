import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/ModelReview.dart';

class ReviewService {
  // Base URL sesuai Docker
  static const String baseUrl = "http://10.57.107.139:5004/reviews";

  // 1. POST REVIEW (Sudah Benar, hanya pastikan URL-nya tetap /reviews)
  Future<bool> postReview(int productId, int rating, String reviewText) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          "product_id": productId.toString(),
          "rating": rating.toString(),
          "review": reviewText,
        },
      );

      return response.statusCode == 201; // Flask kirim 201 untuk 'Created'
    } catch (e) {
      print("❌ Error Post Review: $e");
      return false;
    }
  }

  // 2. GET REVIEWS (Disesuaikan dengan Route Flask /reviews/product/<id>)
  Future<List<Data>> getProductReviews(int productId) async {
    try {
      // PERBAIKAN URL: tambahkan /product/ sesuai route Flask
      final String fullUrl = "$baseUrl/product/$productId";
      final response = await http.get(Uri.parse(fullUrl));

      print("Log URL: $fullUrl");
      print("Log Body: ${response.body}");

      if (response.statusCode == 200) {
        // PERBAIKAN PARSING: Flask mengembalikan List langsung []
        final List<dynamic> jsonList = jsonDecode(response.body);

        return jsonList.map((item) => Data.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("❌ Error Fetch Reviews: $e");
      return [];
    }
  }
}