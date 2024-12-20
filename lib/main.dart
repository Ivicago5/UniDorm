import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unidorm/auth/auth_gate.dart';
import 'package:unidorm/pages/login_page.dart';
import 'package:unidorm/pages/profile_page.dart';
import 'package:unidorm/pages/oglasi_page.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://vahhilqwtipmruxynjwz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhaGhpbHF3dGlwbXJ1eHluand6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI5Nzc1MTgsImV4cCI6MjA0ODU1MzUxOH0.lG-0yCKcuod2wJx8qIsTPGDXqdcNNNp2oEveOH5hBbA',
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const ProfilePage(),
        '/oglasi': (context)=> const Oglasi(),
      },
      debugShowCheckedModeBanner: false,
      title: 'UniDorm',
      theme: ThemeData(
        textTheme: GoogleFonts.gabaritoTextTheme(textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

