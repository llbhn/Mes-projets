# Quiz Game - Créateur et Joueur

Ce projet contient deux programmes en C pour créer et jouer à des quiz.

## Fichiers

- **quizz_creation.c** : Programme pour créer un nouveau quiz
- **quizz_game.c** : Programme pour jouer à un quiz créé

## Compilation

Pour compiler les deux programmes sur Linux/Mac :

```bash
gcc -o quizz_creation quizz_creation.c
gcc -o quizz_game quizz_game.c
```

Pour compiler sur Windows avec MinGW :

```bash
gcc -o quizz_creation.exe quizz_creation.c
gcc -o quizz_game.exe quizz_game.c
```

## Utilisation

### Créer un quiz

```bash
./quizz_creation
```

Le programme vous demandera :
1. Le titre du quiz
2. Le nombre de questions
3. Chaque question
4. La réponse correcte pour chaque question

Le quiz sera sauvegardé dans un fichier `.quiz`

### Jouer à un quiz

```bash
./quizz_game
```

Le programme demandera le nom du fichier quiz à charger, puis vous posera chaque question.

À la fin, vous recevrez un score final avec le nombre de bonnes/mauvaises réponses.

## Exemple

```
$ ./quizz_creation
What will be the Title of your quizz game ?: Math Quiz
So, how many questions do you want in Math Quiz ?: 3
Ok, first let's write these 3 questions !
Question 1 : What is 2+2?
...

$ ./quizz_game
Enter the name of the quizz file to play: Math Quiz.quiz
```

## Caractéristiques

- Création interactive de quiz
- Sauvegarde des quiz dans des fichiers
- Système de scoring
- Support de questions et réponses de longueur variable