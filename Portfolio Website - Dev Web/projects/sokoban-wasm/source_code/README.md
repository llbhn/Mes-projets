# Sokoban - Code Source Original

Ce dossier contient le code source original du jeu Sokoban en C.

## Fichiers

- **sokoban.c** : Code source du jeu (compilable en C standard)
- **niveau1.sok à niveau6.sok** : Fichiers de niveaux

## Compilation

Pour compiler le code sur Linux/Mac :


gcc -o sokoban sokoban.c


Pour compiler sur Windows avec WSL :


gcc -o sokoban.exe sokoban.c


## Exécution


./sokoban


Le jeu vous demandera de choisir un niveau (1-6).

## Contrôles

- **Z** : Avancer (haut)
- **Q** : Gauche
- **S** : Reculer (bas)
- **D** : Droite
- **X** : Abandonner et sauvegarder
- **R** : Recommencer le niveau

## Légende

- `@` : Sokoban (le joueur)
- `#` : Mur
- `$` : Caisse
- `.` : Cible (destination pour les caisses)
- ` ` : Case vide

## Note

Les fichiers de niveaux (.sok) sont au format texte.
Chaque niveau fait 12×12 caractères.