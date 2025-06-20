import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> leaderboardData = [
    {
      "name": "Ali",
      "points": 1200,
      "avatar": "👑",
      "level": "Eco Master",
      "badges": 5,
    },
    {
      "name": "Budi",
      "points": 1000,
      "avatar": "🌿",
      "level": "Green Warrior",
      "badges": 4,
    },
    {
      "name": "Citra",
      "points": 800,
      "avatar": "🌱",
      "level": "Nature Lover",
      "badges": 3,
    },
    {
      "name": "Dina",
      "points": 600,
      "avatar": "🍃",
      "level": "Eco Beginner",
      "badges": 2,
    },
    {
      "name": "Eka",
      "points": 400,
      "avatar": "🪴",
      "level": "Seed Planter",
      "badges": 1,
    },
    {
      "name": "Fajar",
      "points": 300,
      "avatar": "🌲",
      "level": "Newcomer",
      "badges": 0,
    },
    {
      "name": "Gita",
      "points": 200,
      "avatar": "🌍",
      "level": "Newcomer",
      "badges": 0,
    },
  ];

  final int maxPoints = 1500;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 97, 14),
      body: SafeArea(
        child: _isLoading
            ? _buildShimmerLoading()
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 180.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.green[800],
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text(
                        "Pahlawan Lingkungan",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildTopBanner()),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final user = leaderboardData[index];
                      final progress = user['points'] / maxPoints;
                      final rank = index + 1;
                      return _buildLeaderboardCard(user, progress, rank);
                    }, childCount: leaderboardData.length),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.green[300]!,
      highlightColor: Colors.green[100]!,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.grey[400]),
              title: Container(height: 16, color: Colors.grey[400]),
              subtitle: Container(height: 12, color: Colors.grey[400]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBanner() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem("Total Poin", "4,000", Icons.eco),
            Container(
              height: 50,
              width: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            _buildStatItem("Top Level", "Eco Master", Icons.stars),
            Container(
              height: 50,
              width: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            _buildStatItem("Pengguna", "7", Icons.people),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard(
    Map<String, dynamic> user,
    double progress,
    int rank,
  ) {
    final isTopThree = rank <= 3;
    final colors = _getRankColors(rank);

    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      elevation: isTopThree ? 6 : 3,
      color: colors['card'],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: _buildRankIndicator(rank, colors),
        title: Row(
          children: [
            _buildUserAvatar(user['avatar'], rank),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user['name'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors['text'],
                          ),
                        ),
                      ),
                      if (isTopThree) SizedBox(width: 8),
                      if (isTopThree)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors['badge'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _getRankTitle(rank),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    user['level'],
                    style: TextStyle(
                      color: colors['text']!.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            _buildProgressBar(progress, colors),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${user['points']} Poin",
                  style: TextStyle(
                    fontSize: 12,
                    color: colors['text']!.withOpacity(0.8),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      size: 14,
                      color: colors['icon'],
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${user['badges']}",
                      style: TextStyle(
                        fontSize: 12,
                        color: colors['text'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors['text'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getRankColors(int rank) {
    switch (rank) {
      case 1:
        return {
          'card': Color(0xFFFFF176),
          'text': Colors.black,
          'badge': Color(0xFFF57F17),
          'icon': Color(0xFFF57F17),
          'progress': Color(0xFFF9A825),
        };
      case 2:
        return {
          'card': Color(0xFFE0E0E0),
          'text': Colors.black,
          'badge': Color(0xFF616161),
          'icon': Color(0xFF616161),
          'progress': Color(0xFF9E9E9E),
        };
      case 3:
        return {
          'card': Color(0xFFBCAAA4),
          'text': Colors.black,
          'badge': Color(0xFF5D4037),
          'icon': Color(0xFF5D4037),
          'progress': Color(0xFF8D6E63),
        };
      default:
        return {
          'card': Color(0xFF1E3A5F),
          'text': Colors.white,
          'badge': Color(0xFF4CAF50),
          'icon': Color(0xFF4CAF50),
          'progress': Color(0xFF2E7D32),
        };
    }
  }

  String _getRankTitle(int rank) {
    switch (rank) {
      case 1:
        return 'JUARA 1';
      case 2:
        return 'JUARA 2';
      case 3:
        return 'JUARA 3';
      default:
        return 'RANK $rank';
    }
  }

  Widget _buildRankIndicator(int rank, Map<String, Color> colors) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: colors['badge'],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "$rank",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String emoji, int rank) {
    final size = rank == 1
        ? 50.0
        : rank <= 3
            ? 45.0
            : 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: rank == 1
              ? Colors.amber[300]!
              : rank == 2
                  ? Colors.grey[300]!
                  : rank == 3
                      ? Colors.brown[300]!
                      : Colors.green[300]!,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: rank == 1
                ? 28
                : rank <= 3
                    ? 24
                    : 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, Map<String, Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colors['progress']!.withOpacity(0.2),
              color: colors['progress'],
              minHeight: 10,
            ),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}