#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define chargement 10

int main(){

    // QUIZ CREATION

    int nbQuestions;
    char quizzTitle[1000];
    char filename[1000];

    printf("What will be the Title of your quizz game ? : ");
    fgets(quizzTitle, 1000, stdin);
    quizzTitle[strlen(quizzTitle) - 1] = '\0';
    
    printf("So, how many questions do you want in %s ? : ", quizzTitle);
    scanf("%d", &nbQuestions);
    getchar();

    char questions[nbQuestions][900];

    printf("\n");
    printf("Ok, first let's write these %d questions !\n", nbQuestions);
    printf("\n");

    for (int i = 0; i < nbQuestions; i++){
        printf("Question %d : ", i+1);
        fgets(questions[i], 900, stdin);
        questions[i][strlen(questions[i]) - 1] = '\0';
    }
    printf("\n");

    for (int i = 0; i < chargement; i++){
        printf("= ");
        fflush(stdout);
        usleep(200000);
    }
    printf("\n");

    char goodAnswer[nbQuestions][9000];

    for (int i = 0; i < nbQuestions; i++){
        printf("Here is Question %d : %s\n", i + 1, questions[i]);
        printf("\n");
        printf("What should be the answer for this Question : ");
        fgets(goodAnswer[i], 9000, stdin);
        goodAnswer[i][strlen(goodAnswer[i]) - 1] = '\0';

        for (int j = 0; j < chargement; j++){
            printf("= "); 
            fflush(stdout);  
            usleep(200000);
        }
        printf("\n");
    }

    // Save to file
    sprintf(filename, "%s.quiz", quizzTitle); // sprintf(destination, "format, ce qu'on veut écrire", source);
    FILE *file = fopen(filename, "w");
    
    if (file == NULL) {
        printf("Error: Could not create file %s\n", filename);
        return 1;
    }

    fprintf(file, "%d\n", nbQuestions); // fprintf(file, "format", variables);
    fprintf(file, "%s\n", quizzTitle);

    for (int i = 0; i < nbQuestions; i++){
        fprintf(file, "%s\n", questions[i]);
        fprintf(file, "%s\n", goodAnswer[i]);
    }

    fclose(file);

    printf("\n");
    for (int i = 0; i < chargement; i++){
        printf("= ");
        fflush(stdout);
        usleep(200000);
    }
    printf("\n");

    printf("Quizz successfully saved as : %s\n", filename);
    printf("You can now play by executing : ./quizz_game %s\n", filename);

    return 0;
}