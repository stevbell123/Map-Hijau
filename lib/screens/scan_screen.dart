import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isKardusChecked = false;
  bool isBotolChecked = false;
  TextEditingController kardusController = TextEditingController();
  TextEditingController botolController = TextEditingController();

  bool get isFormValid {
    if (isKardusChecked && kardusController.text.isEmpty) return false;
    if (isBotolChecked && botolController.text.isEmpty) return false;
    return isKardusChecked || isBotolChecked;
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
              CheckboxListTile(
                title: Row(
                  children: [
                    const Text("Kardus"),
                    const Spacer(),
                    const Icon(Icons.archive, color: Colors.orange, size: 30),
                  ],
                ),
                value: isKardusChecked,
                onChanged: (value) {
                  setState(() {
                    isKardusChecked = value!;
                  });
                },
              ),
              if (isKardusChecked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: kardusController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Kardus (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Row(
                  children: [
                    const Text("Botol"),
                    const Spacer(),
                    const Icon(Icons.local_drink, color: Colors.blue, size: 30),
                  ],
                ),
                value: isBotolChecked,
                onChanged: (value) {
                  setState(() {
                    isBotolChecked = value!;
                  });
                },
              ),
              if (isBotolChecked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: botolController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Botol (buah)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isFormValid
                    ? () {
                        Navigator.pushNamed(context, '/barcode');
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