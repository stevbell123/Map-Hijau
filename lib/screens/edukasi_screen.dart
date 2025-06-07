import 'package:flutter/material.dart';
import 'daur_ulang_kertas.dart';
import 'daur_ulang_logam.dart';
import 'daur_ulang_plastik.dart';
import 'manfaat_daur_ulang.dart';
class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edukasi Daur Ulang", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildEduCard(context, "Daur Ulang Logam", Icons.precision_manufacturing, Colors.grey),
            _buildEduCard(context, "Daur Ulang Plastik", Icons.recycling, Colors.blue),
            _buildEduCard(context, "Daur Ulang Kertas", Icons.article, Colors.orange),
            _buildEduCard(context, "Manfaat Daur Ulang", Icons.eco, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildEduCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == "Daur Ulang Logam") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => DaurUlangLogamPage()));
        } else if (title == "Daur Ulang Plastik") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => PlasticRecyclingPage()));
        } else if (title == "Daur Ulang Kertas") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => DaurUlangKertasPage()));
        } else if (title == "Manfaat Daur Ulang") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => RecyclingBenefitsPage()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
