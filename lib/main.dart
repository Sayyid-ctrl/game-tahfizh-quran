import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'core/constants/app_themes.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TahfizhGameApp());
}

class TahfizhGameApp extends StatelessWidget {
  const TahfizhGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: "Game Edukasi Tahfizh Al-Qur'an",
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
