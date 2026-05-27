// lib/presentation/screens/profile_screen.dart

import 'package:campuspulse/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🌟 AJOUT : Import de Riverpod
// 🌟 AJOUT : Ajuste le chemin selon ton projet
import 'guest_home_screen.dart';

// 🌟 MODIFICATION : Passage de StatelessWidget à ConsumerWidget pour utiliser "ref"
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Constantes de couleur extraites de ta maquette HTML
  static const Color primaryColor = Color(0xFF00113A);
  static const Color primaryContainer = Color(0xFF002366);
  static const Color secondaryContainer = Color(0xFF659DFE);
  static const Color onSecondaryContainer = Color(0xFF003370);
  static const Color onSurfaceVariant = Color(0xFF444650);
  static const Color backgroundColor = Color(0xFFF8F9FB);
  static const Color outlineVariant = Color(0xFFC5C6D2);
  static const Color errorColor = Color(0xFFBA1A1A);

  @override
  // 🌟 MODIFICATION : Ajout du paramètre "WidgetRef ref" ici
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            SizedBox(width: 4),
            Text(
              'CampusPulse',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              // --- SECTION EN-TÊTE PROFIL ---
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBxz5J0U7us5yarCDvPq6Bhkv2quNKx642j_nEBYvI196f2GHKK7JWuTr0THy2qUa9EmDhQN57C2gSx1ulMl1kuGWH7ym4SK79OK7qOnJkpz3TwAlpr-CenPS0ZHq0h-MUK5pFJpkYPSsHg08jKG-BEDPxcLJqf6Yq2tvt2S83FxIhJzPO7xCrG9dVwJa7LWVoDtRYpugKeuWvMAY8stDD7eveP2FpfLffiip6wMKKxQCdDVWrWIb-c9OXpv7-ygb22wfRRyPSE-jY',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFFE0E3E5),
                                  child: const Icon(Icons.person,
                                      size: 50, color: primaryColor),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: secondaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gana Faye',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Master 1 Systèmes d'Information",
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 16,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- GRILLE DES CARTES D'INFORMATIONS ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _buildInfoCard(
                    title: 'Code Permanent',
                    value: '2024-UADB-085',
                    icon: Icons.badge_outlined,
                  ),
                  _buildInfoCard(
                    title: 'UFR',
                    value: 'SATIC',
                    icon: Icons.account_balance_outlined,
                  ),
                  _buildInfoCard(
                    title: 'Département',
                    value: 'TIC',
                    icon: Icons.lan_outlined,
                  ),
                  _buildInfoCard(
                    title: 'Statut',
                    value: 'Session 2024',
                    icon: Icons.check_circle_outline,
                    badge: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Inscrit',
                        style: TextStyle(
                          fontFamily: 'Public Sans',
                          color: Color(0xFF065F46),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              _buildActionButton(
                label: 'Historique Académique',
                icon: Icons.history_edu,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                label: 'Certificats & Documents',
                icon: Icons.description_outlined,
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // --- BOUTON SE DÉCONNECTER CORRIGÉ ---
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text(
                          'Déconnexion',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                            'Êtes-vous sûr de vouloir vous déconnecter de CampusPulse ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text(
                              'Annuler',
                              style: TextStyle(color: onSurfaceVariant),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // 1. On ferme le dialogue d'abord
                              Navigator.pop(dialogContext);

                              // 2. On appelle la méthode sans 'await' et sans 'final'
                              // C'est ici qu'il ne doit plus y avoir de 'await'
                              ref.read(authProvider.notifier).logout();

                              // 3. On fait la navigation (en vérifiant le contexte)
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GuestHomeScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            child: const Text(
                              'Se déconnecter',
                              style: TextStyle(
                                color: errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout, color: errorColor),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: errorColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  side: const BorderSide(color: errorColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    Widget? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 12,
              color: onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (badge != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: badge,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Public Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: primaryColor,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
