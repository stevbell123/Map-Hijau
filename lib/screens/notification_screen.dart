import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> _notifications = [
    {
      'title': 'Pembaruan Terbaru',
      'message': 'Ada informasi baru tentang pembuangan sampah di area Anda.',
      'time': '1 jam yang lalu',
    },
    {
      'title': 'Voucher Baru',
      'message': 'Anda mendapatkan voucher diskon 10% untuk pembuangan sampah.',
      'time': '2 jam yang lalu',
    },
    {
      'title': 'Pengumuman',
      'message': 'Jadwal pengambilan sampah hari ini telah diperbarui.',
      'time': '3 jam yang lalu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: authProvider.notificationEnabled
          ? _notifications.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return _buildNotificationItem(
                      context,
                      notification['title']!,
                      notification['message']!,
                      notification['time']!,
                      index,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'Tidak ada notifikasi',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Notifikasi dimatikan',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Aktifkan notifikasi di Pengaturan',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, String title, String message, String time, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              _notifications.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifikasi dihapus'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        onTap: () {
          _showNotificationDetail(context, title, message);
        },
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}