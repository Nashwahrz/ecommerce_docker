import 'dart:convert';

// Fungsi helper tetap sama
List<ModelUser> modelUserFromJson(String str) =>
    List<ModelUser>.from(json.decode(str).map((x) => ModelUser.fromJson(x)));

String modelUserToJson(List<ModelUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelUser {
  int? id;         // Diubah menjadi opsional (?) karena saat POST id belum ada
  String name;
  String email;
  String? password; // Tambahkan password untuk kebutuhan POST/Register

  ModelUser({
    this.id,
    required this.name,
    required this.email,
    this.password, // Masukkan ke constructor
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    // Password tidak perlu diambil dari JSON saat GET (karena memang di-hide di backend)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    if (password != null) "password": password, // Hanya kirim password jika diisi
  };
}