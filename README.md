# 🍣 Sushi Shop - Borne de Commande Restaurant

[![Flutter](https://img.shields.io/badge/Flutter-3.10.1+-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)]()

Application Flutter complète pour borne de commande interactive dans un restaurant japonais. Interface moderne, multi-langues, intégrée avec Supabase.

![Version](https://img.shields.io/badge/version-1.0.0-blue)

---

## 🎯 Vue d'ensemble

Application mobile/tablette permettant aux clients de :
- 📱 Parcourir le menu avec filtrage par catégorie
- 🛒 Gérer leur panier en temps réel
- ✅ Passer des commandes complètes
- 🌐 Utiliser l'interface en français ou anglais

**Stack Technique :**
- Frontend : Flutter/Dart
- Backend : Supabase (PostgreSQL)
- State Management : Provider
- Fonts : Google Fonts (Kaisei Opti)

---

## ✨ Fonctionnalités

### 🏪 Catalogue Produits
- ✅ 60+ produits organisés en 9 catégories
- ✅ Filtrage dynamique par catégorie
- ✅ Détails complets (description, allergènes, prix)
- ✅ Badges Vegan/Végétarien
- ✅ Support images

### 🛒 Panier Intelligent
- ✅ Ajout/modification/suppression d'articles
- ✅ Calcul automatique du total
- ✅ Compteur en temps réel
- ✅ Notes personnalisées

### 📝 Commande
- ✅ Formulaire client validé
- ✅ Génération numéro de commande unique
- ✅ Enregistrement Supabase
- ✅ Confirmation instantanée

### 🌐 Multi-langues
- ✅ Français
- ✅ Anglais
- ✅ Changement dynamique

---

## 🚀 Démarrage Rapide

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

# 3. Lancer l'application
flutter run
```

**✅ Base de test déjà configurée !** Le fichier `.env` contient une base Supabase fonctionnelle.

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [📖 APP_README.md](APP_README.md) | Documentation technique complète |
| [⚡ QUICK_START.md](QUICK_START.md) | Démarrage en 5 minutes |
| [🗄️ SUPABASE_SETUP.md](SUPABASE_SETUP.md) | Configuration base de données |
| [👤 USER_GUIDE.md](USER_GUIDE.md) | Guide utilisateur détaillé |
| [✅ FEATURES.md](FEATURES.md) | Liste des fonctionnalités |
| [📝 CHANGELOG.md](CHANGELOG.md) | Historique des versions |

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constant/      # Couleurs, constantes
│   └── providers/     # State management
├── data/
│   ├── model/        # Modèles de données
│   └── repository/   # Accès Supabase
├── view/
│   ├── welcome/      # Écran accueil
│   ├── home/         # Menu produits
│   ├── cart/         # Panier
│   ├── checkout/     # Commande
│   └── confirmation/ # Confirmation
└── l10n/             # Traductions FR/EN
```

---

## 🗄️ Base de Données

### Tables Supabase
- `categories` - Catégories de produits
- `produits` - Catalogue complet
- `commandes` - Commandes clients
- `commandes_articles` - Détails articles
- `options_produits` - Options/suppléments
- `promotions` - Codes promo
- `modes_paiement` - Paiements
- `parametres` - Configuration restaurant

**Script SQL complet fourni** dans la documentation.

---

## 📱 Captures d'écran

```
🏠 Accueil        →  🍱 Menu          →  🛒 Panier
   ↓                     ↓                   ↓
🌐 Langue         →  🔍 Filtres       →  ✏️ Quantités
   ↓                     ↓                   ↓
▶️ Commencer      →  ➕ Ajouter       →  💳 Commander
                                            ↓
                                       ✅ Confirmation
```

---

## 🎨 Design

### Palette de Couleurs
- 🔴 Primaire : `#B1464A` (Rouge japonais)
- ⚪ Secondaire : `#DFDFDF` (Gris clair)
- 🎨 Accent : Bordures dorées

### Police
- **Kaisei Opti** - Police japonaise moderne

---

## 🧪 Tests

### Test Rapide (2 min)
```bash
flutter run

# Puis dans l'app :
# 1. Cliquer "COMMENCER"
# 2. Sélectionner un produit
# 3. Ajouter au panier
# 4. Commander
# 5. Voir la confirmation ✅
```

### Vérification Supabase
Les commandes créées apparaissent dans votre dashboard Supabase !

---

## 📊 Données Incluses

- **9 Catégories** : Nigiri, Maki, Uramaki, Sashimi, etc.
- **60+ Produits** : Catalogue complet avec prix
- **5 Commandes** : Exemples pré-remplies
- **Paramètres** : Configuration restaurant

---

## 🔧 Configuration

### Votre propre Supabase

1. Créer un projet sur [supabase.com](https://supabase.com)
2. Exécuter le script SQL fourni
3. Modifier `.env` :
```env
SUPABASE_URL=votre_url
SUPABASE_ANON_KEY=votre_cle
```

---

## 📦 Build Production

```bash
# Android APK
flutter build apk --release

# iOS (nécessite Mac)
flutter build ios --release

# Web
flutter build web

# Windows
flutter build windows
```

---

## 🤝 Contribution

Les contributions sont bienvenues !

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit (`git commit -m 'Add AmazingFeature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

---

## 📄 Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

---

## 🎯 Roadmap Future

- [ ] Paiement en ligne (Stripe/PayPal)
- [ ] Notifications push
- [ ] Mode hors-ligne
- [ ] Programme fidélité
- [ ] QR Code pour tables
- [ ] Analytics/Statistiques
- [ ] Mode sombre

---

## 👨‍💻 Auteur

**Baptiste Longuepee**
- GitHub: [@BaptisteLonguepee](https://github.com/BaptisteLonguepee)

---

## 🙏 Remerciements

- [Flutter](https://flutter.dev/) - Framework UI
- [Supabase](https://supabase.com/) - Backend-as-a-Service
- [Provider](https://pub.dev/packages/provider) - State Management
- [Google Fonts](https://fonts.google.com/) - Typographie

---

## 📞 Support

- 📧 Email : support@example.com
- 💬 GitHub Issues
- 📚 Documentation complète fournie

---

## ⭐ Star le projet !

Si ce projet vous aide, n'hésitez pas à lui donner une étoile ⭐

---

**Version 1.0.0 - Production Ready** ✅

*Développé avec ❤️ et Flutter*
