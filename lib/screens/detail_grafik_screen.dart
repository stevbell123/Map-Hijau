import 'package:flutter/material.dart';

class DetailGrafikScreen extends StatefulWidget {
  @override
  _DetailGrafikScreenState createState() => _DetailGrafikScreenState();
}

class _DetailGrafikScreenState extends State<DetailGrafikScreen> {
  String _selectedPeriod = 'Mingguan';

  @override
  Widget build(BuildContext context) {
    String imagePath = _selectedPeriod == 'Mingguan'
        ? 'lib/assets/chart1.jpeg'
        : 'lib/assets/chart2.jpeg'; 

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Grafik Sampah"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: DropdownButton<String>(
                value: _selectedPeriod,
                underline: SizedBox(),
                isExpanded: true,
                items: ['Mingguan', 'Bulanan'].map((String period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPeriod = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              _selectedPeriod == 'Mingguan'
                  ? 'Grafik sampah minggu ini (berdasarkan jumlah pembuangan)'
                  : 'Grafik sampah bulan ini (berdasarkan total volume)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
