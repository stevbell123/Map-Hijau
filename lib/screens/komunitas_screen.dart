import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/komunitas_provider.dart';

class KomunitasScreen extends StatefulWidget {
  @override
  _KomunitasScreenState createState() => _KomunitasScreenState();
}

class _KomunitasScreenState extends State<KomunitasScreen> {
  String selectedCategory = 'Semua';
  String filterType = 'Semua';
  bool _isLoading = false;

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
      "color": Colors.green.shade600,
    },
    {
      "nama": "Komunitas Daur Ulang",
      "deskripsi": "Belajar mengolah sampah.",
      "anggota": 80,
      "icon": Icons.recycling,
      "color": Colors.green.shade500,
    },
    {
      "nama": "Komunitas Edukasi",
      "deskripsi": "Edukasi tentang lingkungan.",
      "anggota": 100,
      "icon": Icons.menu_book,
      "color": Colors.green.shade700,
    },
    {
      "nama": "Komunitas Bersih Pantai",
      "deskripsi": "Aksi bersih-bersih pantai.",
      "anggota": 65,
      "icon": Icons.beach_access,
      "color": Colors.green.shade400,
    },
    {
      "nama": "Komunitas Tanam Pohon",
      "deskripsi": "Menanam dan merawat pohon.",
      "anggota": 150,
      "icon": Icons.nature,
      "color": Colors.green.shade800,
    },
    {
      "nama": "Komunitas Kompos",
      "deskripsi": "Membuat kompos dari sampah organik.",
      "anggota": 45,
      "icon": Icons.eco_outlined,
      "color": Colors.green.shade300,
    },
    {
      "nama": "Komunitas Energi Terbarukan",
      "deskripsi": "Diskusi energi bersih.",
      "anggota": 90,
      "icon": Icons.bolt,
      "color": Colors.green.shade900,
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

  void _showCustomSnackBar(String message, {bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isError ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isError ? Icons.error : Icons.check_circle,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 1, end: 0).fadeIn(),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> _joinCommunity(String communityName) async {
    try {
      setState(() {
        _isLoading = false;
      });

      await Future.delayed(Duration(milliseconds: 100));

      setState(() {
        komunitasStatus[communityName] = true;
        _isLoading = false;
      });

      _showCustomSnackBar("Berhasil bergabung dengan $communityName");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showCustomSnackBar("Terjadi kesalahan: ${e.toString()}", isError: true);
    }
  }

  void _showLeaveConfirmation(String communityName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Konfirmasi",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Apakah Anda yakin ingin keluar dari $communityName?",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Batal",
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  komunitasStatus[communityName] = false;
                });
                Navigator.of(context).pop();
                _showCustomSnackBar("Anda telah keluar dari $communityName");
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Keluar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
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
    Color _selectedColor = Colors.green.shade600;
    IconData _selectedIcon = Icons.eco;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Buat Komunitas Baru",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.group),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.description),
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
                      // Removed color selection section
                      Text(
                        "Pilih Ikon:",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              [
                                Icons.eco,
                                Icons.recycling,
                                Icons.menu_book,
                                Icons.beach_access,
                                Icons.nature,
                                Icons.bolt,
                                Icons.water_drop,
                              ].map((icon) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIcon = icon;
                                    });
                                  },
                                  child: _IconOption(
                                    icon: icon,
                                    isSelected: _selectedIcon == icon,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                        _showCustomSnackBar("Komunitas berhasil dibuat!");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Buat",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Buat Event Baru",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.group),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.event),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.description),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.location_on),
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
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.green,
                        ),
                        title: Text(
                          _selectedDate == null
                              ? 'Pilih Tanggal'
                              : 'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}',
                          style: GoogleFonts.poppins(),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.green),
                        title: Text(
                          _selectedTime == null
                              ? 'Pilih Waktu'
                              : 'Waktu: ${_selectedTime!.format(context)}',
                          style: GoogleFonts.poppins(),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                      _showCustomSnackBar("Event berhasil dibuat!");
                    } else {
                      _showCustomSnackBar(
                        "Harap lengkapi semua data",
                        isError: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Buat",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Undang Teman",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pilih komunitas untuk diundang:",
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 16),
                    ...komunitasList.map((community) {
                      final communityName = community['nama'] as String;
                      final isActive = komunitasStatus[communityName] == true;
                      return CheckboxListTile(
                        title: Text(
                          communityName,
                          style: GoogleFonts.poppins(),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                      _showCustomSnackBar(
                        "Undangan telah dikirim ke $selectedCount komunitas",
                      );
                    } else {
                      _showCustomSnackBar(
                        "Pilih setidaknya satu komunitas",
                        isError: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Undang",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
        elevation: 0,
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
        padding: const EdgeInsets.only(bottom: 5),
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spacing: 12,
          spaceBetweenChildren: 12,
          children: [
            SpeedDialChild(
              child: Icon(Icons.group_add, color: Colors.white),
              backgroundColor: Colors.green.shade600,
              label: 'Buat Komunitas',
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              onTap: _showCreateCommunityDialog,
            ),
            SpeedDialChild(
              child: Icon(Icons.event, color: Colors.white),
              backgroundColor: Colors.green.shade500,
              label: 'Buat Event',
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              onTap: () => _showCreateEventDialog(context),
            ),
            SpeedDialChild(
              child: Icon(Icons.person_add, color: Colors.white),
              backgroundColor: Colors.green.shade400,
              label: 'Undang Teman',
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          hintText: 'Cari komunitas...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
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
                            label: Text(
                              item,
                              style: GoogleFonts.poppins(
                                color:
                                    selectedCategory == item
                                        ? Colors.green.shade800
                                        : Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: selectedCategory == item,
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = item;
                              });
                            },
                            selectedColor: Colors.green.shade100,
                            backgroundColor: Colors.grey.shade100,
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
              Text("Semua", style: GoogleFonts.poppins()),
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
              Text("Diikuti", style: GoogleFonts.poppins()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      child: AnimationLimiter(
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: filteredKomunitas.length,
          itemBuilder: (context, index) {
            final item = filteredKomunitas[index];
            final nama = item['nama'] as String;
            bool isFollowing = komunitasStatus[nama] ?? false;

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            (item['color'] as Color).withOpacity(0.02),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: (item['color'] as Color).withOpacity(
                                      0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    size: 28,
                                    color: item['color'] as Color,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nama,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['deskripsi'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.people,
                                                  size: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "${item['anggota']} Anggota",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          isFollowing
                                              ? TextButton(
                                                onPressed:
                                                    () =>
                                                        _showLeaveConfirmation(
                                                          nama,
                                                        ),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 24,
                                                      ),
                                                ),
                                                child: Text(
                                                  "Keluar",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                              : _isLoading
                                              ? Container(
                                                width: 80,
                                                height: 40,
                                                child: Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade300,
                                                  highlightColor:
                                                      Colors.grey.shade100,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              : ElevatedButton(
                                                onPressed:
                                                    () => _joinCommunity(nama),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green.shade600,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 32,
                                                      ),
                                                  elevation: 3,
                                                ),
                                                child: Text(
                                                  "Gabung",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ), // Removed .animate().scale()
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
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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
        border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.green : Colors.grey.shade700,
      ),
    ); // Removed .animate().scale()
  }
}

class EventScreen extends StatelessWidget {
  final Event? newEvent;

  const EventScreen({super.key, this.newEvent});

  void _showCustomNotification(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isError ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isError ? Icons.error : Icons.check_circle,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 1, end: 0).fadeIn(),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

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
        elevation: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) => provider.setEventSearchQuery(value),
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              hintText: 'Cari event...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
                  color: Colors.black.withOpacity(0.05),
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
                          label: Text(
                            item,
                            style: GoogleFonts.poppins(
                              color:
                                  filter == item
                                      ? Colors.green.shade800
                                      : Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: filter == item,
                          onSelected: (_) => provider.setEventFilter(item),
                          selectedColor: Colors.green.shade100,
                          backgroundColor: Colors.grey.shade100,
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
            child: AnimationLimiter(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isJoined = provider.isParticipating(event.nama);

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Colors.green.withOpacity(0.05),
                                ],
                              ),
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
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade600,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.nama,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              event.komunitas,
                                              style: GoogleFonts.poppins(
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
                                  Text(
                                    event.deskripsi,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${event.tanggal} • ${event.waktu}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              event.lokasi,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.people,
                                              size: 14,
                                              color: Colors.green.shade600,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${event.peserta} Peserta",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          provider.toggleEventParticipation(
                                            event.nama,
                                          );
                                          _showCustomNotification(
                                            context,
                                            isJoined
                                                ? "Batal mengikuti ${event.nama}"
                                                : "Anda mengikuti ${event.nama}",
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              isJoined
                                                  ? Colors.red
                                                  : Colors.green.shade600,
                                          foregroundColor: Colors.white,
                                          minimumSize: Size(100, 36),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          elevation: 2,
                                        ),
                                        child: Text(
                                          isJoined ? "Batal" : "Ikuti",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ), // Removed .animate().scale(duration: 200.ms)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
