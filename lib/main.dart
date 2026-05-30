// lib/main.dart

// Importations indispensables pour Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart'; // Généré avec succès à l'étape précédente

// Importation du gestionnaire d'état que l'on vient de concevoir
import 'package:campuspulse/presentation/providers/auth_provider.dart';
import 'package:campuspulse/service/local_storage_service.dart';
import 'package:campuspulse/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Importations de tes écrans principaux
import 'presentation/screens/guest_home_screen.dart';
import 'presentation/screens/student_home_screen.dart';

Future<void> main() async {
  // 1. Sécurise les liaisons matérielles de Flutter (Indispensable avant d'initialiser Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialise le stockage local rapide et persistant sur le téléphone
  await LocalStorageService.init();

  try {
    // 3. Initialisation officielle de Firebase avec les options générées
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
    print("🚀 DEBUG - Firebase initialisé avec succès !");
  } catch (e) {
    print("⚠️ DEBUG - Erreur lors de l'initialisation de Firebase : $e");
  }

  // 4. Initialisation du service de notifications local
  await NotificationService.init();

  runApp(
    const ProviderScope(
      child: CampusPulseApp(),
    ),
  );
}

// On transforme StatelessWidget en ConsumerWidget pour écouter Riverpod
class CampusPulseApp extends ConsumerWidget {
  const CampusPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialiser le contexte pour les notifications (appelé une seule fois)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.setAppContext(context);
    });

    // ref.watch écoute en temps réel les changements sur authProvider
    final authState = ref.watch(authProvider);
    print("DEBUG - État actuel dans main.dart : ${authState.runtimeType}");

    return MaterialApp(
      title: 'CampusPulse UADB',
      debugShowCheckedModeBanner: false,

      // Configuration du Thème Global conservée à l'identique de ton Figma
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00113A),
          primary: const Color(0xFF00113A),
          secondary: const Color(0xFF115CB9),
          surface: Colors.white,
          error: const Color(0xFFBA1A1A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF002366),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),

      // ROUTAGE INTERNE DYNAMIQUE :
      // Si l'état de Riverpod est "AuthAuthenticated", on bascule directement sur l'application connectée.
      // Si l'état est en cours de restauration, on affiche un écran de chargement.
      home: authState is AuthLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : authState is AuthAuthenticated
              ? const StudentHomeScreen()
              : const GuestHomeScreen(),
    );
  }
}
