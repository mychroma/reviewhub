import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';

class ReviewHubApp extends StatefulWidget {
  const ReviewHubApp({super.key});

  @override
  State<ReviewHubApp> createState() => _ReviewHubAppState();
}

class _ReviewHubAppState extends State<ReviewHubApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    await Supabase.initialize(url: url, anonKey: key);
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5E81F4)),
      useMaterial3: true,
    );

    if (!_initialized) {
      return MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'ReviewHub',
      theme: theme,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E81F4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
