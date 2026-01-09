// To parse this JSON data, do
//
//     final modelCart = modelCartFromJson(jsonString);

import 'dart:convert';

ModelCart modelCartFromJson(String str) => ModelCart.fromJson(json.decode(str));

String modelCartToJson(ModelCart data) => json.encode(data.toJson());

class ModelCart {
  int totalCarts;
  List<Datum> data;

  ModelCart({
    required this.totalCarts,
    required this.data,
  });

  factory ModelCart.fromJson(Map<String, dynamic> json) => ModelCart(
    totalCarts: json["total_carts"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_carts": totalCarts,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String userId;
  List<Item> items;

  Datum({
    required this.userId,
    required this.items,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["user_id"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  int productId;
  String productName;
  int price;
  int quantity;

  Item({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["product_id"],
    productName: json["product_name"],
    price: json["price"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "price": price,
    "quantity": quantity,
  };
}
