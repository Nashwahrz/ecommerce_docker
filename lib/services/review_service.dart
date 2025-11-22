import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pruductservice/model/ModelReview.dart';


class ReviewService {
  static const String baseUrl = "http://10.117.157.139:5002";

  // GET list review
  static Future<List<ModelReview>> getReviews() async {
    final response = await http.get(Uri.parse("$baseUrl/reviews"));

    if (response.statusCode == 200) {
      return modelReviewFromJson(response.body);
    } else {
      throw Exception("Failed to load reviews");
    }
  }

  // POST tambah review
  static Future<bool> addReview(int productId, String review, int rating) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reviews"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "product_id": productId,
        "review": review,
        "rating": rating
      }),
    );

    return response.statusCode == 201;
  }
}
