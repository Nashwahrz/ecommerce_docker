import 'package:flutter/material.dart';
import 'package:pruductservice/services/user_service.dart';


class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final roleC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah User")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: roleC,
              decoration: const InputDecoration(labelText: "Role"),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                bool success = await UserService.addUser(
                  nameC.text,
                  emailC.text,
                  roleC.text,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User berhasil ditambahkan")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal menambahkan user")),
                  );
                }
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
