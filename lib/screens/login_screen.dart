import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FlutterLogin(
      title: 'MAPHIJAU',
      userType: LoginUserType.email,
      onLogin: (LoginData data) async {
        if (data.name.contains('@') && !data.name.toLowerCase().endsWith('@gmail.com')) {
          return 'Email harus @gmail.com';
        }
        if (data.password.length < 6) {
          return 'Password minimal 6 karakter';
        }
        await authProvider.login(data.name, data.password);
        if (authProvider.isLoggedIn) {
          return null;
        } else {
          return authProvider.errorMessage.isNotEmpty
              ? authProvider.errorMessage
              : 'Login gagal';
        }
      },
      onSignup: (SignupData data) async {
        String username = data.additionalSignupData?['username'] ?? '';
        String email = data.name ?? '';
        String password = data.password ?? '';
        String retypePassword = data.additionalSignupData?['retypePassword'] ?? '';

        if (username.isEmpty) {
          return 'Username harus diisi';
        }
        if (!email.toLowerCase().endsWith('@gmail.com')) {
          return 'Email harus @gmail.com';
        }
        if (password.length < 6 || retypePassword.length < 6) {
          return 'Password minimal 6 karakter';
        }
        if (password != retypePassword) {
          return 'Password dan Ulangi Password harus sama';
        }

        await authProvider.register(
          username: username,
          email: email,
          password: password,
          retypePassword: retypePassword,
          isTermsAccepted: true,
        );
        if (authProvider.isRegistered) {
          await authProvider.login(email, password);
          return null;
        } else {
          return authProvider.errorMessage.isNotEmpty
              ? authProvider.errorMessage
              : 'Registrasi gagal';
        }
      },
      additionalSignupFields: [
        UserFormField(
          keyName: 'username',
          displayName: 'Username',
          userType: LoginUserType.name,
          icon: const Icon(Icons.person),
          fieldValidator: (value) =>
              (value == null || value.isEmpty) ? 'Username harus diisi' : null,
        ),
        UserFormField(
          keyName: 'retypePassword',
          displayName: 'Ulangi Password',
          icon: const Icon(Icons.lock_outline),
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ulangi password';
            }
            if (value.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ),
      ],
      userValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email atau Username harus diisi';
        }
        if (value.contains('@') && !value.toLowerCase().endsWith('@gmail.com')) {
          return 'Email harus @gmail.com';
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password harus diisi';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
      onRecoverPassword: (_) async => 'Fitur lupa password belum tersedia',
      messages: LoginMessages(
        userHint: 'Email / Username',
        passwordHint: 'Password',
        confirmPasswordHint: 'Ulangi Password',
        loginButton: 'MASUK',
        signupButton: 'DAFTAR',
        forgotPasswordButton: 'Lupa Password?',
        recoverPasswordButton: 'Kirim',
        goBackButton: 'Kembali',
        confirmPasswordError: 'Password tidak sama',
        recoverPasswordSuccess: 'Cek email Anda',
      ),
      theme: LoginTheme(
        primaryColor: Colors.blue[900]!,
        accentColor: Colors.green,
        errorColor: Colors.red,
        titleStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSubmitAnimationCompleted: () {
        if (authProvider.isLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      },
    );
  }
}