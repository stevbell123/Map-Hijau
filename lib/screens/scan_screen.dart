import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isKardusChecked = false;
  bool isBotolChecked = false;
  bool isKacaChecked = false;
  bool isBesiChecked = false;

  TextEditingController kardusController = TextEditingController();
  TextEditingController botolController = TextEditingController();
  TextEditingController kacaController = TextEditingController();
  TextEditingController besiController = TextEditingController();

  bool get isFormValid {
    if (isKardusChecked && kardusController.text.isEmpty) return false;
    if (isBotolChecked && botolController.text.isEmpty) return false;
    if (isKacaChecked && kacaController.text.isEmpty) return false;
    if (isBesiChecked && besiController.text.isEmpty) return false;
    return isKardusChecked || isBotolChecked || isKacaChecked || isBesiChecked;
  }

  Widget _buildCheckboxTile({
    required String label,
    required Widget icon,
    required bool value,
    required Function(bool?) onChanged,
    required bool showTextField,
    required TextEditingController controller,
    required String hint,
    required String rewardInfo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Row(
            children: [
              Text(label),
              const Spacer(),
              icon,
            ],
          ),
          value: value,
          onChanged: onChanged,
        ),
        if (showTextField)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: hint,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  rewardInfo,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  Map<String, dynamic> _getScanData() {
    Map<String, dynamic> scanData = {};
    
    if (isKardusChecked && kardusController.text.isNotEmpty) {
      scanData['Kardus'] = kardusController.text;
    }
    if (isBotolChecked && botolController.text.isNotEmpty) {
      scanData['Botol'] = botolController.text;
    }
    if (isKacaChecked && kacaController.text.isNotEmpty) {
      scanData['Kaca'] = kacaController.text;
    }
    if (isBesiChecked && besiController.text.isNotEmpty) {
      scanData['Besi'] = besiController.text;
    }
    
    return scanData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(
            children: [
              const Text(
                "Pilih jenis sampah dan masukkan jumlah",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildCheckboxTile(
                label: "Kardus",
                icon: const FaIcon(FontAwesomeIcons.boxOpen, color: Colors.orange, size: 30),
                value: isKardusChecked,
                onChanged: (val) => setState(() => isKardusChecked = val!),
                showTextField: isKardusChecked,
                controller: kardusController,
                hint: "Jumlah Kardus (kg)",
                rewardInfo: "1 kg Kardus = 10 koin",
              ),
              _buildCheckboxTile(
                label: "Botol",
                icon: const FaIcon(FontAwesomeIcons.bottleWater, color: Colors.blue, size: 30),
                value: isBotolChecked,
                onChanged: (val) => setState(() => isBotolChecked = val!),
                showTextField: isBotolChecked,
                controller: botolController,
                hint: "Jumlah Botol (buah)",
                rewardInfo: "1 botol = 2 koin",
              ),
              _buildCheckboxTile(
                label: "Kaca",
                icon: const FaIcon(FontAwesomeIcons.flask, color: Colors.cyan, size: 30),
                value: isKacaChecked,
                onChanged: (val) => setState(() => isKacaChecked = val!),
                showTextField: isKacaChecked,
                controller: kacaController,
                hint: "Jumlah Kaca (kg)",
                rewardInfo: "1 kg Kaca = 15 koin",
              ),
              _buildCheckboxTile(
                label: "Besi",
                icon: const FaIcon(FontAwesomeIcons.screwdriverWrench, color: Colors.brown, size: 30),
                value: isBesiChecked,
                onChanged: (val) => setState(() => isBesiChecked = val!),
                showTextField: isBesiChecked,
                controller: besiController,
                hint: "Jumlah Besi (kg)",
                rewardInfo: "1 kg Besi = 59 koin",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isFormValid
                    ? () {
                        final scanData = _getScanData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarcodeScreen(scanData: scanData),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodeScreen extends StatelessWidget {
  final Map<String, dynamic> scanData;

  const BarcodeScreen({super.key, required this.scanData});

  void showSummaryBottomSheet(BuildContext context) {
    int getKoin(String jenis, double jumlah) {
      switch (jenis) {
        case 'Kardus':
          return (jumlah * 10).toInt();
        case 'Botol':
          return (jumlah * 2).toInt();
        case 'Kaca':
          return (jumlah * 15).toInt();
        case 'Besi':
          return (jumlah * 59).toInt();
        default:
          return 0;
      }
    }

    // ✅ Pastikan hasilList memiliki tipe data yang jelas
    final List<Map<String, dynamic>> hasilList = scanData.entries.map((entry) {
      final jenis = entry.key;
      final jumlah = double.tryParse(entry.value.toString()) ?? 0;
      final koin = getKoin(jenis, jumlah);
      return {
        'jenis': jenis,
        'jumlah': jumlah,
        'koin': koin,
      };
    }).toList();

    final totalKoin = hasilList.fold<int>(0, (sum, item) => sum + item['koin'] as int);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Ringkasan Scan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...hasilList.map((item) => ListTile(
              leading: const Icon(Icons.recycling, color: Colors.green),
              title: Text(item['jenis']),
              subtitle: Text("${item['jumlah']} satuan"),
              trailing: Text("+${item['koin']} koin", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            )),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "Total Koin Didapat: $totalKoin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[800]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Kembali ke Home"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade900.withOpacity(0.8),
                  Colors.black.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
              border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SCAN QR CODE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_2,
                        size: 180,
                        color: Colors.black87,
                      ),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green.withOpacity(0.7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Arahkan kamera ke QR Code',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showSummaryBottomSheet(context);
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 24),
                    label: const Text(
                      "SELESAI",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.green.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}