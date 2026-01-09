import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pruductservice/model/ModelUser.dart';

class UserService {
  // Gunakan IP Laptop Anda dan Port 4000 sesuai kodingan Express
  static const String baseUrl = "http://10.57.107.139:7000";

  // 1. REGISTER (Menembak ke app.post('/users'))
  Future<Map<String, dynamic>> register(ModelUser user) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users"), // SESUAI BACKEND: app.post('/users')
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true, "message": data['message']};
      } else {
        return {"success": false, "message": data['error'] ?? data['message']};
      }
    } catch (e) {
      return {"success": false, "message": "Koneksi Gagal: $e"};
    }
  }

  // 2. LOGIN (Menembak ke app.post('/login'))
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"), // SESUAI BACKEND: app.post('/login')
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": data['message'], "user": data['user']};
      } else {
        return {"success": false, "message": data['message'] ?? data['error']};
      }
    } catch (e) {
      return {"success": false, "message": "Koneksi Gagal: $e"};
    }
  }

  // 3. GET USERS (Menembak ke app.get('/users'))
  Future<List<ModelUser>> getUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ModelUser.fromJson(data)).toList();
    } else {
      throw Exception("Gagal mengambil data user");
    }
  }
}