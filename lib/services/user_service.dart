import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pruductservice/model/ModelUser.dart';


class UserService {
  static String baseUrl = "http://10.117.157.139:4000/users";

  // GET ALL USERS
  static Future<List<ModelUser>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return modelUserFromJson(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

  // GET DETAIL USER
  static Future<ModelUser> getUserById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return ModelUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load user detail");
    }
  }

  // POST USER
  static Future<bool> addUser(String name, String email, String role) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "role": role,
      }),
    );

    return response.statusCode == 201;
  }
}
