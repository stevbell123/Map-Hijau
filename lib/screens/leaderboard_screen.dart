import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {"name": "Ali", "points": 1200, "avatar": "👑"},
    {"name": "Budi", "points": 1000, "avatar": "🌿"},
    {"name": "Citra", "points": 800, "avatar": "🌱"},
    {"name": "Dina", "points": 600, "avatar": "🍃"},
    {"name": "Eka", "points": 400, "avatar": "🪴"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: Text("Pahlawan Lingkungan"),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final user = leaderboardData[index];
          return Card(
            color: Colors.green.shade100,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green.shade700,
                child: Text(
                  user['avatar'],
                  style: TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                user['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Poin: ${user['points']}"),
              trailing: Icon(Icons.recycling, color: Colors.green.shade900),
            ),
          );
        },
      ),
    );
  }
}
