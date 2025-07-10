import 'package:flutter/material.dart';
import '../model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;
  bool _isRegistered = false;
  UserModel? _loggedInUser;
  bool _notificationEnabled = true;

  // Untuk data profile tambahan (fallback jika userModel null)
  String _namaLengkap = '';
  String _alamat = '';
  String _jenisKelamin = 'Laki-laki';
  int _level = 1;
  int _poin = 0;

  int _points = 150;
  int _activityPoints = 100;
  int _achievementPoints = 50;
  int _bonusPoints = 0;
  int _completedAchievements = 2;


  List<Map<String, dynamic>> _achievements = [
    {
      'id': '1',
      'title': 'Pemula Hijau',
      'description': 'Selesaikan 5 aktivitas ramah lingkungan',
      'progress': 1.0,
      'icon': Icons.eco,
      'iconColor': Colors.green,
      'completed': false,
      'isClaimable': true,
      'reward': 'Lencana Pemula',
      'rewardPoints': 20,
    },
    {
      'id': '2',
      'title': 'Komunitas Aktif',
      'description': 'Ikuti 3 acara komunitas',
      'progress': 1.0,
      'icon': Icons.people,
      'iconColor': Colors.purple,
      'completed': false,
      'isClaimable': true,
      'reward': 'Lencana Komunitas',
      'rewardPoints': 30,
    },
    {
      'id': '3',
      'title': 'Donasi Pertama',
      'description': 'Lakukan donasi pertama Anda',
      'progress': 1.0,
      'icon': Icons.volunteer_activism,
      'iconColor': Colors.red,
      'completed': false,
      'isClaimable': true, // <--- AGAR BISA DIKLAIM!
      'reward': 'Lencana Donatur',
      'rewardPoints': 40,
    },
    {
      'id': '4',
      'title': 'Pengumpul Poin',
      'description': 'Kumpulkan 200 poin',
      'progress': 0.75,
      'icon': Icons.star,
      'iconColor': Colors.amber,
      'completed': false,
      'isClaimable': false,
      'reward': 'Lencana Pengumpul',
      'rewardPoints': 50,
    },
  ];

  final List<UserModel> _registeredUsers = [];

  // Getter
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isRegistered => _isRegistered;
  UserModel? get loggedInUser => _loggedInUser;
  bool get notificationEnabled => _notificationEnabled;

  String get namaLengkap => _loggedInUser?.namaLengkap ?? _namaLengkap;
  String get alamat => _loggedInUser?.alamat ?? _alamat;
  String get jenisKelamin => _loggedInUser?.jenisKelamin ?? _jenisKelamin;
  int get level => _loggedInUser?.level ?? _level;
  int get poin => _loggedInUser?.poin ?? _poin;

  int get points => _points;
  int get activityPoints => _activityPoints;
  int get achievementPoints => _achievementPoints;
  int get bonusPoints => _bonusPoints;
  int get completedAchievements => _completedAchievements;
  List<Map<String, dynamic>> get achievements => _achievements;

  void setNotificationEnabled(bool value) {
    _notificationEnabled = value;
    notifyListeners();
  }

  Future<void> login(String usernameOrEmail, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      if (usernameOrEmail.isEmpty || password.isEmpty) {
        throw Exception('Email/Username dan password harus diisi');
      }

      final UserModel user = _registeredUsers.firstWhere(
        (u) =>
            (u.username == usernameOrEmail || u.email == usernameOrEmail) &&
            u.password == password,
        orElse: () => throw Exception('Email/Username atau password salah'),
      );

      _isLoggedIn = true;
      _loggedInUser = user;
      // Set data profile agar sinkron
      _namaLengkap = user.namaLengkap ?? user.username;
      _alamat = user.alamat ?? '';
      _jenisKelamin = user.jenisKelamin ?? 'Laki-laki';
      _level = user.level;
      _poin = user.poin;

      _errorMessage = '';
      await fetchUserAchievements();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String retypePassword,
    required bool isTermsAccepted,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Semua field harus diisi');
      }
      if (!email.contains('@')) {
        throw Exception('Email tidak valid');
      }
      if (password.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }
      if (password != retypePassword) {
        throw Exception('Password tidak sama');
      }
      if (!isTermsAccepted) {
        throw Exception('Anda harus menyetujui syarat dan ketentuan');
      }
      final exists = _registeredUsers.any(
        (u) => u.username == username || u.email == email,
      );
      if (exists) {
        throw Exception('User sudah terdaftar');
      }

      final newUser = UserModel(
        username: username,
        email: email,
        password: password,
        namaLengkap: username,
        alamat: '',
        jenisKelamin: 'Laki-laki',
        level: 1,
        poin: 0,
      );
      _registeredUsers.add(newUser);

      _isRegistered = true;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isRegistered = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile({
    String? username,
    String? namaLengkap,
    String? alamat,
    String? jenisKelamin,
    String? password,
    int? level,
    int? poin,
  }) {
    if (_loggedInUser != null) {
      _loggedInUser = _loggedInUser!.copyWith(
        username: (username != null && username.isNotEmpty) ? username : _loggedInUser!.username,
        namaLengkap: (namaLengkap != null && namaLengkap.isNotEmpty) ? namaLengkap : _loggedInUser!.namaLengkap,
        alamat: (alamat != null) ? alamat : _loggedInUser!.alamat,
        jenisKelamin: (jenisKelamin != null) ? jenisKelamin : _loggedInUser!.jenisKelamin,
        password: (password != null && password.isNotEmpty) ? password : _loggedInUser!.password,
        level: level ?? _loggedInUser!.level,
        poin: poin ?? _loggedInUser!.poin,
      );
      _namaLengkap = namaLengkap ?? _namaLengkap;
      _alamat = alamat ?? _alamat;
      _jenisKelamin = jenisKelamin ?? _jenisKelamin;
      _level = level ?? _level;
      _poin = poin ?? _poin;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _loggedInUser = null;
    _notificationEnabled = true;
    _namaLengkap = '';
    _alamat = '';
    _jenisKelamin = 'Laki-laki';
    _level = 1;
    _poin = 0;
    notifyListeners();
  }

  // ------------ Achievement Section -------------
  Future<void> fetchUserAchievements() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      _updatePoints();
    } catch (e) {
      _errorMessage = 'Gagal memuat pencapaian';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void claimAchievement(String achievementId) {
    final idx = _achievements.indexWhere((a) => a['id'] == achievementId);
    if (idx != -1 && _achievements[idx]['isClaimable']) {
      _achievements[idx]['isClaimable'] = false;
      final rewardPoints = _achievements[idx]['rewardPoints'] ?? 0;
      _achievementPoints += rewardPoints as int;
      _points += rewardPoints as int;
      _completedAchievements++;
      _updatePoints();
      notifyListeners();
    }
  }

  void _updatePoints() {
    _points = _activityPoints + _achievementPoints + _bonusPoints;
    final idx =
        _achievements.indexWhere((a) => a['title'] == 'Pengumpul Poin');
    if (idx != -1) {
      _achievements[idx]['progress'] = (_points / 200).clamp(0.0, 1.0);
      if (_points >= 200 && !_achievements[idx]['completed']) {
        _achievements[idx]['completed'] = true;
        _achievements[idx]['isClaimable'] = true;
        _completedAchievements++;
      }
    }
    notifyListeners();
  }

  void addActivityPoints(int points) {
    _activityPoints += points;
    _updatePoints();
    _checkActivityAchievements();
  }

  void _checkActivityAchievements() {
    final idx =
        _achievements.indexWhere((a) => a['title'] == 'Pemula Hijau');
    if (idx != -1 && !_achievements[idx]['completed']) {
      final newProgress = (_activityPoints / 100).clamp(0.0, 1.0);
      _achievements[idx]['progress'] = newProgress;
      if (newProgress >= 1.0) {
        _achievements[idx]['completed'] = true;
        _achievements[idx]['isClaimable'] = true;
      }
    }
  }
}