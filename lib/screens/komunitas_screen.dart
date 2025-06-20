import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/komunitas_provider.dart';

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
    'Komunitas Daur Ulang': false,
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

      if (selectedCategory != 'Semua') {
        final categoryMatch =
            nama.toLowerCase().contains(selectedCategory.toLowerCase()) ||
            (item['deskripsi'] as String).toLowerCase().contains(
              selectedCategory.toLowerCase(),
            );
        if (!categoryMatch) return false;
      }

      // Filter berdasarkan pencarian
      if (searchQuery.isNotEmpty) {
        final searchMatch =
            nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (item['deskripsi'] as String).toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
        if (!searchMatch) return false;
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
                style: TextStyle(color: Colors.grey.shade800),
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
        return StatefulBuilder(
          builder: (context, setState) {
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = Colors.green;
                                });
                              },
                              child: _ColorOption(
                                color: Colors.green,
                                isSelected: _selectedColor == Colors.green,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = Colors.blue;
                                });
                              },
                              child: _ColorOption(
                                color: Colors.blue,
                                isSelected: _selectedColor == Colors.blue,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = Colors.orange;
                                });
                              },
                              child: _ColorOption(
                                color: Colors.orange,
                                isSelected: _selectedColor == Colors.orange,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = Colors.teal;
                                });
                              },
                              child: _ColorOption(
                                color: Colors.teal,
                                isSelected: _selectedColor == Colors.teal,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = Colors.brown;
                                });
                              },
                              child: _ColorOption(
                                color: Colors.brown,
                                isSelected: _selectedColor == Colors.brown,
                              ),
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = Icons.eco;
                                });
                              },
                              child: _IconOption(
                                icon: Icons.eco,
                                isSelected: _selectedIcon == Icons.eco,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = Icons.recycling;
                                });
                              },
                              child: _IconOption(
                                icon: Icons.recycling,
                                isSelected: _selectedIcon == Icons.recycling,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = Icons.menu_book;
                                });
                              },
                              child: _IconOption(
                                icon: Icons.menu_book,
                                isSelected: _selectedIcon == Icons.menu_book,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = Icons.beach_access;
                                });
                              },
                              child: _IconOption(
                                icon: Icons.beach_access,
                                isSelected: _selectedIcon == Icons.beach_access,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = Icons.nature;
                                });
                              },
                              child: _IconOption(
                                icon: Icons.nature,
                                isSelected: _selectedIcon == Icons.nature,
                              ),
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
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[800],
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text("Batal"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (mounted) {
                        setState(() {
                          selectedCategory = 'Semua';
                          filterType = 'Semua';
                          searchQuery = '';
                          searchController.clear();
                          komunitasList.insert(0, {
                            "nama": _nameController.text,
                            "deskripsi": _descController.text,
                            "anggota": 1,
                            "icon": _selectedIcon,
                            "color": _selectedColor,
                          });
                          komunitasStatus[_nameController.text] = true;
                        });
                      }

                      Navigator.of(context).pop();
                      await Future.delayed(Duration(milliseconds: 50));

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Komunitas berhasil dibuat!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[800],
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text("Batal"),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedDate != null &&
                        _selectedTime != null) {
                      final newEvent = Event(
                        nama: _titleController.text,
                        komunitas: _selectedCommunity ?? "Komunitas Saya",
                        deskripsi: _descController.text,
                        tanggal: DateFormat(
                          'dd MMM yyyy',
                        ).format(_selectedDate!),
                        waktu: _selectedTime!.format(context),
                        lokasi: _locationController.text,
                        peserta: 1,
                        color: Colors.green,
                      );

                      // Tambahkan event ke provider
                      final provider = Provider.of<KomunitasProvider>(
                        context,
                        listen: false,
                      );
                      provider.addEvent(newEvent);

                      Navigator.of(context).pop();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EventScreen()),
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

  void _showInviteFriendsDialog() {
    final selectedCommunities = <String, bool>{};

    for (var community in komunitasList) {
      final String name = community['nama'] as String;
      selectedCommunities[name] = false;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Undang Teman"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Pilih komunitas untuk diundang:"),
                    SizedBox(height: 16),
                    ...komunitasList.map((community) {
                      final communityName = community['nama'] as String;
                      final isActive = komunitasStatus[communityName] == true;

                      return CheckboxListTile(
                        title: Text(communityName),
                        value: selectedCommunities[communityName] ?? false,
                        onChanged:
                            isActive
                                ? (bool? value) {
                                  setState(() {
                                    selectedCommunities[communityName] =
                                        value ?? false;
                                  });
                                }
                                : null,
                        secondary: Icon(
                          community['icon'] as IconData,
                          color: community['color'] as Color,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.grey[800], // atau Colors.black.withOpacity(0.7)
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text("Batal"),
                ),

                ElevatedButton(
                  onPressed: () {
                    final selectedCount =
                        selectedCommunities.entries
                            .where(
                              (entry) =>
                                  komunitasStatus[entry.key] == true &&
                                  entry.value == true,
                            )
                            .length;

                    if (selectedCount > 0) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Undangan telah dikirim ke $selectedCount komunitas",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pilih setidaknya satu komunitas"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text("Undang"),
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
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.event, size: 28, color: Colors.green.shade800),
              onPressed: _navigateToEventScreen,
              tooltip: 'Event',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildCommunityList()),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SpeedDial(
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
              child: Icon(Icons.person_add),
              label: 'Undang Teman',
              onTap: _showInviteFriendsDialog,
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: filteredKomunitas.length,
        itemBuilder: (context, index) {
          final item = filteredKomunitas[index];
          final nama = item['nama'] as String;
          bool isFollowing = komunitasStatus[nama] ?? false;

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 24,
                          color: item['color'] as Color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['deskripsi'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${item['anggota']} Anggota",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                isFollowing
                                    ? ElevatedButton(
                                      onPressed:
                                          () => _showLeaveConfirmation(nama),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.red,
                                        shape: const StadiumBorder(),
                                        side: BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                      ),
                                      child: const Text("Keluar"),
                                    )
                                    : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          komunitasStatus[nama] = true;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Anda bergabung dengan $nama",
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            behavior:
                                                SnackBarBehavior
                                                    .fixed, // Fix FAB position
                                            margin: const EdgeInsets.only(
                                              bottom:
                                                  100, // Adjust based on FAB height
                                              left: 20,
                                              right: 20,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        foregroundColor: Colors.white,
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 32,
                                        ),
                                      ),
                                      child: const Text("Gabung"),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventScreen extends StatelessWidget {
  final Event? newEvent;

  const EventScreen({super.key, this.newEvent});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KomunitasProvider>(context);
    if (newEvent != null &&
        !provider.filteredEvents.any((e) => e.nama == newEvent!.nama)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.addEvent(newEvent!);
      });
    }

    final events = provider.filteredEvents;
    final filter = provider.eventFilter;
    final searchQuery = provider.eventSearchQuery;

    final TextEditingController searchController = TextEditingController(
      text: searchQuery,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) => provider.setEventSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Cari event...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          provider.setEventSearchQuery('');
                        },
                      )
                      : null,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade800),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
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
                    ].map((item) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(item),
                          selected: filter == item,
                          onSelected: (_) => provider.setEventFilter(item),
                          selectedColor: Colors.green.shade100,
                          backgroundColor: Colors.grey.shade100,
                          labelStyle: TextStyle(
                            color:
                                filter == item
                                    ? Colors.green.shade800
                                    : Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color:
                                  filter == item
                                      ? Colors.green
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final isJoined = provider.isParticipating(event.nama);

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
                            Container(width: 4, height: 40, color: event.color),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.nama,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    event.komunitas,
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
                        Text(event.deskripsi),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${event.tanggal} • ${event.waktu}",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(event.lokasi, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.people, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              "${event.peserta} Peserta",
                              style: TextStyle(fontSize: 12),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                provider.toggleEventParticipation(event.nama);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isJoined
                                          ? "Batal mengikuti ${event.nama}"
                                          : "Anda mengikuti ${event.nama}",
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isJoined ? Colors.grey : Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: Size(100, 36),
                              ),
                              child: Text(isJoined ? "Batal" : "Ikuti"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorOption({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _IconOption({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
