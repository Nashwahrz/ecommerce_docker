class ModelCartResponse {
  String? message;
  int? activeItems; // Untuk respon default
  int? totalItems;  // Untuk respon add_to_cart
  String? error;

  ModelCartResponse({this.message, this.activeItems, this.totalItems, this.error});

  factory ModelCartResponse.fromJson(Map<String, dynamic> json) => ModelCartResponse(
    message: json["message"],
    activeItems: json["active_items"],
    totalItems: json["total_items"],
    error: json["error"],
  );
}