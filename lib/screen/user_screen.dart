import 'package:flutter/material.dart';
import 'package:pruductservice/model/ModelUser.dart';
import 'package:pruductservice/services/user_service.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // Variabel untuk menampung data user dari API
  late Future<List<ModelUser>> _futureUsers;

  @override
  void initState() {
    super.initState();
    // Memanggil API saat pertama kali aplikasi dibuka
    _futureUsers = UserService().getUsers();
  }

  // Fungsi untuk refresh data (tarik ke bawah)
  void _refreshData() {
    setState(() {
      _futureUsers = UserService().getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Pengguna"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          )
        ],
      ),
      body: FutureBuilder<List<ModelUser>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          // 1. Jika data sedang dimuat (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 2. Jika terjadi error (Misal: IP salah/Server mati)
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Text("Gagal terhubung ke server"),
                  Text("${snapshot.error}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ElevatedButton(onPressed: _refreshData, child: Text("Coba Lagi"))
                ],
              ),
            );
          }

          // 3. Jika data kosong
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada data user"));
          }

          // 4. Jika data berhasil didapat, tampilkan dalam ListView
          return RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.email),
                    trailing: Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}