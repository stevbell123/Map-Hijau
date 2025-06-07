import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  final List<Map<String, dynamic>> _faqData = [
    {
      "question": "Bagaimana cara menggunakan aplikasi ini?",
      "answer":
          "Kamu bisa mencari lokasi tempat sampah, bergabung dengan komunitas, dan mengumpulkan koin dari membuang sampah dengan benar.",
      "icon": Icons.help_outline
    },
    {
      "question": "Bagaimana cara menukar koin?",
      "answer":
          "Koin dapat ditukar di menu Reward Koin untuk hadiah seperti voucher makanan dan merchandise.",
      "icon": Icons.monetization_on_outlined
    },
    {
      "question": "Bagaimana cara bergabung ke komunitas?",
      "answer":
          "Buka menu Komunitas untuk menemukan grup diskusi dan kegiatan lingkungan.",
      "icon": Icons.group_add_outlined
    },
    {
      "question": "Apakah aplikasi ini gratis?",
      "answer":
          "Ya, aplikasi ini sepenuhnya gratis untuk siapa saja yang peduli lingkungan.",
      "icon": Icons.attach_money_outlined
    },
    {
      "question": "Apa itu sistem koin/poin?",
      "answer":
          "Sistem koin adalah bentuk penghargaan atas aksi ramah lingkungan seperti membuang sampah atau ikut komunitas.",
      "icon": Icons.star_outline
    },
    {
      "question": "Apakah data lokasi saya aman?",
      "answer":
          "Kami hanya menggunakan data lokasi untuk menampilkan tempat sampah terdekat, dan tidak menyimpan data pribadi tanpa izinmu.",
      "icon": Icons.security_outlined
    },
    {
      "question": "Jenis sampah apa yang bisa dikumpulkan?",
      "answer":
          "Kamu bisa kumpulkan sampah anorganik seperti plastik, kertas, logam, dan elektronik. Jenisnya ditandai di peta.",
      "icon": Icons.delete_outline
    },
    {
      "question": "Bagaimana melaporkan tempat sampah penuh/rusak?",
      "answer":
          "Gunakan fitur 'Laporkan' di halaman peta untuk memberi tahu petugas kebersihan.",
      "icon": Icons.report_problem_outlined
    },
    {
      "question": "Bisakah saya menggunakan aplikasi ini di luar kota?",
      "answer":
          "Bisa, aplikasi ini bisa digunakan di mana saja selama ada jaringan dan data tempat sampah terdaftar.",
      "icon": Icons.location_on_outlined
    },
  ];

  List<Map<String, dynamic>> get _filteredFAQs {
    if (_searchText.isEmpty) return _faqData;
    return _faqData
        .where((faq) => faq['question']
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase()))
        .toList();
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: Colors.blue,
        ),
        child: ExpansionTile(
          leading: Icon(faq['icon'], color: Colors.blue),
          title: Text(
            faq['question'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer'],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          iconColor: Colors.blue,
          collapsedIconColor: Colors.blue,
        ),
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Layanan Pelanggan"),
        content: const Text("Hubungi kami melalui email: support@ecoapp.id"),
        actions: [
          TextButton(
            child: const Text("Tutup"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pertanyaan yang Sering Diajukan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue],
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Punya pertanyaan? Kami punya jawabannya!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari pertanyaan...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: _filteredFAQs.map(_buildFAQItem).toList(),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showContactDialog,
                    icon: const Icon(Icons.support_agent),
                    label: const Text("Hubungi Layanan Pelanggan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
