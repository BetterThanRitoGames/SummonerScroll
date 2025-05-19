LAJOINIE Elie, LAGNEAUX Arthur et AVI Timéo

# 🧙‍♂️ SummonerScroll

**SummonerScroll** est une application iOS développée en SwiftUI permettant de consulter des informations sur un joueur League of Legends à partir de son pseudo et tag. Elle utilise l’API officielle de Riot Games.

## 📦 Fonctionnalités

- Connexion via pseudo + tag Riot.
- Affichage des informations de compte.
- Visualisation des 5 derniers matchs classés.
- Consultation de la rotation des champions gratuits.
- Interface SwiftUI moderne avec navigation par onglets.

## 📂 Structure

L'application est organisée comme suit :
- `API/` : appels réseau à l’API Riot.
- `Structs/` : modèles de données (`Dto`).
- `View/` : vues SwiftUI.
- `ViewModel/` : gestion des états et logique métier.
- `Assets.xcassets/` : icônes et couleurs.

## 🔐 Configuration de la clé API Riot

L’application utilise une clé d’API Riot à stocker de manière sécurisée dans une variable d’environnement. La clé est utilisée via :

```swift
let apiKey = ProcessInfo.processInfo.environment["RIOT_API_KEY"] ?? ""
```
### :wrench: Créer la clé API Riot Games

1. Crée un compte développeur sur [developer.riotgames.com](https://developer.riotgames.com/) et se connecter.
2. Accéder au tableau de bord développeur en cliquant sur sur votre nom de compte en haut à droite puis **Dashboard**
3. Génère une clé API de développement (valide 24 heures) et la copier dans le presse-papier.

### ➕ Ajouter la clé `RIOT_API_KEY`

1. Ouvrir le projet dans Xcode.
2. Sélectionne le schéma de ton app (près du bouton "Play").
3. Va dans : `Product > Scheme > Edit Scheme`.
4. Dans l’onglet **Run**, section **Arguments**, clique sur **+** dans "Environment Variables".
5. Ajoute :
   - **Name** : `RIOT_API_KEY`
   - **Value** : ta clé API Riot (copiée depuis https://developer.riotgames.com/)
