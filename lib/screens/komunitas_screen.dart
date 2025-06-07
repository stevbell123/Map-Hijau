import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(home: KomunitasScreen()));
}

class KomunitasScreen extends StatefulWidget {
  @override
  _KomunitasScreenState createState() => _KomunitasScreenState();
}

class _KomunitasScreenState extends State<KomunitasScreen> {
  String selectedCategory = 'Semua';
  String filterType = 'Semua';
  Map<String, bool> komunitasStatus = {
    'Komunitas Lingkungan': false,
    'Komunitas Daur Ulang': true,
    'Komunitas Edukasi': false,
    'Komunitas Bersih Pantai': false,
    'Komunitas Tanam Pohon': false,
    'Komunitas Kompos': false,
    'Komunitas Energi Terbarukan': false,
  };
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final komunitasList = [
    {
      "nama": "Komunitas Lingkungan",
      "deskripsi": "Peduli lingkungan sekitar.",
      "anggota": 120,
      "icon": Icons.eco,
      "color": Colors.green,
    },
    {
      "nama": "Komunitas Daur Ulang",
      "deskripsi": "Belajar mengolah sampah.",
      "anggota": 80,
      "icon": Icons.recycling,
      "color": Colors.blue,
    },
    {
      "nama": "Komunitas Edukasi",
      "deskripsi": "Edukasi tentang lingkungan.",
      "anggota": 100,
      "icon": Icons.menu_book,
      "color": Colors.orange,
    },
    {
      "nama": "Komunitas Bersih Pantai",
      "deskripsi": "Aksi bersih-bersih pantai.",
      "anggota": 65,
      "icon": Icons.beach_access,
      "color": Colors.teal,
    },
    {
      "nama": "Komunitas Tanam Pohon",
      "deskripsi": "Menanam dan merawat pohon.",
      "anggota": 150,
      "icon": Icons.nature,
      "color": Colors.brown,
    },
    {
      "nama": "Komunitas Kompos",
      "deskripsi": "Membuat kompos dari sampah organik.",
      "anggota": 45,
      "icon": Icons.eco_outlined,
      "color": Colors.lime,
    },
    {
      "nama": "Komunitas Energi Terbarukan",
      "deskripsi": "Diskusi energi bersih.",
      "anggota": 90,
      "icon": Icons.bolt,
      "color": Colors.yellow,
    },
  ];

