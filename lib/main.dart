import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
        
        // Palette chromatique de l'UADB
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x000d47a1), // Base Bleu Royal
          primary: const Color(0xFF0D47A1),    // Bleu Royal UADB
          secondary: const Color(0xFFFFC107),  // Or / Jaune Subtil
          surface: const Color(0xFFFFFFFF),    // Blanc Pur pour les cartes
          error: const Color(0xFFD32F2F),      // Rouge Éclatant pour les alertes
        ),
        
        // Couleur de fond globale douce pour éviter la fatigue visuelle
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        
        // Style par défaut des barres d'outils (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      
      // Écran temporaire en attendant la configuration des routes avec GoRouter
      home: const TempHomeScreen(),
    );
  }
}

// Widget temporaire pour tester que l'application se lance correctement
class TempHomeScreen extends StatelessWidget {
  const TempHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusPulse'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Bienvenue sur CampusPulse UADB',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              key: Key('subtitle'),
              child: Text(
                'L\'arborescence Clean Architecture et le thème graphique sont configurés avec succès !',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}