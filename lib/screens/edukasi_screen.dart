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
        title: Text("Edukasi Daur Ulang", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Pilih Jenis Edukasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: EdgeInsets.all(8),
                  children: [
                    _buildModernEduCard(
                      context,
                      "Daur Ulang Logam",
                      Icons.precision_manufacturing,
                      Colors.blueGrey,
                      LinearGradient(
                        colors: [Colors.blueGrey[600]!, Colors.blueGrey[400]!],
                      ),
                    ),
                    _buildModernEduCard(
                      context,
                      "Daur Ulang Plastik",
                      Icons.recycling,
                      Colors.lightBlue,
                      LinearGradient(
                        colors: [Colors.lightBlue[600]!, Colors.lightBlue[300]!],
                      ),
                    ),
                    _buildModernEduCard(
                      context,
                      "Daur Ulang Kertas",
                      Icons.article,
                      Colors.orange,
                      LinearGradient(
                        colors: [Colors.orange[600]!, Colors.orange[300]!],
                      ),
                    ),
                    _buildModernEduCard(
                      context,
                      "Manfaat Daur Ulang",
                      Icons.eco,
                      Colors.green,
                      LinearGradient(
                        colors: [Colors.green[600]!, Colors.green[400]!],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernEduCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Gradient gradient,
  ) {
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
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: gradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pelajari',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}