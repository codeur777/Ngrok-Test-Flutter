# Ngrok-Test-Flutter

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)](https://djangoproject.com)
[![ngrok](https://img.shields.io/badge/ngrok-1F1F1F?style=for-the-badge&logo=ngrok&logoColor=white)](https://ngrok.com)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)

Ce projet est une démonstration technique d'intégration fluide entre un backend Django (Python) et un frontend Flutter Web, conçue pour fonctionner de manière optimale derrière un tunnel ngrok avec un seul port, éliminant ainsi toute configuration complexe de CORS ou de Mixed Content.

---

## Structure du Projet

```text
django_flutter_test_ngrok/
├── backend/                  # Partie Django
│   ├── testngrok/            # Projet Django principal
│   │   ├── api/              # Application Django pour l'API REST
│   │   └── testngrok/        # Configuration Django (settings, urls)
│   └── venv/                 # Environnement virtuel Python
└── frontend/                 # Partie Flutter
    └── testngrok/            # Application Flutter Web
```

---

## Fonctionnalités Clés

* **Backend Django** : Fournit une API REST simple avec l'endpoint `GET /api/bonjour/`.
* **Frontend Flutter Web** : Une interface utilisateur moderne avec un design sombre, une animation d'icône de succès fluide et une carte de message dynamique.
* **Détection Dynamique** : Flutter utilise `Uri.base.origin` pour s'adresser au backend, s'adaptant instantanément à l'adresse (localhost, IP réseau local, ou URL publique ngrok) sans modification du code.
* **Zéro Problème de CORS** : Le frontend et l'API étant servis sur le même port par Django, le navigateur n'applique aucun blocage d'origine croisée.

---

## Guide d'Installation et Lancement

### 1. Préparation du Backend (Django)

1. Ouvrez un terminal dans le dossier `backend/testngrok`.
2. Activez l'environnement virtuel :
   ```bash
   ..\venv\Scripts\activate
   ```
3. Installez les dépendances nécessaires :
   ```bash
   pip install django django-cors-headers
   ```
4. Lancez le serveur Django (écoute toutes les interfaces locales sur le port 8000) :
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

### 2. Compilation de Flutter (Frontend)

Si vous modifiez l'application Flutter :
1. Ouvrez un terminal dans le dossier `frontend/testngrok`.
2. Installez les paquets :
   ```bash
   flutter pub get
   ```
3. Compilez l'application pour le Web :
   ```bash
   flutter build web --release
   ```
*Les fichiers compilés seront directement servis par Django à la racine `/`.*

### 3. Exposition Publique avec ngrok

Pour tester sur votre smartphone ou partager le projet :
1. Ouvrez un terminal et tapez :
   ```bash
   ngrok http 8000
   ```
2. Ouvrez l'URL publique fournie par ngrok (`https://xxxx.ngrok-free.app`) sur votre smartphone pour voir l'application Flutter consommer l'API Django de manière transparente !
