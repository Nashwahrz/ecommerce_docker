// To parse this JSON data, do
//
//     final modelReview = modelReviewFromJson(jsonString);

import 'dart:convert';

List<ModelReview> modelReviewFromJson(String str) => List<ModelReview>.from(json.decode(str).map((x) => ModelReview.fromJson(x)));

String modelReviewToJson(List<ModelReview> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelReview {
  int id;
  int productId;
  int rating;
  String review;

  ModelReview({
    required this.id,
    required this.productId,
    required this.rating,
    required this.review,
  });

  factory ModelReview.fromJson(Map<String, dynamic> json) => ModelReview(
    id: json["id"],
    productId: json["product_id"],
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "rating": rating,
    "review": review,
  };
}
