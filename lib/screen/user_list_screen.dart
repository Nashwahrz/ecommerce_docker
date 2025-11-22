import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelUser.dart';
import 'package:pruductservice/services/user_service.dart';
import 'add_user_screen.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<ModelUser>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = UserService.getUsers();
  }

  Future<void> refreshUsers() async {
    setState(() {
      futureUsers = UserService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List User")),

      body: FutureBuilder<List<ModelUser>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data user"));
          }

          final users = snapshot.data!;

          return RefreshIndicator(
            onRefresh: refreshUsers,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final u = users[index];
                return ListTile(
                  title: Text(u.name),
                  subtitle: Text(u.email),
                  trailing: Text(u.role),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailScreen(id: u.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          ).then((_) => refreshUsers());
        },
      ),
    );
  }
}
