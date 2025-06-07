import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;
  User? _loggedInUser;
  bool _isRegistered = false;
  
  // Tambahkan state untuk notifikasi
  bool _notificationEnabled = true;

  // Getter
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isRegistered => _isRegistered;
  User? get loggedInUser => _loggedInUser;
  bool get notificationEnabled => _notificationEnabled;

  // Method untuk mengubah status notifikasi
  void setNotificationEnabled(bool value) {
    _notificationEnabled = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan password harus diisi');
      }

      if (!email.contains('@')) {
        throw Exception('Email tidak valid');
      }

      _isLoggedIn = true;
      _loggedInUser = User(
        id: '1',
        name: 'John Doe',
        email: email,
      );
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
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

      if (password != retypePassword) {
        throw Exception('Password tidak sama');
      }

      if (!isTermsAccepted) {
        throw Exception('Anda harus menyetujui syarat dan ketentuan');
      }

      _isRegistered = true;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _loggedInUser = null;
    // Reset pengaturan notifikasi saat logout (opsional)
    _notificationEnabled = true;
    notifyListeners();
  }
}