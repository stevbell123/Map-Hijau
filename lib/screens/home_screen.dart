import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'sampah_screen.dart';
import 'komunitas_screen.dart';
import 'faq_screen.dart';
import 'coin_screen.dart';
import 'edukasi_screen.dart';
import 'notification_screen.dart';
import 'VoucherScreen.dart';
import 'green_habit_screen.dart';
import 'detail_grafik_screen.dart';
import 'plan_screen.dart';
import 'friends_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/voucher_provider.dart';
import 'leaderboard_screen.dart';
import 'achievement_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  TextEditingController _chatController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      drawer: _buildDrawer(),
      appBar: _selectedIndex == 0 ? _buildCustomAppBar(context) : null,
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 54, 135, 227),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return ScanScreen();
      case 2:
        return SettingsScreen();
      default:
        return Container();
    }
  }

  Widget _buildDrawer() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.loggedInUser;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue.shade900,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.namaLengkap ?? user?.username ?? 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.event_note, color: Colors.white),
              title: Text('Plan', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text('FAQ', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.leaderboard, color: Colors.white),
              title: Text('Leaderboard', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book, color: Colors.white),
              title: Text('Edukasi', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EdukasiScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// APPBAR CUSTOM CANTIK
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;
    return PreferredSize(
      preferredSize: Size.fromHeight(68 + statusBar),
      child: Container(
        padding: EdgeInsets.only(top: statusBar, left: 12, right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Menu Drawer
            Builder(
              builder: (menuContext) => _prettyCircleIcon(
                icon: Icons.menu,
                onTap: () => Scaffold.of(menuContext).openDrawer(),
              ),
            ),
            SizedBox(width: 10),
            _prettyCircleIcon(icon: Icons.recycling, bgGradient: LinearGradient(colors: [Colors.lightBlueAccent, Colors.blue.shade900])),
            Expanded(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "MAP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 1.2,
                          shadows: [Shadow(color: Colors.black12, blurRadius: 3)],
                        ),
                      ),
                      TextSpan(
                        text: "HIJAU",
                        style: TextStyle(
                          color: Colors.greenAccent.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 1.2,
                          shadows: [Shadow(color: Colors.black12, blurRadius: 3)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _prettyBadgeIcon(
              icon: Icons.notifications_outlined,
              badgeCount: 3,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
              },
            ),
            SizedBox(width: 8),
            _prettyCircleIcon(
              icon: Icons.eco,
              bgGradient: LinearGradient(colors: [Colors.greenAccent.shade400, Colors.green.shade800]),
              iconColor: Colors.white,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GreenHabitScreen())),
            ),
            SizedBox(width: 8),
            _prettyCircleIcon(
              icon: Icons.person,
              iconColor: Colors.blue.shade900,
              bgGradient: LinearGradient(colors: [Colors.white, Colors.blue.shade100]),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prettyCircleIcon({
    required IconData icon,
    Color iconColor = Colors.white,
    VoidCallback? onTap,
    Gradient? bgGradient,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: bgGradient,
          color: bgGradient == null ? Colors.white.withOpacity(0.13) : null,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  Widget _prettyBadgeIcon({
    required IconData icon,
    required int badgeCount,
    VoidCallback? onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _prettyCircleIcon(icon: icon, onTap: onTap),
        if (badgeCount > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Center(
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHomeContent() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.loggedInUser;

    if (user == null) {
      return Center(
        child: Text(
          "User tidak ditemukan.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildStatsCard(),
          const SizedBox(height: 20),
          _buildFeaturesGrid(),
          const SizedBox(height: 30),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<VoucherProvider>(
                builder: (context, provider, child) {
                  return _buildStatTile(
                    Icons.monetization_on,
                    "Total Coin",
                    "${provider.userCoins}",
                    Colors.yellow,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CoinScreen()),
                      );
                    },
                  );
                },
              ),
              Consumer<VoucherProvider>(
                builder: (context, provider, child) {
                  return _buildStatTile(
                    Icons.card_giftcard,
                    "Voucher",
                    "${provider.userVouchers.length}",
                    Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VoucherScreen()),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailGrafikScreen()),
              );
            },
            child: Image.asset(
              "lib/assets/grafik.jpeg",
              height: 180,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Pembuangan sampah yang telah kamu selesaikan",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildFeatureCard(
          "Tempat Sampah",
          Icons.delete,
          TempatSampahListScreen(),
        ),
        _buildFeatureCard(
          "Komunitas",
          Icons.groups,
          KomunitasScreen(),
        ),
        _buildFeatureCard(
          "Friends",
          Icons.person,
          FriendsScreen(),
        ),
        _buildFeatureCard(
          "Achievement",
          Icons.emoji_events,
          AchievementScreen(),
        ),
      ],
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade700,
            Colors.green.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.park, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _chatController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Ketik sesuatu di sini...",
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _chatController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.send, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(
    IconData icon,
    String title,
    String value,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 35),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.green, Colors.teal]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}