  List<Map<String, dynamic>> get filteredKomunitas {
    return komunitasList.where((item) {
      final nama = item['nama'] as String;
      final isFollowing = komunitasStatus[nama] ?? false;

      if (filterType == 'Diikuti' && !isFollowing) return false;
      if (selectedCategory != 'Semua' &&
          !nama.toLowerCase().contains(selectedCategory.toLowerCase())) {
        return false;
      }
      if (searchQuery.isNotEmpty &&
          !nama.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showLeaveConfirmation(String communityName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin keluar dari $communityName?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Batal",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  komunitasStatus[communityName] = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Anda telah keluar dari $communityName"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text("Keluar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showCreateCommunityDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descController = TextEditingController();
    Color _selectedColor = Colors.green;
    IconData _selectedIcon = Icons.eco;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Buat Komunitas Baru"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Komunitas',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama komunitas tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text("Pilih Warna:"),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _ColorOption(
                          color: Colors.green,
                          isSelected: _selectedColor == Colors.green,
                          onTap:
                              () =>
                                  setState(() => _selectedColor = Colors.green),
                        ),
                        _ColorOption(
                          color: Colors.blue,
                          isSelected: _selectedColor == Colors.blue,
                          onTap:
                              () =>
                                  setState(() => _selectedColor = Colors.blue),
                        ),
                        _ColorOption(
                          color: Colors.orange,
                          isSelected: _selectedColor == Colors.orange,
                          onTap:
                              () => setState(
                                () => _selectedColor = Colors.orange,
                              ),
                        ),
                        _ColorOption(
                          color: Colors.teal,
                          isSelected: _selectedColor == Colors.teal,
                          onTap:
                              () =>
                                  setState(() => _selectedColor = Colors.teal),
                        ),
                        _ColorOption(
                          color: Colors.brown,
                          isSelected: _selectedColor == Colors.brown,
                          onTap:
                              () =>
                                  setState(() => _selectedColor = Colors.brown),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Pilih Ikon:"),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _IconOption(
                          icon: Icons.eco,
                          isSelected: _selectedIcon == Icons.eco,
                          onTap:
                              () => setState(() => _selectedIcon = Icons.eco),
                        ),
                        _IconOption(
                          icon: Icons.recycling,
                          isSelected: _selectedIcon == Icons.recycling,
                          onTap:
                              () => setState(
                                () => _selectedIcon = Icons.recycling,
                              ),
                        ),
                        _IconOption(
                          icon: Icons.menu_book,
                          isSelected: _selectedIcon == Icons.menu_book,
                          onTap:
                              () => setState(
                                () => _selectedIcon = Icons.menu_book,
                              ),
                        ),
                        _IconOption(
                          icon: Icons.beach_access,
                          isSelected: _selectedIcon == Icons.beach_access,
                          onTap:
                              () => setState(
                                () => _selectedIcon = Icons.beach_access,
                              ),
                        ),
                        _IconOption(
                          icon: Icons.nature,
                          isSelected: _selectedIcon == Icons.nature,
                          onTap:
                              () =>
                                  setState(() => _selectedIcon = Icons.nature),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    komunitasList.add({
                      "nama": _nameController.text,
                      "deskripsi": _descController.text,
                      "anggota": 1,
                      "icon": _selectedIcon,
                      "color": _selectedColor,
                    });
                    komunitasStatus[_nameController.text] = true;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Komunitas berhasil dibuat!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text("Buat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    final _locationController = TextEditingController();
    DateTime? _selectedDate;
    TimeOfDay? _selectedTime;
    String? _selectedCommunity;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Buat Event Baru"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCommunity,
                        decoration: InputDecoration(
                          labelText: 'Pilih Komunitas',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            komunitasList
                                .where(
                                  (community) =>
                                      komunitasStatus[community['nama']] ==
                                      true,
                                )
                                .map((community) {
                                  return DropdownMenuItem<String>(
                                    value: community['nama']?.toString() ?? '',
                                    child: Text(
                                      community['nama']?.toString() ??
                                          'Tidak diketahui',
                                    ),
                                  );
                                })
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCommunity = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih komunitas terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Judul Event',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Event',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Lokasi',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                          _selectedDate == null
                              ? 'Pilih Tanggal'
                              : 'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}',
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text(
                          _selectedTime == null
                              ? 'Pilih Waktu'
                              : 'Waktu: ${_selectedTime!.format(context)}',
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() => _selectedTime = time);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedDate != null &&
                        _selectedTime != null) {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EventScreen(
                                newEvent: {
                                  "nama": _titleController.text,
                                  "komunitas":
                                      _selectedCommunity ?? "Komunitas Saya",
                                  "deskripsi": _descController.text,
                                  "tanggal": DateFormat(
                                    'dd MMM yyyy',
                                  ).format(_selectedDate!),
                                  "waktu": _selectedTime!.format(context),
                                  "lokasi": _locationController.text,
                                  "peserta": 1,
                                  "color": Colors.green,
                                },
                              ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Event berhasil dibuat!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Harap lengkapi semua data"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text("Buat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _navigateToEventScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: Icon(Icons.event, color: Colors.green.shade800),
            onPressed: _navigateToEventScreen,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildCommunityList()),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.group_add),
            label: 'Buat Komunitas',
            onTap: _showCreateCommunityDialog,
          ),
          SpeedDialChild(
            child: Icon(Icons.event),
            label: 'Buat Event',
            onTap: () => _showCreateEventDialog(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.search),
            label: 'Cari Komunitas',
            onTap: () {
              setState(() {
                searchQuery = '';
                searchController.clear();
              });
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari komunitas...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                        searchQuery = '';
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ["Semua", "Lingkungan", "Daur Ulang", "Edukasi"]
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(item),
                            selected: selectedCategory == item,
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = item;
                              });
                            },
                            selectedColor: Colors.green.shade100,
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(
                              color:
                                  selectedCategory == item
                                      ? Colors.green.shade800
                                      : Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color:
                                    selectedCategory == item
                                        ? Colors.green
                                        : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 'Semua',
                groupValue: filterType,
                onChanged: (value) {
                  setState(() {
                    filterType = value.toString();
                  });
                },
                activeColor: Colors.green,
              ),
              Text("Semua"),
              SizedBox(width: 20),
              Radio(
                value: 'Diikuti',
                groupValue: filterType,
                onChanged: (value) {
                  setState(() {
                    filterType = value.toString();
                  });
                },
                activeColor: Colors.green,
              ),
              Text("Diikuti"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityList() {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: filteredKomunitas.length,
      itemBuilder: (context, index) {
        final item = filteredKomunitas[index];
        final nama = item['nama'] as String;
        bool isFollowing = komunitasStatus[nama] ?? false;

        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: (item['color'] as Color).withOpacity(0.15),
                  child: Icon(
                    item['icon'] as IconData,
                    size: 28,
                    color: item['color'] as Color,
                  ),
                ),
                title: Text(
                  nama,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['deskripsi'] as String),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "${item['anggota']} Anggota",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                trailing:
                    isFollowing
                        ? TextButton(
                          onPressed: () => _showLeaveConfirmation(nama),
                          child: Text(
                            "Keluar",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                        : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              komunitasStatus[nama] = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Anda bergabung dengan $nama"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Gabung"),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EventScreen extends StatefulWidget {
  final Map<String, dynamic>? newEvent;

  const EventScreen({this.newEvent, Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String selectedFilter = 'Semua';
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<Map<String, dynamic>> eventList = [
    {
      "nama": "Bersih-bersih Kota",
      "komunitas": "Komunitas Lingkungan",
      "deskripsi": "Aksi bersih-bersih lingkungan kota",
      "tanggal": "15 Jun 2023",
      "waktu": "08:00 - 12:00",
      "lokasi": "Taman Kota",
      "peserta": 45,
      "color": Colors.green,
    },
    {
      "nama": "Workshop Daur Ulang",
      "komunitas": "Komunitas Daur Ulang",
      "deskripsi": "Belajar membuat kerajinan dari sampah",
      "tanggal": "18 Jun 2023",
      "waktu": "13:00 - 16:00",
      "lokasi": "Ruang Serbaguna",
      "peserta": 30,
      "color": Colors.blue,
    },
    {
      "nama": "Penanaman 1000 Pohon",
      "komunitas": "Komunitas Tanam Pohon",
      "deskripsi": "Aksi penanaman pohon di area gundul",
      "tanggal": "20 Jun 2023",
      "waktu": "07:00 - 11:00",
      "lokasi": "Lereng Gunung",
      "peserta": 80,
      "color": Colors.brown,
    },
    {
      "nama": "Aksi Pantai Bersih",
      "komunitas": "Komunitas Bersih Pantai",
      "deskripsi": "Membersihkan sampah di pantai",
      "tanggal": "25 Jun 2023",
      "waktu": "09:00 - 14:00",
      "lokasi": "Pantai Indah",
      "peserta": 65,
      "color": Colors.teal,
    },
    {
      "nama": "Demo Panel Surya",
      "komunitas": "Komunitas Energi Terbarukan",
      "deskripsi": "Demonstrasi penggunaan panel surya",
      "tanggal": "30 Jun 2023",
      "waktu": "10:00 - 15:00",
      "lokasi": "Halaman Kampus",
      "peserta": 40,
      "color": Colors.yellow,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.newEvent != null) {
      eventList.insert(0, widget.newEvent!);
    }
  }

  List<Map<String, dynamic>> get filteredEvents {
    return eventList.where((event) {
      if (selectedFilter != 'Semua' &&
          !event['komunitas'].toLowerCase().contains(
            selectedFilter.toLowerCase(),
          )) {
        return false;
      }
      if (searchQuery.isNotEmpty &&
          !event['nama'].toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: _buildSearchBar(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade800),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [_buildFilterSection(), Expanded(child: _buildEventList())],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari event...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                        searchQuery = '';
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              [
                    "Semua",
                    "Lingkungan",
                    "Daur Ulang",
                    "Tanam Pohon",
                    "Bersih Pantai",
                  ]
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(item),
                        selected: selectedFilter == item,
                        onSelected: (value) {
                          setState(() {
                            selectedFilter = item;
                          });
                        },
                        selectedColor: Colors.green.shade100,
                        backgroundColor: Colors.grey.shade100,
                        labelStyle: TextStyle(
                          color:
                              selectedFilter == item
                                  ? Colors.green.shade800
                                  : Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color:
                                selectedFilter == item
                                    ? Colors.green
                                    : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      color: event['color'] as Color,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['nama'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            event['komunitas'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(event['deskripsi']),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      "${event['tanggal']} • ${event['waktu']}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(event['lokasi'], style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      "${event['peserta']} Peserta",
                      style: TextStyle(fontSize: 12),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Anda berpartisipasi dalam ${event['nama']}",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text("Ikuti"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(100, 36),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconOption({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.green : Colors.grey.shade700,
        ),
      ),
    );
  }
}
