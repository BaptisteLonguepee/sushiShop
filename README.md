# 🍣 Sushi Shop - Borne de Commande Restaurant

[![Flutter](https://img.shields.io/badge/Flutter-3.10.1+-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green.svg)](https://supabase.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-orange.svg)](https://github.com/features/actions)
[![Tests](https://img.shields.io/badge/Tests-Unit%20%26%20Widget-success.svg)]()
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> Application Flutter complète pour borne de commande interactive dans un restaurant japonais. Interface moderne, multi-langues, intégrée avec Supabase.

---

## 📋 Workshop - Développement Natif

### 🏗️ Architecture Choisie : **MVVM (Model-View-ViewModel)**

L'application utilise le pattern **MVVM** avec **Provider** pour la gestion d'état :

```
┌─────────────────────────────────────────────────────────────────┐
│                         MVVM Architecture                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────┐      ┌───────────────┐      ┌──────────────┐     │
│  │   VIEW   │◄────►│   VIEWMODEL   │◄────►│    MODEL     │     │
│  │ (Screens)│      │   (Provider)  │      │   (Data)     │     │
│  └──────────┘      └───────────────┘      └──────────────┘     │
│       │                    │                     │              │
│       │                    │                     │              │
│       ▼                    ▼                     ▼              │
│  ┌──────────┐      ┌───────────────┐      ┌──────────────┐     │
│  │ Widgets  │      │ State Mgmt   │      │ Repository   │     │
│  │ UI Logic │      │ Business     │      │ Supabase API │     │
│  └──────────┘      └───────────────┘      └──────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Justification du choix :**
- **Séparation des responsabilités** : La logique métier est isolée dans les ViewModels
- **Testabilité** : Les ViewModels peuvent être testés unitairement sans dépendance UI
- **Réutilisabilité** : Les ViewModels peuvent être partagés entre différentes vues
- **Provider** : Léger, performant et recommandé par Flutter

---

## ✅ Fonctionnalités Réalisées (User Stories)

| US | Fonctionnalité | Status | Description |
|----|----------------|--------|-------------|
| **US1** | Parcourir le menu | ✅ | Catalogue avec 60+ produits, filtrage par catégories, recherche |
| **US2** | Consulter un produit | ✅ | Page détail avec description, prix, ingrédients, allergènes |
| **US3** | Personnaliser sa commande | ✅ | Sélection taille, extras, notes personnalisées, prix dynamique |
| **US4** | Gérer son panier | ✅ | Ajout/suppression, quantités, total automatique, badge temps réel |
| **US5** | Valider sa commande | ✅ | Récapitulatif, scan QR code pour numéro de table |
| **US6** | Paiement mocké | ✅ | Simulation CB/Espèces, états succès/échec |
| **US7** | Confirmation | ✅ | Numéro de commande, message remerciement, récapitulatif |

---

## 🔧 Contraintes Techniques Respectées

### 📡 Gestion des Données
- **API Backend** : Supabase (PostgreSQL)
- **Tables** : `categories`, `produits`, `commandes`, `commandes_articles`
- **Chargement asynchrone** avec gestion d'erreurs

### 📱 Composants Système Natifs (3 implémentés)

| Composant | Fichier | Utilisation |
|-----------|---------|-------------|
| **Haptic Feedback / Vibration** | `lib/core/services/vibration_service.dart` | Feedback tactile lors des actions (ajout panier, paiement) |
| **Stockage Local** | `lib/core/services/storage_service.dart` | Persistance panier, préférences langue |
| **Caméra / Scan QR** | `lib/view/qr_scan/` | Scan du QR code table (simulé pour démo) |

### 🔄 Cycle de Vie & Gestion d'Erreurs
- ✅ Comportement cohérent lors des rotations et retours
- ✅ Messages d'erreurs explicites (panier vide, données introuvables)
- ✅ Try/catch sur tous les appels API
- ✅ États de chargement avec indicateurs visuels
- ✅ Aucun crash non géré

### 🔐 Sécurité
- ✅ Clés API dans fichier `.env` (non versionné)
- ✅ `.env.example` fourni pour la configuration
- ✅ Permissions gérées (caméra)
- ✅ Validation des entrées utilisateur

### 🧪 Qualité & Tests

```bash
# Lancer tous les tests
flutter test

# Tests avec coverage
flutter test --coverage
```

| Type | Fichier | Couverture |
|------|---------|------------|
| **Unit Tests** | `test/view/cart/cart_test.dart` | CartViewModel, CartItem, Product |
| **Unit Tests** | `test/view/welcome/welcome_screen_test.dart` | WelcomeModel, WelcomeViewModel |
| **Widget Tests** | `test/view/order_type/order_type_test.dart` | OrderTypeScreen |

**Tests inclus :**
- ✅ Calcul total panier
- ✅ Ajout/suppression produits
- ✅ Incrémentation/décrémentation quantités
- ✅ Notification des listeners
- ✅ Parsing JSON modèles

### ⚙️ CI/CD - GitHub Actions

Pipeline automatique (`.github/workflows/ci-cd.yml`) :

```yaml
Jobs:
  1. test          → Installation, analyse, tests, formatage
  2. build-android → Build APK & App Bundle
  3. build-ios     → Build iOS (sans codesign)
```

**Déclencheurs :**
- Push sur `main`, `master`, `develop`, `feature/**`
- Pull requests

---

## 🚀 Instructions de Lancement

### Prérequis
```bash
flutter --version  # >= 3.10.1
```

### Installation
```bash
# 1. Cloner le repo
git clone https://github.com/BaptisteLonguepee/sushiShop.git
cd sushiShop

# 2. Installer les dépendances
flutter pub get

# 3. Configurer l'environnement (optionnel - base de test incluse)
cp .env.example .env
# Modifier SUPABASE_URL et SUPABASE_ANON_KEY si besoin

# 4. Lancer l'application
flutter run
```

### Build Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (Mac requis)
flutter build ios --release

# Windows
flutter build windows --release
```

---

## 📁 Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée, configuration Provider
├── core/
│   ├── constant/
│   │   └── color.dart          # Palette de couleurs
│   ├── providers/
│   │   └── locale_provider.dart # Gestion langue (SharedPreferences)
│   ├── services/
│   │   ├── vibration_service.dart   # Composant natif: vibration
│   │   └── storage_service.dart     # Composant natif: stockage local
│   └── widgets/
│       └── japanese_pattern.dart    # Widget décoratif
├── data/
│   ├── model/
│   │   ├── product_model.dart       # Modèle Produit
│   │   ├── category_model.dart      # Modèle Catégorie
│   │   ├── cart_item_model.dart     # Modèle Article Panier
│   │   └── commande_model.dart      # Modèle Commande
│   └── repository/
│       ├── product_repository.dart  # Accès API Produits
│       ├── category_repository.dart # Accès API Catégories
│       └── commande_repository.dart # Accès API Commandes
├── view/
│   ├── welcome/          # Écran d'accueil animé
│   ├── order_type/       # Sélection sur place/à emporter
│   ├── home/             # Catalogue produits avec filtres
│   ├── product_detail/   # Détail produit avec options
│   ├── cart/             # Panier interactif
│   ├── checkout/         # Récapitulatif commande
│   ├── qr_scan/          # Scan QR code table
│   ├── payment/          # Paiement simulé
│   └── confirmation/     # Confirmation commande
└── l10n/                 # Localisation FR/EN (ARB files)

test/
└── view/
    ├── cart/
    │   └── cart_test.dart           # Tests unitaires panier
    ├── welcome/
    │   └── welcome_screen_test.dart # Tests welcome
    └── order_type/
        └── order_type_test.dart     # Tests order type
```

---

## 📱 Captures d'écran

### Parcours Utilisateur

```
🏠 Accueil        →  📋 Type          →  🍱 Menu          →  📦 Détail
   ↓                     ↓                   ↓                   ↓
Animation         →  Sur place/       →  Catégories      →  Options
Bienvenue             À emporter          Recherche           Quantité
   ↓                     ↓                   ↓                   ↓
▶️ Commencer      →  Numéro table    →  Ajouter panier  →  Ajouter

🛒 Panier         →  📝 Checkout      →  📷 QR Scan      →  💳 Paiement
   ↓                     ↓                   ↓                   ↓
Articles          →  Récapitulatif   →  Scanner table   →  CB/Espèces
Quantités             Total               Validation          Simulé
   ↓                     ↓                   ↓                   ↓
Modifier          →  Valider         →  Continuer       →  Payer

                                      ✅ Confirmation
                                            ↓
                                      Numéro commande
                                      Merci !
                                      Nouvelle commande
```

---

## 🎨 Design System

### Palette de Couleurs
| Couleur | Code | Utilisation |
|---------|------|-------------|
| 🔴 Rouge Japonais | `#B1464A` | Couleur primaire, boutons |
| ⚪ Gris Clair | `#DFDFDF` | Background secondaire |
| 🟡 Or | `#D4AF37` | Accents, bordures premium |
| ⚫ Noir | `#1A1A1A` | Texte principal |

### Typographie
- **Kaisei Opti** : Titres, accents japonais
- **Noto Sans/Serif** : Corps de texte

---

## 🗄️ Base de Données

### Tables Supabase

```sql
-- Catégories de produits
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  description TEXT,
  ordre INT DEFAULT 0
);

-- Catalogue produits
CREATE TABLE produits (
  id SERIAL PRIMARY KEY,
  category_id INT REFERENCES categories(id),
  nom VARCHAR(200) NOT NULL,
  description TEXT,
  prix DECIMAL(10,2) NOT NULL,
  image_url TEXT,
  vegetarien BOOLEAN DEFAULT false,
  vegan BOOLEAN DEFAULT false
);

-- Commandes
CREATE TABLE commandes (
  id SERIAL PRIMARY KEY,
  numero VARCHAR(20) UNIQUE,
  table_number VARCHAR(10),
  total DECIMAL(10,2),
  statut VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Articles de commande
CREATE TABLE commandes_articles (
  id SERIAL PRIMARY KEY,
  commande_id INT REFERENCES commandes(id),
  produit_id INT REFERENCES produits(id),
  quantite INT NOT NULL,
  prix_unitaire DECIMAL(10,2),
  notes TEXT
);
```

---

## 📦 Dépendances

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1           # State management MVVM
  supabase_flutter: ^2.10.3  # Backend API
  flutter_dotenv: ^5.1.0     # Variables environnement
  google_fonts: ^6.3.2       # Typographie
  vibration: ^2.0.1          # Composant natif
  shared_preferences: ^2.3.5 # Stockage local
  mobile_scanner: ^6.0.2     # Scan QR code

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^6.0.0
```

---

## 👨‍💻 Auteur

**Baptiste Longuepee**
- GitHub: [@BaptisteLonguepee](https://github.com/BaptisteLonguepee)

---

## 📄 Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

---

## 🎯 Roadmap Future

- [ ] Paiement réel (Stripe/PayPal)
- [ ] Notifications push (Firebase)
- [ ] Mode hors-ligne complet
- [ ] Programme fidélité
- [ ] QR Code réel pour tables
- [ ] Analytics/Statistiques
- [ ] Mode sombre
- [ ] Tests d'intégration E2E

---

**Version 1.0.0** ✅ | *Développé avec ❤️ et Flutter*
