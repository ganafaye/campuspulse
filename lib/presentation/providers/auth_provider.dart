// lib/presentation/providers/auth_provider.dart

import 'package:campuspulse/data/models/mock_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../service/firebase_service.dart';
// Importation de la liste mockUsers qu'on vient de créer

// Les états possibles de l'authentification
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading
    extends AuthState {} // Ajouté pour l'effet visuel de chargement

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  // Ajouté pour intercepter les mauvais codes étudiants
  final String message;
  AuthError(this.message);
}

// Le gestionnaire d'état (Notifier)
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthInitial()) {
    // Au démarrage, l'étudiant commence en mode non connecté (Accueil Invité)
    state = AuthUnauthenticated();
  }

  // Simulation de connexion avec les 4 utilisateurs de test
  Future<void> login(String codeEtudiant, String password) async {
    print("Tentative de login pour : $codeEtudiant");

    if (codeEtudiant.isEmpty || password.isEmpty) {
      state = AuthError("Veuillez remplir tous les champs.");
      return;
    }

    state = AuthLoading();

    // On simule un léger temps d'attente d'une seconde pour faire réaliste
    await Future.delayed(const Duration(seconds: 1));

    // Nettoyage du code saisi (pas d'espaces inutiles et tout en MAJUSCULES)
    final cleanedCode = codeEtudiant.trim().toUpperCase();

    try {
      // Premièrement, tente la recherche côté Firebase
      final firebaseService = FirebaseService();
      final userMap = await firebaseService.loginStudent(cleanedCode);

      if (userMap != null) {
        final user = UserModel.fromMap(userMap, id: userMap['uid']);
        state = AuthAuthenticated(user);
        print(
            "DEBUG - Connexion Firebase réussie pour : ${user.name} (${user.ufr})");
        return;
      }

      // Fallback: recherche dans les mockUsers si Firebase n'a rien retourné
      final userFound = mockUsers.firstWhere(
        (user) => user.codeEtudiant == cleanedCode,
      );
      state = AuthAuthenticated(userFound);
      print(
          "DEBUG - Connexion locale réussie pour : ${userFound.name} (${userFound.ufr})");
    } catch (e) {
      state = AuthError(
          "Code inconnu. Vérifie ton code étudiant ou la connexion Firebase.");
    }
  }

  // Déconnexion
  void logout() {
    state = AuthUnauthenticated();
  }
}

// Le Provider global à écouter
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
