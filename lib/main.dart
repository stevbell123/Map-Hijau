import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/komunitas_screen.dart';
import 'screens/barcode_screen.dart';
import 'screens/green_habit_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/coin_screen.dart';  

// Providers
import 'providers/auth_provider.dart';
import 'providers/komunitas_provider.dart';
import 'providers/habit_provider.dart';
import 'providers/voucher_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KomunitasProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          elevation: 0,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/komunitas': (context) => KomunitasScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/barcode': (context) => const BarcodeScreen(),
        '/habit': (context) => const GreenHabitScreen(),
        '/coin': (context) => const CoinScreen(),   
      },
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            body: Center(
              child: Text('Terjadi kesalahan! Silakan coba lagi.'),
            ),
          );
        };
        return widget!;
      },
    );
  }
}