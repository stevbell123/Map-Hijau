import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'faq_screen.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
          _SettingTile(
            icon: Icons.lock,
            title: "Keamanan",
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SecurityPage()),
              );
            },
          ),
          _SettingTile(
            icon: Icons.help,
            title: "Pusat Bantuan",
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FAQScreen()),
              );
            },
          ),
          _SettingTile(
            icon: Icons.info,
            title: "Tentang Aplikasi",
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutAppPage()),
              );
            },
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
      child: isSwitch
          ? ListTile(
              leading: Icon(icon, color: theme.iconTheme.color),
              title: Text(title, style: theme.textTheme.bodyMedium),
              trailing: Switch(
                value: value ?? false,
                onChanged: onChanged,
                activeColor: Colors.blue.shade900,
              ),
            )
          : InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: ListTile(
                leading: Icon(icon, color: theme.iconTheme.color),
                title: Text(title, style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: theme.iconTheme.color, size: 16),
              ),
            ),
    );
  }
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool is2FAEnabled = false;
  bool isBiometricEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

  List<Map<String, String>> activeDevices = [
    {
      "name": "Android (Device 1)",
      "lastActive": "07-07-2025",
      "id": "device_1",
    },
    {
      "name": "Chrome - Windows",
      "lastActive": "06-07-2025",
      "id": "device_2",
    },
  ];

  void _show2FAEnableDialog() {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Aktifkan Autentikasi Dua Langkah"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Masukkan kode OTP yang dikirim ke email/nomor Anda. (Coba: 123456)"),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Kode OTP"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (otpController.text == "123456") {
                setState(() {
                  is2FAEnabled = true;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("2FA berhasil diaktifkan!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kode OTP salah!")),
                );
              }
            },
            child: const Text("Verifikasi"),
          ),
        ],
      ),
    );
  }

  void _showActiveDevicesDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Perangkat Aktif"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: activeDevices.isNotEmpty
                ? activeDevices.map((device) {
                    return ListTile(
                      leading: Icon(Icons.devices),
                      title: Text(device["name"] ?? ""),
                      subtitle: Text("Terakhir aktif: ${device["lastActive"] ?? ""}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        tooltip: "Keluar dari perangkat ini",
                        onPressed: () {
                          _logoutFromDevice(device["id"]!);
                        },
                      ),
                    );
                  }).toList()
                : [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Tidak ada perangkat aktif."),
                    )
                  ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _logoutFromDevice(String deviceId) {
    setState(() {
      activeDevices.removeWhere((d) => d["id"] == deviceId);
    });
    Navigator.pop(context); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Berhasil keluar dari perangkat!")),
    );
  }

  void _logoutAllDevices() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Anda yakin ingin keluar dari semua perangkat?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                activeDevices.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Berhasil keluar dari semua perangkat!")),
              );
            },
            child: const Text("Ya, keluar"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBiometricToggle(bool enable) async {
    if (enable) {
      final isAvailable = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();
      if (!isAvailable || !isDeviceSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perangkat tidak mendukung biometrik!")),
        );
        return;
      }
      try {
        final didAuthenticate = await auth.authenticate(
          localizedReason: "Verifikasi untuk mengaktifkan biometrik",
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuthenticate) {
          setState(() {
            isBiometricEnabled = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Autentikasi biometrik diaktifkan!")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengaktifkan biometrik.")),
        );
      }
    } else {
      setState(() {
        isBiometricEnabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Autentikasi biometrik dinonaktifkan!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keamanan"),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Pengaturan Keamanan",
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.green),
            title: Text("Autentikasi Dua Langkah"),
            trailing: Switch(
              value: is2FAEnabled,
              onChanged: (val) {
                if (val) {
                  _show2FAEnableDialog();
                } else {
                  setState(() {
                    is2FAEnabled = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Autentikasi dua langkah dinonaktifkan")),
                  );
                }
              },
            ),
            onTap: () {
              if (!is2FAEnabled) {
                _show2FAEnableDialog();
              } else {
                setState(() {
                  is2FAEnabled = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Autentikasi dua langkah dinonaktifkan")),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.devices, color: Colors.orange),
            title: Text("Kelola Perangkat Aktif"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showActiveDevicesDialog,
          ),
          ListTile(
            leading: Icon(Icons.fingerprint, color: Colors.purple),
            title: Text("Autentikasi Sidik Jari/FaceID"),
            trailing: Switch(
              value: isBiometricEnabled,
              onChanged: (val) {
                _handleBiometricToggle(val);
              },
            ),
            onTap: () {
              _handleBiometricToggle(!isBiometricEnabled);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Keluar dari Semua Perangkat"),
            onTap: _logoutAllDevices,
          ),
        ],
      ),
    );
  }
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: _AboutAppContent(),
      ),
    );
  }
}

class _AboutAppContent extends StatefulWidget {
  const _AboutAppContent();

  @override
  State<_AboutAppContent> createState() => _AboutAppContentState();
}

class _AboutAppContentState extends State<_AboutAppContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMember(String name, String nim) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.person, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(child: Text("$name ($nim)", style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aplikasi ini dibuat oleh kelompok 13 yang berisi:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildMember("Steven David H Malau", "23111140"),
            _buildMember("Steven Raffael Sidauruk", "231112060"),
            _buildMember("Wan Saka Nasa", "231111488"),
            _buildMember("William Patar Wijaya Marpaung", "231112393"),
            const SizedBox(height: 16),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + 0.1 * _controller.value,
                    child: Transform.rotate(
                      angle: 0.2 * _controller.value,
                      child: child,
                    ),
                  );
                },
                child: const Icon(
                  Icons.emoji_objects,
                  color: Colors.amber,
                  size: 56,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}