// lib/presentation/screens/alerts_screen.dart

import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  // Constantes de couleur tirées de ta maquette et harmonisées UADB
  static const Color primaryColor = Color(0xFF00113A);
  static const Color primaryContainer = Color(0xFF002366);
  static const Color secondaryColor = Color(0xFF115CB9);
  static const Color secondaryContainer = Color(0xFF659DFE);
  static const Color onSurfaceVariant = Color(0xFF444650);
  static const Color backgroundColor = Color(0xFFF8F9FB);
  static const Color outlineVariant = Color(0xFFC5C6D2);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color secondaryFixed = Color(0xFFD7E2FF);
  static const Color onSecondaryFixedVariant = Color(0xFF004491);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // Le haut de la page (TopAppBar de ta maquette)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false, // Pas de flèche retour automatique car c'est un onglet principal
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: primaryColor),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header : Aujourd'hui
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "AUJOURD'HUI",
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Tout marquer comme lu',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 1. CARTE URGENT (Changement de salle)
              _buildNotificationCard(
                indicatorColor: errorColor,
                iconWidget: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning, color: onErrorContainer, size: 24),
                ),
                tagText: 'URGENT',
                tagColor: errorColor,
                timeText: 'Il y a 5 min',
                bodyText: "Changement de salle : Le cours de SI de 10h30 est déplacé à l'Amphi A (UFR SATIC).",
                actionWidget: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Voir sur le plan',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. CARTE RAPPEL (Cours Dev Mobile)
              _buildNotificationCard(
                indicatorColor: secondaryColor,
                iconWidget: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: secondaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.alarm, color: onSecondaryFixedVariant, size: 24),
                ),
                tagText: 'RAPPEL',
                tagColor: secondaryColor,
                timeText: 'Il y a 2 heures',
                bodyText: 'Rappel : Votre cours de Développement Mobile commence dans 15 minutes en Salle B1.',
              ),

              const SizedBox(height: 24),

              // Section Header : Plus ancien
              const Text(
                "PLUS ANCIEN",
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // 3. CARTE INFO (Conférence Cybersécurité) avec opacité réduite à 90%
              Opacity(
                opacity: 0.90,
                child: _buildNotificationCard(
                  indicatorColor: onSurfaceVariant,
                  iconWidget: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFECEEF0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline, color: onSurfaceVariant, size: 24),
                  ),
                  tagText: 'INFO',
                  tagColor: onSurfaceVariant,
                  timeText: 'Il y a 1 jour',
                  bodyText: "Conférence Cybersécurité : L'événement débutera demain à 09h00.",
                  actionWidget: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBLuQ0BYrJ0MH7PGB5qKs-ZShu_yycAHSQeXmET2XzRQLvfQbjl0cQoIBlTxLURF_Xa1C0ZcU2DQYJW13MG1s5i3YfhxuUvwkvtipDgiSunjmOVUwZSD8tqoAUsl8WGeO4WZqadxe7wOkJJVcYI3kTMQSe9XjhmtWrivEQRK5CJC5KHvOVJLk_QcSR-F-SyvyVn_l1qnuQ5cimPeCBQRYYhYxqvxjbWKfDgjZEYA75g6kYVxh4wjHYmFBVScv4eIP424zbLzY5jwLk',
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 130,
                                width: double.infinity,
                                color: const Color(0xFFE0E3E5),
                                child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'En savoir plus ',
                                style: TextStyle(
                                  fontFamily: 'Public Sans',
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(Icons.open_in_new, color: secondaryColor, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Widget constructeur pour centraliser la logique des cartes de notifications de la maquette
  Widget _buildNotificationCard({
    required Color indicatorColor,
    required Widget iconWidget,
    required String tagText,
    required Color tagColor,
    required String timeText,
    required String bodyText,
    Widget? actionWidget,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Bandelette de couleur latérale gauche (w-1.5 de ta maquette)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          // Contenu principal de la notification
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconWidget,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tagText,
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: tagColor,
                            ),
                          ),
                          Text(
                            timeText,
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 12,
                              color: onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bodyText,
                        style: const TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 15,
                          height: 1.4,
                          color: primaryColor,
                        ),
                      ),
                      if (actionWidget != null) actionWidget,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}