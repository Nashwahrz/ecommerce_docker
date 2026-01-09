// To parse this JSON data, do
//
//     final modelReview = modelReviewFromJson(jsonString);

import 'dart:convert';

ModelReview modelReviewFromJson(String str) => ModelReview.fromJson(json.decode(str));

String modelReviewToJson(ModelReview data) => json.encode(data.toJson());

class ModelReview {
  Data data;
  String message;

  ModelReview({
    required this.data,
    required this.message,
  });

  factory ModelReview.fromJson(Map<String, dynamic> json) => ModelReview(
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  int productId;
  int rating;
  String review;

  Data({
    required this.productId,
    required this.rating,
    required this.review,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    productId: json["product_id"],
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "rating": rating,
    "review": review,
  };
}
