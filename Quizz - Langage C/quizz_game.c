#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){

    // QUIZZ GAME - PLAYING PART

    char quizzFilename[1000];

    printf("Enter the name of the quizz file to play: ");
    fgets(quizzFilename, 1000, stdin);
    quizzFilename[strlen(quizzFilename) - 1] = '\0';

    FILE *file = fopen(quizzFilename, "r");
    
    if (file == NULL) {
        printf("Error: Could not open file %s\n", quizzFilename);
        return 1;
    }

    int nbQuestions;
    char quizzTitle[1000];
    
    fscanf(file, "%d\n", &nbQuestions); // On récupère nbQuestions créée dans quizz_creation avec fprintf
    fgets(quizzTitle, 1000, file);
    quizzTitle[strlen(quizzTitle) - 1] = '\0';

    char questions[nbQuestions][900];
    char goodAnswer[nbQuestions][9000];

    for (int i = 0; i < nbQuestions; i++){
        fgets(questions[i], 900, file); // On utilise fgets afin de lire la ligne entière
        questions[i][strlen(questions[i]) - 1] = '\0';
        fgets(goodAnswer[i], 9000, file);
        goodAnswer[i][strlen(goodAnswer[i]) - 1] = '\0';
    }

    fclose(file);

    int nbGoodChoice = 0;
    int nbBadChoice = 0;

    system("clear");
    printf("===========================================\n");
    printf("     %s\n", quizzTitle);
    printf("===========================================\n\n");

    char playerAnswer[9000];

    for (int i = 0; i < nbQuestions; i++){

        printf("Question %d : %s\n\n", i+1, questions[i]);
        printf("Type your answer here : ");
        fgets(playerAnswer, 9000, stdin);
        playerAnswer[strlen(playerAnswer) - 1] = '\0';

        printf("\n");

        if (strcmp(playerAnswer, goodAnswer[i]) == 0){
            printf("Good Answer !\n\n\n");
            nbGoodChoice++;
        } else {
            printf("Wrong Answer ! The correct answer was: %s\n\n", goodAnswer[i]);
            nbBadChoice++;
        }
    }
    
    printf("===========================================\n");
    printf("            FINAL SCORE\n");
    printf("===========================================\n");
    printf("Good answers: %d\n", nbGoodChoice);
    printf("Wrong answers: %d\n", nbBadChoice);
    printf("Total: %d\n", nbGoodChoice + nbBadChoice);
    printf("===========================================\n");

    return 0;
}