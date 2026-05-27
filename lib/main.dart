// lib/main.dart

// Importation du gestionnaire d'état que l'on vient de concevoir
import 'package:campuspulse/presentation/providers/auth_provider.dart';
import 'package:campuspulse/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Importations de tes écrans principaux
import 'presentation/screens/guest_home_screen.dart';
import 'presentation/screens/student_home_screen.dart';

Future<void> main() async {
  // Optionnel mais recommandé : Sécurise les liaisons matérielles de Flutter avant le lancement
  WidgetsFlutterBinding.ensureInitialized();
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
      // Sinon (état initial ou déconnecté), l'étudiant reste sur l'accueil invité.
      home: authState is AuthAuthenticated
          ? const StudentHomeScreen()
          : const GuestHomeScreen(),
    );
  }
}
