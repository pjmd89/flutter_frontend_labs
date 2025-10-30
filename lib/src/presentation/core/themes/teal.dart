import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TealTheme {
  ThemeData theme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.roboto().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: brightness,
      ),
      brightness: brightness,
    );
  }

  // Getters convenientes
  ThemeData get lightTheme => theme(Brightness.light);
  ThemeData get darkTheme => theme(Brightness.dark);

  // Mantener compatibilidad con código existente
  ThemeData get materialTheme => darkTheme;
}
