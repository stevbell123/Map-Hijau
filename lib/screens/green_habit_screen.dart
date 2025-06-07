import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class GreenHabitScreen extends StatelessWidget {
  const GreenHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Kebiasaan Harian",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[800]!, Colors.green[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: _buildFilterDropdown(context),
            ),
          ),
          _buildHabitsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addHabit(context),
        backgroundColor: Colors.green[700],
        elevation: 4,
        icon: const Icon(Icons.add_circle_outline, size: 24),
        label: const Text(
          "Tambah Kebiasaan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 160, 
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: provider.filterStatus,
                icon: Icon(Icons.filter_list, color: Colors.green[800]),
                style: TextStyle(
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  if (value != null) {
                    provider.setFilterStatus(value);
                  }
                },
                items:
                    ['Semua', 'Selesai', 'Belum Selesai'].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitsList() {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final habits = provider.getFilteredHabits();

        if (habits.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, size: 64, color: Colors.green[300]),
                  const SizedBox(height: 16),
                  Text(
                    provider.filterStatus == 'Selesai'
                        ? "Belum ada kebiasaan yang selesai"
                        : provider.filterStatus == 'Belum Selesai'
                        ? "Semua kebiasaan sudah selesai"
                        : "Belum ada kebiasaan",
                    style: TextStyle(color: Colors.green[800], fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final item = habits[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          item['done']
                              ? [Colors.green[100]!, Colors.green[50]!]
                              : [Colors.white, Colors.green[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            item['done'] ? Colors.green[100] : Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] ?? Icons.eco,
                        color:
                            item['done']
                                ? Colors.green[600]
                                : Colors.green[800],
                      ),
                    ),
                    title: Text(
                      item['text'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration:
                            item['done'] ? TextDecoration.lineThrough : null,
                        color:
                            item['done']
                                ? Colors.green[600]
                                : Colors.green[900],
                      ),
                    ),
                    trailing: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      activeColor: Colors.green[600],
                      value: item['done'],
                      onChanged: (bool? value) {
                        provider.toggleHabitStatus(
                          provider.habits.indexOf(item),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }, childCount: habits.length),
        );
      },
    );
  }

  void _addHabit(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    TextEditingController _habitController = TextEditingController();
    IconData selectedIcon = Icons.eco;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              title: Text(
                "Tambah Kebiasaan Baru",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _habitController,
                    decoration: InputDecoration(
                      hintText: "Masukkan kebiasaan baru",
                      filled: true,
                      fillColor: Colors.green[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Pilih ikon:",
                    style: TextStyle(color: Colors.green[800]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildIconOption(Icons.local_drink, selectedIcon, () {
                        setStateDialog(() {
                          selectedIcon = Icons.local_drink;
                        });
                      }),
                      _buildIconOption(
                        Icons.lightbulb_outline,
                        selectedIcon,
                        () {
                          setStateDialog(() {
                            selectedIcon = Icons.lightbulb_outline;
                          });
                        },
                      ),
                      _buildIconOption(Icons.shopping_bag, selectedIcon, () {
                        setStateDialog(() {
                          selectedIcon = Icons.shopping_bag;
                        });
                      }),
                      _buildIconOption(
                        Icons.cleaning_services,
                        selectedIcon,
                        () {
                          setStateDialog(() {
                            selectedIcon = Icons.cleaning_services;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (_habitController.text.trim().isNotEmpty) {
                      provider.addHabit(
                        _habitController.text.trim(),
                        selectedIcon,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIconOption(
    IconData icon,
    IconData? selectedIcon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedIcon == icon ? Colors.green[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border:
              selectedIcon == icon
                  ? Border.all(color: Colors.green, width: 2)
                  : null,
        ),
        child: Icon(icon, color: Colors.green[800], size: 24),
      ),
    );
  }
}
