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
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
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
                    user?.name ?? 'Guest',
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
              leading: Icon(Icons.leaderboard, color: Colors.white),
              title: Text(
                'Leaderboard',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderboardScreen(),
                  ),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(Icons.recycling, color: Colors.white, size: 24),
              ),
              SizedBox(width: 8),
              Text(
                "MAP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                "HIJAU",
                style: TextStyle(
                  color: Colors.greenAccent.shade400,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildAppBarIcon(
                icon: Icons.notifications_outlined,
                hasNotification: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                ),
              ),
              SizedBox(width: 12),
              _buildAppBarIcon(
                icon: Icons.eco,
                isSpecial: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GreenHabitScreen()),
                ),
              ),
              SizedBox(width: 12),
              _buildAppBarIcon(
                isProfile: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon({
    IconData? icon,
    bool hasNotification = false,
    bool isSpecial = false,
    bool isProfile = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: isSpecial
              ? LinearGradient(
                  colors: [
                    Colors.greenAccent.shade400.withOpacity(0.3),
                    Colors.greenAccent.shade700.withOpacity(0.3),
                  ],
                )
              : null,
          color: !isSpecial ? Colors.white.withOpacity(0.1) : null,
          shape: BoxShape.circle,
          border: isSpecial
              ? Border.all(
                  color: Colors.greenAccent.shade200.withOpacity(0.5),
                  width: 1.5,
                )
              : null,
        ),
        child: isProfile
            ? Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.shade400,
                      Colors.blueAccent.shade400,
                    ],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue.shade900,
                      size: 18,
                    ),
                  ),
                ),
              )
            : Stack(
                children: [
                  Icon(
                    icon!,
                    color: Colors.white,
                    size: 26,
                  ),
                  if (hasNotification)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade900,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
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
          SizedBox(height: 20),
          _buildStatsCard(),
          SizedBox(height: 20),
          _buildFeaturesGrid(),
          SizedBox(height: 30),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
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
          SizedBox(height: 10),
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
          SizedBox(height: 5),
          Text(
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
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildFeatureCard(
          "Tempat Sampah",
          Icons.delete,
          SampahScreen(),
        ),
        _buildFeatureCard(
          "Komunitas",
          Icons.people,
          KomunitasScreen(),
        ),
        _buildFeatureCard("FAQ", Icons.help, FAQScreen()),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade700,
            Colors.green.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.park, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _chatController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Ketik sesuatu di sini...",
                hintStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _chatController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Icon(Icons.send, color: Colors.green),
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
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
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
          gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
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