import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  int _currentCarouselIndex = 0;
  late PageController _pageController;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  // Random data generators
  final List<String> _names = [
    'Alex Rodriguez',
    'Lisa Wang',
    'David Brown',
    'Jessica Miller',
    'Tom Wilson',
    'Maria Garcia',
    'James Lee',
    'Sophie Chen',
    'Ryan Taylor',
    'Emma Johnson',
    'Michael Kim',
    'Ana Santos',
    'Kevin Zhang',
    'Nina Patel',
    'Lucas Silva',
    'Zoe Thompson',
    'Oscar Martinez',
    'Lily Cooper',
    'Nathan Wong',
    'Grace Park',
    'Diego Morales',
    'Chloe Adams',
    'Felix Nguyen',
    'Mia Robinson',
    'Jake Hill',
    'Aria Sharma',
    'Ethan Cruz',
    'Ruby Foster',
    'Leo Tanaka',
    'Ivy Collins',
  ];

  final List<String> _hobbies = [
    'Photography',
    'Reading',
    'Gaming',
    'Cooking',
    'Hiking',
    'Music',
    'Drawing',
    'Traveling',
    'Yoga',
    'Swimming',
    'Dancing',
    'Gardening',
    'Coding',
    'Cycling',
    'Running',
    'Writing',
    'Painting',
    'Surfing',
  ];

  final List<String> _locations = [
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Tangerang',
    'Depok',
    'Bekasi',
    'Bogor',
    'Batam',
  ];

  final List<String> _bios = [
    'Love exploring new places and meeting new people! 🌍',
    'Passionate about sustainable living and green technology 🌱',
    'Coffee enthusiast and bookworm 📚☕',
    'Adventure seeker and nature lover 🏔',
    'Tech geek by day, artist by night 🎨💻',
    'Fitness enthusiast and healthy lifestyle advocate 💪',
    'Music lover and concert goer 🎵',
    'Foodie exploring local cuisines 🍜',
    'Photographer capturing life\'s beautiful moments 📸',
    'Dreamer, believer, achiever ✨',
  ];

  final Random _random = Random();

  // Dummy data for friends
  List<Friend> friends = [
    Friend(
      id: '1',
      name: 'Sarah Johnson',
      avatar: 'https://i.pravatar.cc/150?img=1',
      status: 'Online',
      mutualFriends: 5,
      greenPoints: 1250,
      isFriend: true,
      hobbies: ['Photography', 'Reading', 'Yoga'],
      location: 'Jakarta',
      bio: 'Love exploring new places and meeting new people! 🌍',
      joinDate: DateTime(2023, 3, 15),
    ),
    Friend(
      id: '2',
      name: 'Mike Chen',
      avatar: 'https://i.pravatar.cc/150?img=2',
      status: 'Offline',
      mutualFriends: 3,
      greenPoints: 890,
      isFriend: true,
      hobbies: ['Gaming', 'Coding', 'Music'],
      location: 'Bandung',
      bio: 'Tech geek by day, gamer by night 🎮💻',
      joinDate: DateTime(2023, 5, 22),
    ),
    Friend(
      id: '3',
      name: 'Emily Davis',
      avatar: 'https://i.pravatar.cc/150?img=3',
      status: 'Online',
      mutualFriends: 8,
      greenPoints: 1580,
      isFriend: true,
      hobbies: ['Hiking', 'Cooking', 'Dancing'],
      location: 'Surabaya',
      bio: 'Adventure seeker and nature lover 🏔',
      joinDate: DateTime(2023, 1, 10),
    ),
  ];

  // Dummy data for nearby users
  List<Friend> nearbyUsers = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _pageController = PageController(viewportFraction: 0.8);
    _generateInitialNearbyUsers();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _generateInitialNearbyUsers() {
    nearbyUsers = List.generate(5, (index) => _generateRandomUser());
  }

  Friend _generateRandomUser() {
    final usedIds = [
      ...friends.map((f) => f.id),
      ...nearbyUsers.map((u) => u.id),
    ];
    String newId;
    do {
      newId = _random.nextInt(10000).toString();
    } while (usedIds.contains(newId));

    final nameIndex = _random.nextInt(_names.length);
    final name = _names[nameIndex];
    final avatarIndex = _random.nextInt(70) + 1;
    final isOnline = _random.nextBool();
    final distance = ((_random.nextDouble() * 4.5) + 0.1).toStringAsFixed(1);
    final greenPoints = _random.nextInt(1500) + 200;
    final mutualFriends = _random.nextInt(8);

    final hobbiesCount = _random.nextInt(4) + 2;
    final selectedHobbies = <String>[];
    while (selectedHobbies.length < hobbiesCount) {
      final hobby = _hobbies[_random.nextInt(_hobbies.length)];
      if (!selectedHobbies.contains(hobby)) {
        selectedHobbies.add(hobby);
      }
    }

    return Friend(
      id: newId,
      name: name,
      avatar: 'https://i.pravatar.cc/150?img=$avatarIndex',
      status: isOnline ? 'Online' : 'Offline',
      mutualFriends: mutualFriends,
      greenPoints: greenPoints,
      isFriend: false,
      distance: '$distance km',
      hobbies: selectedHobbies,
      location: _locations[_random.nextInt(_locations.length)],
      bio: _bios[_random.nextInt(_bios.length)],
      joinDate: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
    );
  }

  Future<void> _refreshNearbyUsers() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      final newUsersCount = _random.nextInt(3) + 2;
      final usersToRemove = _random.nextInt(3) + 1;

      if (nearbyUsers.length > usersToRemove) {
        for (int i = 0; i < usersToRemove; i++) {
          if (nearbyUsers.isNotEmpty) {
            nearbyUsers.removeAt(_random.nextInt(nearbyUsers.length));
          }
        }
      }

      for (int i = 0; i < newUsersCount; i++) {
        nearbyUsers.add(_generateRandomUser());
      }

      _currentCarouselIndex = 0;
    });

    _refreshController.refreshCompleted();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daftar pengguna sekitar telah diperbarui!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _addFriend(Friend user) {
    setState(() {
      user.isFriend = true;
      friends.add(user);
      nearbyUsers.remove(user);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.name} telah ditambahkan sebagai teman!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeFriend(Friend friend) {
    setState(() {
      friend.isFriend = false;
      friends.remove(friend);
      if (friend.distance != null) {
        nearbyUsers.add(friend);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${friend.name} telah dihapus dari daftar teman'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewProfile(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(friend: friend)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Friends',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SmartRefresher(
            controller: _refreshController,
            onRefresh: _refreshNearbyUsers,
            physics: const BouncingScrollPhysics(), // Tambahkan ini
            header: WaterDropMaterialHeader(
              backgroundColor: Colors.green,
              color: Colors.white,
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 100,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (friends.isNotEmpty) ...[
                        _buildSectionHeader('Teman Saya', friends.length),
                        const SizedBox(height: 12),
                        _buildFriendsList(),
                        const SizedBox(height: 20),
                      ],
                      _buildSectionHeader(
                        'Pengguna Sekitar',
                        nearbyUsers.length,
                      ),
                      const SizedBox(height: 12),
                      _refreshController.isRefresh
                          ? _buildShimmerLoading()
                          : nearbyUsers.isEmpty
                          ? const SizedBox.shrink()
                          : _buildNearbyUsersCarousel(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          _buildExpandableFAB(),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 16),
            Container(width: 200, height: 20, color: Colors.white),
            SizedBox(height: 8),
            Container(width: 150, height: 15, color: Colors.white),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade400],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    if (friends.isEmpty) {
      return _buildEmptyFriendsState();
    }

    return Column(
      children: friends.map((friend) => _buildFriendCard(friend)).toList(),
    );
  }

  Widget _buildEmptyFriendsState() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'Belum Ada Teman',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Mulai tambahkan teman dari pengguna sekitar di bawah ini!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(Friend friend) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _viewProfile(friend),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (friend.status == 'Online')
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12),
          // Friend info - made this flexible and wrapped text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 6),
                // Changed this to a column for smaller screens
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, color: Colors.green.shade300, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${friend.greenPoints} poin',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.blue.shade300,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${friend.mutualFriends} teman',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu button
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'remove') {
                _removeFriend(friend);
              } else if (value == 'profile') {
                _viewProfile(friend);
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue.shade700),
                        SizedBox(width: 8),
                        Text('Lihat Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus Teman'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyUsersCarousel() {
    if (nearbyUsers.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_searching,
              size: 60,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Tidak Ada Pengguna Sekitar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coba lagi nanti atau pindah ke lokasi yang berbeda',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemCount: nearbyUsers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: _buildNearbyUserCard(nearbyUsers[index]),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        _buildCarouselIndicator(),
      ],
    );
  }

  Widget _buildNearbyUserCard(Friend user) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 280, // Batasi tinggi maksimal
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.teal.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        // Tambahkan scroll untuk konten panjang
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Gunakan mainAxisSize.min
            children: [
              GestureDetector(
                onTap: () => _viewProfile(user),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (user.status == 'Online')
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _viewProfile(user),
                child: Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              if (user.distance != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    user.distance!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '${user.greenPoints}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.people, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '${user.mutualFriends}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Wrap(
                // Ganti Row dengan Wrap untuk menghindari overflow
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _viewProfile(user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 16),
                        SizedBox(width: 4),
                        Text('Profil'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _addFriend(user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade700,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, size: 16),
                        SizedBox(width: 4),
                        Text('Tambah'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          nearbyUsers.asMap().entries.map((entry) {
            return Container(
              width: _currentCarouselIndex == entry.key ? 12 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color:
                    _currentCarouselIndex == entry.key
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildExpandableFAB() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _expandAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isExpanded) ...[
                      _buildMiniActionButton(
                        icon: Icons.refresh,
                        label: 'Refresh',
                        color: Colors.blue,
                        onTap: () {
                          _refreshController.requestRefresh();
                          _toggleExpanded();
                        },
                      ),
                      SizedBox(height: 12),
                      _buildMiniActionButton(
                        icon: Icons.location_on,
                        label: 'Lokasi',
                        color: Colors.orange,
                        onTap: _toggleExpanded,
                      ),
                      SizedBox(height: 12),
                      _buildMiniActionButton(
                        icon: Icons.qr_code,
                        label: 'QR Code',
                        color: Colors.purple,
                        onTap: () {
                          _showQRCodeDialog();
                          _toggleExpanded();
                        },
                      ),
                      SizedBox(height: 12),
                    ],
                  ],
                ),
              );
            },
          ),
          FloatingActionButton(
            onPressed: _toggleExpanded,
            backgroundColor: Colors.green.shade600,
            child: AnimatedRotation(
              turns: _isExpanded ? 0.125 : 0,
              duration: Duration(milliseconds: 300),
              child: Icon(
                _isExpanded ? Icons.close : Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRCodeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'QR Code Saya',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 100,
                        color: Colors.grey.shade600,
                      ),
                      Text(
                        'QR Code',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Minta teman untuk scan QR code ini untuk menambahkan Anda sebagai teman',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Friend friend;

  const ProfileScreen({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.blue.shade900,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade600],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (friend.status == 'Online')
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      friend.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            friend.status == 'Online'
                                ? Colors.green.withOpacity(0.8)
                                : Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        friend.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.eco,
                          title: 'Green Points',
                          value: friend.greenPoints.toString(),
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.people,
                          title: 'Teman Bersama',
                          value: friend.mutualFriends.toString(),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  if (friend.distance != null) ...[
                    SizedBox(height: 12),
                    _buildStatCard(
                      icon: Icons.location_on,
                      title: 'Jarak',
                      value: friend.distance!,
                      color: Colors.orange,
                      fullWidth: true,
                    ),
                  ],

                  SizedBox(height: 24),

                  _buildSectionCard(
                    title: 'Tentang',
                    icon: Icons.info_outline,
                    child: Text(
                      friend.bio,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildSectionCard(
                    title: 'Lokasi',
                    icon: Icons.location_city,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          friend.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildSectionCard(
                    title: 'Hobi & Minat',
                    icon: Icons.favorite_outline,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          friend.hobbies.map((hobby) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Text(
                                hobby,
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildSectionCard(
                    title: 'Bergabung Sejak',
                    icon: Icons.calendar_today,
                    child: Text(
                      _formatJoinDate(friend.joinDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  if (!friend.isFriend) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add),
                            SizedBox(width: 8),
                            Text(
                              'Tambah Sebagai Teman',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.message),
                                SizedBox(width: 8),
                                Text('Pesan'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              side: BorderSide(color: Colors.red.shade600),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_remove),
                                SizedBox(width: 8),
                                Text('Hapus'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade600, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  String _formatJoinDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class Friend {
  final String id;
  final String name;
  final String avatar;
  final String status;
  final int mutualFriends;
  final int greenPoints;
  bool isFriend;
  final String? distance;
  final List<String> hobbies;
  final String location;
  final String bio;
  final DateTime joinDate;

  Friend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.mutualFriends,
    required this.greenPoints,
    required this.isFriend,
    this.distance,
    required this.hobbies,
    required this.location,
    required this.bio,
    required this.joinDate,
  });
}