import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelUser.dart';
import 'package:pruductservice/services/user_service.dart';



class UserDetailScreen extends StatelessWidget {
  final int id;

  const UserDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail User")),

      body: FutureBuilder<ModelUser>(
        future: UserService.getUserById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("User tidak ditemukan"));
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID: ${user.id}", style: const TextStyle(fontSize: 18)),
                    Text("Nama: ${user.name}", style: const TextStyle(fontSize: 18)),
                    Text("Email: ${user.email}", style: const TextStyle(fontSize: 18)),
                    Text("Role: ${user.role}", style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
