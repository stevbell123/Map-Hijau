import 'package:flutter/material.dart';
import 'history_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String namaUser = 'a';
  String emailUser = 'a@gmail.com';
  int levelUser = 5;
  int poinUser = 1200;

  void editProfile() {
    TextEditingController namaController = TextEditingController(text: namaUser);
    TextEditingController emailController = TextEditingController(text: emailUser);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Simpan'),
              onPressed: () {
                setState(() {
                  namaUser = namaController.text;
                  emailUser = emailController.text;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Yakin ingin keluar?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Keluar'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Berhasil logout')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void lihatProfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HeroProfilePage(nama: namaUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Saya'),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editProfile,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: lihatProfil,
              child: Hero(
                tag: 'profileHero',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.purple[100],
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              namaUser,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(emailUser, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Level Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      SizedBox(width: 6),
                      Text('Level $levelUser'),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Poin Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                      SizedBox(width: 6),
                      Text('$poinUser Poin'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Tombol History
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'History Aktivitas',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

// Halaman Hero Profil (untuk animasi Hero)
class HeroProfilePage extends StatelessWidget {
  final String nama;

  const HeroProfilePage({required this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profil'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Hero(
          tag: 'profileHero',
          child: CircleAvatar(
            radius: 120,
            backgroundColor: Colors.purple[100],
            child: Icon(Icons.person, size: 120, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
