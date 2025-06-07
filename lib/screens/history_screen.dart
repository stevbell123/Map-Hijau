import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> semuaRiwayat = [
    {'nama': 'Membuang sampah di lokasi A', 'kategori': 'Produktif'},
    {'nama': 'Menukar poin dengan voucher', 'kategori': 'Santai'},
    {'nama': 'Bergabung dengan komunitas Hijau', 'kategori': 'Produktif'},
  ];

  String filterDipilih = 'Semua History';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void hapusRiwayat(int index) {
    setState(() {
      semuaRiwayat.removeAt(index);
    });
  }

  void ubahKategori(int index, String? kategoriBaru) {
    setState(() {
      semuaRiwayat[index]['kategori'] = kategoriBaru!;
    });
  }

  List<Map<String, String>> get riwayatDitampilkan {
    if (filterDipilih == 'Semua History') return semuaRiwayat;
    return semuaRiwayat
        .where((item) => item['kategori'] == filterDipilih)
        .toList();
  }

  Color badgeColor(String kategori) {
    switch (kategori) {
      case 'Produktif':
        return Colors.green;
      case 'Santai':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Aktivitas'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CD964), Color(0xFF5AC8FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Total riwayat
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Total Riwayat: ${semuaRiwayat.length}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Filter dropdown
              Row(
                children: [
                  Text('Filter: '),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: filterDipilih,
                    items: ['Semua History', 'Produktif', 'Santai']
                        .map(
                          (kategori) => DropdownMenuItem(
                            child: Text(kategori),
                            value: kategori,
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        filterDipilih = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // List riwayat
              Expanded(
                child: riwayatDitampilkan.isEmpty
                    ? Center(child: Text('Tidak ada riwayat.'))
                    : ListView.builder(
                        itemCount: riwayatDitampilkan.length,
                        itemBuilder: (context, indexFiltered) {
                          final itemFiltered =
                              riwayatDitampilkan[indexFiltered];
                          final indexAsli = semuaRiwayat.indexOf(itemFiltered);
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              title: Text(
                                itemFiltered['nama']!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              subtitle: Row(
                                children: [
                                  // badge kategori
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: badgeColor(
                                          itemFiltered['kategori']!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      itemFiltered['kategori']!,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  if (filterDipilih == 'Semua History')
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      constraints:
                                          BoxConstraints(maxWidth: 140),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton<String>(
                                        value: itemFiltered['kategori'],
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        dropdownColor: Colors.white,
                                        iconEnabledColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        items: ['Produktif', 'Santai']
                                            .map(
                                              (kategori) => DropdownMenuItem(
                                                child: Text(kategori),
                                                value: kategori,
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) =>
                                            ubahKategori(indexAsli, value),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => hapusRiwayat(indexAsli),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
