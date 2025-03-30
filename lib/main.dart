import 'package:cryptoglide/providers/PortfolioProvider.dart';
import 'package:cryptoglide/providers/crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Widgets/bottom_nav_bar.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: const CryptoApp(),
    );
  }
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoGlide',
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const BottomNavBar(),
    );
  }
}
