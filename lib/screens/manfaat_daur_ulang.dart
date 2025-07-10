import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:google_fonts/google_fonts.dart';

class ManfaatDaurUlangPage extends StatelessWidget {
  const ManfaatDaurUlangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> points = [
      {
        'judul': 'Menghemat Energi',
        'isi':
            'Daur ulang mengurangi kebutuhan energi dibandingkan memproduksi dari bahan mentah. Contohnya, mendaur ulang aluminium menghemat hingga 95% energi.',
      },
      {
        'judul': 'Mengurangi Polusi',
        'isi':
            'Daur ulang mengurangi polusi udara dan air yang dihasilkan dari proses produksi barang baru.',
      },
      {
        'judul': 'Mengurangi Sampah di TPA',
        'isi':
            'Dengan mendaur ulang, volume sampah yang dikirim ke Tempat Pembuangan Akhir (TPA) berkurang secara signifikan.',
      },
      {
        'judul': 'Menghemat Sumber Daya Alam',
        'isi':
            'Daur ulang mengurangi kebutuhan akan bahan mentah seperti kayu, air, dan mineral.',
      },
      {
        'judul': 'Mengurangi Emisi Gas Rumah Kaca',
        'isi':
            'Produksi dari barang daur ulang menghasilkan lebih sedikit emisi karbon daripada produksi dari bahan mentah.',
      },
      {
        'judul': 'Mendukung Ekonomi Sirkular',
        'isi':
            'Daur ulang menciptakan lapangan kerja di sektor pengumpulan, pemrosesan, dan manufaktur bahan daur ulang.',
      },
      {
        'judul': 'Melindungi Ekosistem',
        'isi':
            'Mengurangi eksploitasi tambang dan pembukaan lahan hutan menjaga habitat satwa liar tetap utuh.',
      },
      {
        'judul': 'Meningkatkan Kesadaran Lingkungan',
        'isi':
            'Dengan melakukan daur ulang, masyarakat menjadi lebih sadar dan peduli terhadap lingkungan.',
      },
      {
        'judul': 'Mengurangi Ketergantungan Impor Bahan Mentah',
        'isi':
            'Dengan memanfaatkan limbah sebagai bahan baku, kebutuhan impor bahan mentah bisa ditekan.',
      },
      {
        'judul': 'Memberi Nilai Tambah Ekonomi dari Sampah',
        'isi':
            'Sampah yang didaur ulang bisa menjadi produk baru bernilai jual seperti kerajinan tangan, bahan bangunan, dan tekstil.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Poin Penting Manfaat Daur Ulang',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: points.length,
        itemBuilder: (context, index) {
          final point = points[index];
          return AnimatedCard(
            direction: AnimatedCardDirection.left,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  point['judul'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    point['isi'],
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}