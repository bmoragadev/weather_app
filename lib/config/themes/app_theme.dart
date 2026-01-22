import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getLightTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2), // Azul cielo vibrante
          brightness: Brightness.light,
          primary: const Color(0xFF4A90E2),
          secondary: const Color(0xFF50E3C2), // Turquesa
          tertiary: const Color(0xFFFF9F1C), // Naranja suave
          primaryContainer: const Color(0xFFE3F2FD),
          secondaryContainer: const Color(0xFFE0F7FA),
        ),
        textTheme: GoogleFonts.robotoTextTheme(),
        brightness: Brightness.light,
      );

  ThemeData getDarkTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Azul medianoche
          brightness: Brightness.dark,
          primary: const Color(0xFF7986CB),
          secondary: const Color(0xFF4DB6AC),
          tertiary: const Color(0xFFFFB74D),
          primaryContainer: const Color(0xFF283593),
          secondaryContainer: const Color(0xFF00695C),
          surface: const Color(0xFF121212),
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        brightness: Brightness.dark,
      );
}
