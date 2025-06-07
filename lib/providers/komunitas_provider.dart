import 'package:flutter/material.dart';

class Komunitas {
  final String nama;
  final String deskripsi;
  final int anggota;
  final IconData icon;
  final Color color;
  final String kategori;

  Komunitas({
    required this.nama,
    required this.deskripsi,
    required this.anggota,
    required this.icon,
    required this.color,
    required this.kategori,
  });
}

class Event {
  final String nama;
  final String komunitas;
  final String deskripsi;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final int peserta;
  final Color color;

  Event({
    required this.nama,
    required this.komunitas,
    required this.deskripsi,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.peserta,
    required this.color,
  });
}

class KomunitasProvider extends ChangeNotifier {
  // Filter state
  String selectedCategory = 'Semua';
  String filterType = 'Semua';
  String searchQuery = '';
  String eventFilter = 'Semua';
  String eventSearchQuery = '';

  // Komunitas data
  final List<Komunitas> _komunitasList = [
    Komunitas(
      nama: "Komunitas Lingkungan",
      deskripsi: "Peduli lingkungan sekitar.",
      anggota: 120,
      icon: Icons.eco,
      color: Colors.green,
      kategori: "Lingkungan",
    ),
    Komunitas(
      nama: "Komunitas Daur Ulang",
      deskripsi: "Belajar mengolah sampah.",
      anggota: 80,
      icon: Icons.recycling,
      color: Colors.blue,
      kategori: "Daur Ulang",
    ),
    Komunitas(
      nama: "Komunitas Edukasi",
      deskripsi: "Edukasi tentang lingkungan.",
      anggota: 100,
      icon: Icons.menu_book,
      color: Colors.orange,
      kategori: "Edukasi",
    ),
    Komunitas(
      nama: "Komunitas Bersih Pantai",
      deskripsi: "Aksi bersih-bersih pantai.",
      anggota: 65,
      icon: Icons.beach_access,
      color: Colors.teal,
      kategori: "Lingkungan",
    ),
  ];

  // Events data
  final List<Event> _eventList = [
    Event(
      nama: "Bersih-bersih Kota",
      komunitas: "Komunitas Lingkungan",
      deskripsi: "Aksi bersih-bersih lingkungan kota",
      tanggal: "15 Jun 2023",
      waktu: "08:00 - 12:00",
      lokasi: "Taman Kota",
      peserta: 45,
      color: Colors.green,
    ),
    Event(
      nama: "Workshop Daur Ulang",
      komunitas: "Komunitas Daur Ulang",
      deskripsi: "Belajar membuat kerajinan dari sampah",
      tanggal: "18 Jun 2023",
      waktu: "13:00 - 16:00",
      lokasi: "Ruang Serbaguna",
      peserta: 30,
      color: Colors.blue,
    ),
  ];

  // Komunitas status (ikuti/tidak)
  final Map<String, bool> _komunitasStatus = {
    'Komunitas Lingkungan': false,
    'Komunitas Daur Ulang': true,
    'Komunitas Edukasi': false,
    'Komunitas Bersih Pantai': false,
  };

  // Event participation status
  final Map<String, bool> _eventParticipation = {};

  // Getter for filtered komunitas
  List<Komunitas> get filteredKomunitas {
    return _komunitasList.where((komunitas) {
      final isFollowing = _komunitasStatus[komunitas.nama] ?? false;

      // Filter by category
      if (selectedCategory != 'Semua' && komunitas.kategori != selectedCategory) {
        return false;
      }

      // Filter by follow status
      if (filterType == 'Diikuti' && !isFollowing) {
        return false;
      }

      // Filter by search query
      if (searchQuery.isNotEmpty &&
          !komunitas.nama.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }

  // Getter for filtered events
  List<Event> get filteredEvents {
    return _eventList.where((event) {
      // Filter by category
      if (eventFilter != 'Semua' &&
          !event.komunitas.toLowerCase().contains(eventFilter.toLowerCase())) {
        return false;
      }

      // Filter by search query
      if (eventSearchQuery.isNotEmpty &&
          !event.nama.toLowerCase().contains(eventSearchQuery.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }

  // Get komunitas by name
  Komunitas? getKomunitasByName(String name) {
    try {
      return _komunitasList.firstWhere((komunitas) => komunitas.nama == name);
    } catch (e) {
      return null;
    }
  }

  // Get event by name
  Event? getEventByName(String name) {
    try {
      return _eventList.firstWhere((event) => event.nama == name);
    } catch (e) {
      return null;
    }
  }

  // Check if user follows a komunitas
  bool isFollowing(String komunitasName) {
    return _komunitasStatus[komunitasName] ?? false;
  }

  // Check if user participates in an event
  bool isParticipating(String eventName) {
    return _eventParticipation[eventName] ?? false;
  }

  // Toggle follow status for komunitas
  void toggleFollowKomunitas(String komunitasName) {
    _komunitasStatus[komunitasName] = !(_komunitasStatus[komunitasName] ?? false);
    notifyListeners();
  }

  // Toggle participation status for event
  void toggleEventParticipation(String eventName) {
    _eventParticipation[eventName] = !(_eventParticipation[eventName] ?? false);
    notifyListeners();
  }

  // Add new komunitas
  void addKomunitas(Komunitas newKomunitas) {
    _komunitasList.add(newKomunitas);
    _komunitasStatus[newKomunitas.nama] = true;
    notifyListeners();
  }

  // Add new event
  void addEvent(Event newEvent) {
    _eventList.add(newEvent);
    notifyListeners();
  }

  // Update search query for komunitas
  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // Update search query for events
  void setEventSearchQuery(String query) {
    eventSearchQuery = query;
    notifyListeners();
  }

  // Update selected category
  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  // Update filter type
  void setFilterType(String filter) {
    filterType = filter;
    notifyListeners();
  }

  // Update event filter
  void setEventFilter(String filter) {
    eventFilter = filter;
    notifyListeners();
  }
}