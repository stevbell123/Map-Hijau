import 'package:flutter/material.dart';

class HabitProvider with ChangeNotifier {
  List<Map<String, dynamic>> habits = [
    {
      'text': 'Bawa tumbler sendiri',
      'done': false,
      'icon': Icons.local_drink,
    },
    {
      'text': 'Matikan lampu saat tidak digunakan',
      'done': false,
      'icon': Icons.lightbulb_outline,
    },
    {
      'text': 'Ikut kegiatan bersih-bersih lingkungan',
      'done': false,
      'icon': Icons.cleaning_services,
    },
    {
      'text': 'Kurangi penggunaan kantong plastik',
      'done': false,
      'icon': Icons.shopping_bag,
    },
  ];

  String filterStatus = 'Semua'; 

  void setFilterStatus(String status) {
    filterStatus = status;
    notifyListeners();
  }

  void toggleHabitStatus(int index) {
    habits[index]['done'] = !habits[index]['done'];
    notifyListeners();
  }

  void addHabit(String text, IconData icon) {
    habits.add({
      'text': text,
      'done': false,
      'icon': icon,
    });
    notifyListeners();
  }

  List<Map<String, dynamic>> getFilteredHabits() {
    if (filterStatus == 'Selesai') {
      return habits.where((habit) => habit['done'] == true).toList();
    } else if (filterStatus == 'Belum Selesai') {
      return habits.where((habit) => habit['done'] == false).toList();
    } else {
      return habits;
    }
  }
}