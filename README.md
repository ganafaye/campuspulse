# 📱 CampusPulse (UADB)

**CampusPulse** est une application mobile moderne d'emploi du temps, spécialement conçue pour les étudiants de l'**Université Alioune Diop de Bambey (UADB)**. Elle répond à la problématique des changements d'horaires fréquents et offre une expérience fluide, rapide et accessible même sans connexion Internet.

---

## 🚀 Fonctionnalités Principales (Cahier des Charges)

- 🔐 **Authentification Étudiante** : Connexion simplifiée via le numéro de carte d'étudiant officiel de l'UADB.
- 📅 **Gestion de l'Emploi du Temps (Offline-First)** : Visualisation claire du planning de la semaine, stockée localement pour être consultable sans Internet.
- 🔔 **Alertes & Notifications en Temps Réel** : Notifications instantanées en cas de modification d'horaire, changement de salle ou annulation de cours.
- 🎛️ **Filtres Dynamiques** : Tri des cours par jour, par type (CM, TD, TP) et gestion des notifications individuelles par matière.

---

## 🏗️ Architecture du Projet

L'application est développée en respectant les principes de la **Clean Architecture** combinée avec **Riverpod** pour la gestion d'état, garantissant un code découplé, testable et évolutif :

- **`domain/`** : Le cœur logique pur (Entités métier comme `Course` et contrats de dépôts).
- **`data/`** : L'implémentation des données (Gestion de la base locale avec Hive et requêtes API).
- **`presentation/`** : L'interface utilisateur (Écrans, composants graphiques réutilisables, et gestion d'état UI).

---

## 🛠️ Installation et Lancement

Pour cloner et exécuter ce projet localement :

```bash
# 1. Cloner le projet
git clone [https://github.com/ganafaye/campuspulse.git](https://github.com/ganafaye/campuspulse.git)

# 2. Se déplacer dans le dossier
cd campuspulse

# 3. Récupérer les dépendances Flutter
flutter pub get

# 4. Lancer l'application sur votre appareil ou émulateur
flutter run

```

---

## 📝 Journal des Modifications (Changelog)

*Chaque membre du groupe doit ajouter ses modifications ici avant de faire un push, en suivant le format : `[DATE] [NOM] - Description des changements`.*

### 📅 Mai 2026

* **25/05/2026 [Gana]** - Initialisation du projet, configuration de Riverpod, GoRouter et nettoyage complet de `main.dart`.
* **25/05/2026 [Gana]** - Configuration de la charte graphique officielle UADB (Bleu Royal, Or, police Poppins).
* **25/05/2026 [Gana]** - Résolution du bug de compilation Android (Activation du *Core Library Desugaring* en Kotlin DSL dans `build.gradle` et génération de l'APK).
* **25/05/2026 [Gana]** - Création de la structure Clean Architecture et génération de l'arborescence des fichiers d'écrans (`screens/` et `widgets/`).

* **26/05/2026 [Gana]** - Mise en place des écrans d'acceuille`.
* **26/05/2026 [Gana]** - Mise en place de l'ecran Login.
* **26/05/2026 [Gana]** - Mise en place de l'ecran emplois du temps mais pas encore conncté.
* 
*(👉 Prochaine modification à ajouter ici par un membre du groupe)*

```

---

### 🚀 Exécute ces commandes pour l'envoyer sur ton GitHub :

Une fois le fichier enregistré dans VS Code, ouvre ton terminal et valide l'enregistrement avec ces commandes :

```bash
git add README.md
git commit -m "docs: Structure collaborative finale du README et journal des modifications"
git push

```
