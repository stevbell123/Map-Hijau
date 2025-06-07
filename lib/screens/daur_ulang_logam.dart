import 'package:flutter/material.dart';

class DaurUlangLogamPage extends StatelessWidget {
  const DaurUlangLogamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daur Ulang Logam"),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Text(
          "Konten Daur Ulang Logam",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
