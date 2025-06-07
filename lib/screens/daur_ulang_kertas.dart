import 'package:flutter/material.dart';

class DaurUlangKertasPage extends StatelessWidget {
  const DaurUlangKertasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daur Ulang Kertas"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          "Konten Daur Ulang Kertas",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
