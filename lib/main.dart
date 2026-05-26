// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// Importation de ton écran d'accueil invité
import 'presentation/screens/guest_home_screen.dart';

void main() {
  // L'application est enveloppée dans un ProviderScope pour activer Riverpod
  runApp(
    const ProviderScope(
      child: CampusPulseApp(),
    ),
  );
}

class CampusPulseApp extends StatelessWidget {
  const CampusPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusPulse UADB',
      debugShowCheckedModeBanner: false,

      // Configuration du Thème Global basée sur la charte graphique officielle
      theme: ThemeData(
        useMaterial3: true,

        // Configuration de la police par défaut (Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),

        // Palette chromatique de l'UADB extraite de Figma
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00113A), // Base Bleu Sombre
          primary: const Color(0xFF00113A), // Bleu Sombre Principal
          secondary: const Color(0xFF115CB9), // Bleu Éclatant
          surface: const Color(0xFFFFFFFF), // Blanc Pur pour les cartes
          error: const Color(0xFFBA1A1A), // Rouge Éclatant pour les alertes
        ),

        // Couleur de fond globale douce (Figma background)
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),

        // Style par défaut des barres d'outils (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF002366), // primaryContainer de ton design
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false, // Aligné à gauche comme sur le modèle Figma HTML
        ),
      ),

      // On remplace TempHomeScreen() par ton véritable Écran 1
      home: const GuestHomeScreen(),
    );
  }
}