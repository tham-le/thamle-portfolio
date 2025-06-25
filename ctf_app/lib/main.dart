import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tham Le - CTF Showcase',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF3A0F3),
        scaffoldBackgroundColor: const Color(0xFF2E2E3A),
        textTheme: GoogleFonts.vt323TextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFFE0E0E0),
          displayColor: const Color(0xFFF3A0F3),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E2E3A),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'VT323',
            fontSize: 24,
            color: Color(0xFFF3A0F3),
          ),
        ),
        cardTheme: const CardTheme(
          color: Color(0x5A5A6A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFF5A5A6A), width: 2),
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CTF Showcase'),
      ),
      body: const Center(
        child: Text(
          'This is a showcase Flutter app with the new theme.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}