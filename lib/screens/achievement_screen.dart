import 'package:flutter/material.dart';

class AchievementScreen extends StatefulWidget {
  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final List<Map<String, dynamic>> achievements = [
    {
      "icon": Icons.delete_outline,
      "title": "Pahlawan Hijau",
      "description": "Buang sampah 10 kali",
      "unlocked": true,
      "progress": 1.0,
      "target": 10,
      "current": 10,
    },
    {
      "icon": Icons.recycling,
      "title": "Daur Ulang Pro",
      "description": "Daur ulang 5 jenis sampah berbeda",
      "unlocked": false,
      "progress": 0.6,
      "target": 5,
      "current": 3,
    },
    {
      "icon": Icons.volunteer_activism,
      "title": "Relawan Lingkungan",
      "description": "Gabung komunitas kebersihan",
      "unlocked": true,
      "progress": 1.0,
      "target": 1,
      "current": 1,
    },
    {
      "icon": Icons.emoji_events,
      "title": "Poin Master",
      "description": "Kumpulkan 1000 poin",
      "unlocked": false,
      "progress": 0.35,
      "target": 1000,
      "current": 350,
    },
    {
      "icon": Icons.eco,
      "title": "Eco Warrior",
      "description": "Selesaikan 7 hari tantangan eco",
      "unlocked": false,
      "progress": 0.71,
      "target": 7,
      "current": 5,
    },
    {
      "icon": Icons.thumb_up,
      "title": "Pemula Baik",
      "description": "Selesaikan 3 misi pertama",
      "unlocked": true,
      "progress": 1.0,
      "target": 3,
      "current": 3,
    },
  ];

  int _totalAchievements = 0;
  int _unlockedAchievements = 0;

  @override
  void initState() {
    super.initState();
    _totalAchievements = achievements.length;
    _unlockedAchievements = achievements.where((a) => a['unlocked']).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Pencapaian"),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "$_unlockedAchievements/$_totalAchievements",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Progress Pencapaian",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _unlockedAchievements / _totalAchievements,
                  backgroundColor: Colors.green.shade900,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 12,
                ),
                const SizedBox(height: 8),
                Text(
                  "${((_unlockedAchievements / _totalAchievements) * 100).toStringAsFixed(0)}% selesai",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return GestureDetector(
                  onTap: () => _showAchievementDetails(context, achievement),
                  child: _buildAchievementCard(achievement),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: achievement['unlocked']
                        ? Colors.green.shade700
                        : Colors.grey.shade400,
                    child: Icon(
                      achievement['icon'],
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          achievement['description'],
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    achievement['unlocked']
                        ? Icons.check_circle
                        : Icons.lock_outline,
                    color: achievement['unlocked']
                        ? Colors.green.shade700
                        : Colors.grey,
                    size: 28,
                  ),
                ],
              ),
              if (!achievement['unlocked']) ...[
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: achievement['progress'],
                  backgroundColor: Colors.grey.shade300,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${achievement['current']}/${achievement['target']} (${(achievement['progress'] * 100).toStringAsFixed(0)}%)",
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: achievement['unlocked']
                  ? Colors.green.shade700
                  : Colors.grey.shade400,
              child: Icon(
                achievement['icon'],
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              achievement['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement['description'],
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            if (!achievement['unlocked']) ...[
              Text(
                "Progress:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: achievement['progress'],
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                minHeight: 10,
              ),
              const SizedBox(height: 5),
              Text(
                "${achievement['current']} dari ${achievement['target']} (${(achievement['progress'] * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontSize: 12,
                ),
              ),
            ],
            if (achievement['unlocked'])
              Text(
                "Telah dicapai!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
