import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Notifikasi (using _SettingTile as it has switch)
          _SettingTile(
            icon: Icons.notifications,
            title: "Notifikasi",
            isSwitch: true,
            value: authProvider.notificationEnabled,
            onChanged: (val) {
              authProvider.setNotificationEnabled(val);
            },
            onTap: () {},
          ),
          
          const SizedBox(height: 16),
          
          Card(
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.lock, color: theme.iconTheme.color),
              title: Text("Keamanan", style: theme.textTheme.bodyMedium),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: theme.iconTheme.color, size: 16),
              onTap: () {
                Navigator.pushNamed(context, '/security');
              },
            ),
          ),
          
          Card(
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.language, color: theme.iconTheme.color),
              title: Text("Bahasa", style: theme.textTheme.bodyMedium),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: theme.iconTheme.color, size: 16),
              onTap: () {
                Navigator.pushNamed(context, '/language');
              },
            ),
          ),
          
          // Tentang Aplikasi
          Card(
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.info, color: theme.iconTheme.color),
              title: Text("Tentang Aplikasi", style: theme.textTheme.bodyMedium),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: theme.iconTheme.color, size: 16),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSwitch;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSwitch = false,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: theme.iconTheme.color),
        title: Text(title, style: theme.textTheme.bodyMedium),
        trailing: isSwitch
            ? Switch(
                value: value ?? false,
                onChanged: onChanged,
                activeColor: Colors.blue.shade900,
              )
            : Icon(Icons.arrow_forward_ios,
                color: theme.iconTheme.color, size: 16),
        onTap: isSwitch ? null : onTap,
      ),
    );
  }
}