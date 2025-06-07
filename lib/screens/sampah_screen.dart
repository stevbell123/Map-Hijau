import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempat Sampah Terdekat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SampahScreen(),
    );
  }
}

class SampahScreen extends StatelessWidget {
  const SampahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tempat Sampah Terdekat"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔍 Lokasi Tempat Sampah Terdekat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // List Tempat Sampah
            Expanded(
              child: ListView(
                children: [
                  _buildSampahCard(context, "Tempat Sampah Umum", "Jl. Merdeka No. 45"),
                  _buildSampahCard(context, "Tempat Sampah Daur Ulang", "Jl. Hijau Lestari No. 21"),
                  _buildSampahCard(context, "Bank Sampah", "Jl. Peduli Lingkungan No. 88"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampahCard(BuildContext context, String title, String address) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.delete, size: 40, color: Colors.green),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(address),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
        onTap: () {
          // Navigasi ke halaman detail dengan gambar
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SampahDetailScreen(
                title: title,
                address: address,
                imageUrl: 'assets/images/tempat_sampah_merdeka.jpg', // Sesuaikan dengan path gambar
              ),
            ),
          );
        },
      ),
    );
  }
}

class SampahDetailScreen extends StatelessWidget {
  final String title;
  final String address;
  final String imageUrl;

  const SampahDetailScreen({
    super.key,
    required this.title,
    required this.address,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageUrl), // Menampilkan gambar
            SizedBox(height: 20),
            Text(
              address,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}