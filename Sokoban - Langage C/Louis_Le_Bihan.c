#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

// ===== CONSTANTES =====
#define TAILLE 12
#define TOUCHE_AVANCER 'z'
#define TOUCHE_GAUCHE 'q'
#define TOUCHE_RECULER 's'
#define TOUCHE_DROITE 'd'
#define TOUCHE_ABANDONNER 'x'
#define TOUCHE_RECOMMENCER 'r'

// ==== CARACTÈRES DU PLATEAU ====
#define JOUEUR '@'
#define JOUEUR_SUR_CIBLE '+'
#define CAISSE '$'
#define CAISSE_SUR_CIBLE '*'
#define CIBLE '.'
#define MUR '#'
#define CASE_VIDE ' '

// ===== TYPE t_plateau =====
typedef int t_plateau[TAILLE][TAILLE];

// ===== VARIABLES =====
int nombreDeplacements = 0;
int ligneJoueurTrouvee = -1;
int colonneJoueurTrouvee = -1;

// ===== FONCTIONS FOURNIES (ne pas les modifier !!!) =====

void charger_partie(t_plateau plateau, char fichier[]){
    FILE * f;
    char finDeLigne;

    f = fopen(fichier, "r");
    if (f==NULL){
        printf("ERREUR SUR FICHIER");
        exit(EXIT_FAILURE);
    } else {
        for (int ligne=0 ; ligne<TAILLE ; ligne++){
            for (int colonne=0 ; colonne<TAILLE ; colonne++){
                fread(&plateau[ligne][colonne], sizeof(char), 1, f);
            }
            fread(&finDeLigne, sizeof(char), 1, f);
        }
        fclose(f);
    }
}

void enregistrer_partie(t_plateau plateau, char fichier[]){
    FILE * f;
    char finDeLigne='\n';

    f = fopen(fichier, "w");
    for (int ligne=0 ; ligne<TAILLE ; ligne++){
        for (int colonne=0 ; colonne<TAILLE ; colonne++){
            fwrite(&plateau[ligne][colonne], sizeof(char), 1, f);
        }
        fwrite(&finDeLigne, sizeof(char), 1, f);
    }
    fclose(f);
}

int kbhit(){
	// la fonction retourne :
	// 1 si un caractere est present
	// 0 si pas de caractere présent
	int unCaractere=0;
	struct termios oldt, newt;
	int ch;
	int oldf;

	// mettre le terminal en mode non bloquant
	tcgetattr(STDIN_FILENO, &oldt);
	newt = oldt;
	newt.c_lflag &= ~(ICANON | ECHO);
	tcsetattr(STDIN_FILENO, TCSANOW, &newt);
	oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
	fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
 
	ch = getchar();

	// restaurer le mode du terminal
	tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
	fcntl(STDIN_FILENO, F_SETFL, oldf);
 
	if(ch != EOF){
		ungetc(ch, stdin);
		unCaractere=1;
	} 
	return unCaractere;
}

// ===== FONCTIONS OBLIGATOIRES =====

void afficher_entete(char fichier[]) {
    system("clear");
    
    printf("====================================\n");
    printf("              SOKOBAN               \n");
    printf("====================================\n");
    printf("\n");
    printf("Niveau: %s\n", fichier);
    printf("Nombre de deplacements: %d\n", nombreDeplacements);
    printf("\n");
    printf("Commandes:\n");
    printf("  q : gauche    z : haut\n");
    printf("  s : bas       d : droite\n");
    printf("  x : abandonner\n");
    printf("  r : recommencer\n");
    printf("\n");
    printf("Légende:\n");
    printf("  @ : Sokoban   # : Mur\n");
    printf("  $ : Caisse    . : Cible\n");
    printf("    : Case vide\n");
    printf("\n");
    printf("====================================\n");
    printf("\n");
}

void afficher_plateau(t_plateau plateau) {
    for (int ligne = 0; ligne < TAILLE; ligne++) {
        for (int colonne = 0; colonne < TAILLE; colonne++) {
            char caractere = (char)plateau[ligne][colonne];
            
            if (caractere == CAISSE_SUR_CIBLE) {
                printf("$");
            } else if (caractere == JOUEUR_SUR_CIBLE) {
                printf("@");
            } else {
                printf("%c", caractere);
            }
        }
        printf("\n");
    }
}

bool gagne(t_plateau plateau) {
    for (int ligne = 0; ligne < TAILLE; ligne++) {
        for (int colonne = 0; colonne < TAILLE; colonne++) {
            char caractere = (char)plateau[ligne][colonne];
            if (caractere == CAISSE) {
                return true;
            }
        }
    }
    
    printf("\n=== FÉLICITATIONS! ===\n");
    printf("Vous avez reussi le niveau!\n");
    printf("Nombre de deplacements: %d\n", nombreDeplacements);
    printf("Appuyez sur 'x' pour quitter.\n");
    return false;
}

// ===== FONCTIONS DE DÉPLACEMENT =====

bool trouver_joueur(t_plateau plateau) {
    for (int ligne = 0; ligne < TAILLE; ligne++) {
        for (int colonne = 0; colonne < TAILLE; colonne++) {
            char caractere = (char)plateau[ligne][colonne];
            if (caractere == JOUEUR || caractere == JOUEUR_SUR_CIBLE) {
                ligneJoueurTrouvee = ligne;
                colonneJoueurTrouvee = colonne;
                return true;
            }
        }
    }
    ligneJoueurTrouvee = -1;
    colonneJoueurTrouvee = -1;
    return false;
}

bool deplacer_joueur_simple(t_plateau plateau, int ligneJoueur, 
                           int colonneJoueur, int nouvelleLigne, 
                           int nouvelleColonne) {
    char caseDestination = (char)plateau[nouvelleLigne][nouvelleColonne];
    char caseOrigine = (char)plateau[ligneJoueur][colonneJoueur];
    
    if (caseOrigine == JOUEUR) {
        plateau[ligneJoueur][colonneJoueur] = CASE_VIDE;
    } else if (caseOrigine == JOUEUR_SUR_CIBLE) {
        plateau[ligneJoueur][colonneJoueur] = CIBLE;
    }
    
    if (caseDestination == CASE_VIDE) {
        plateau[nouvelleLigne][nouvelleColonne] = JOUEUR;
    } else if (caseDestination == CIBLE) {
        plateau[nouvelleLigne][nouvelleColonne] = JOUEUR_SUR_CIBLE;
    }
    
    nombreDeplacements++;
    return true;
}

void calculer_position_caisse(int nouvelleLigne, int nouvelleColonne, 
                             char direction, int *ligneCaisse, 
                             int *colonneCaisse) {
    *ligneCaisse = nouvelleLigne;
    *colonneCaisse = nouvelleColonne;
    
    switch (direction) {
        case TOUCHE_AVANCER: (*ligneCaisse)--; break;
        case TOUCHE_RECULER: (*ligneCaisse)++; break;
        case TOUCHE_GAUCHE: (*colonneCaisse)--; break;
        case TOUCHE_DROITE: (*colonneCaisse)++; break;
    }
}

bool caisse_peut_bouger(t_plateau plateau, int ligneCaisse, 
                       int colonneCaisse) {
    if (ligneCaisse < 0 || ligneCaisse >= TAILLE || 
        colonneCaisse < 0 || colonneCaisse >= TAILLE) {
        return false;
    }
    
    char caseCaisse = (char)plateau[ligneCaisse][colonneCaisse];
    return (caseCaisse == CASE_VIDE || caseCaisse == CIBLE);
}

void effectuer_deplacement_caisse(t_plateau plateau, int ligneJoueur, 
                                 int colonneJoueur, int nouvelleLigne, 
                                 int nouvelleColonne, int ligneCaisse, 
                                 int colonneCaisse) {
    char caseOrigine = (char)plateau[ligneJoueur][colonneJoueur];
    char caseDestination = (char)plateau[nouvelleLigne][nouvelleColonne];
    char caseCaisse = (char)plateau[ligneCaisse][colonneCaisse];
    
    if (caseOrigine == JOUEUR) {
        plateau[ligneJoueur][colonneJoueur] = CASE_VIDE;
    } else if (caseOrigine == JOUEUR_SUR_CIBLE) {
        plateau[ligneJoueur][colonneJoueur] = CIBLE;
    }
    
    if (caseDestination == CAISSE) {
        plateau[nouvelleLigne][nouvelleColonne] = JOUEUR;
    } else if (caseDestination == CAISSE_SUR_CIBLE) {
        plateau[nouvelleLigne][nouvelleColonne] = JOUEUR_SUR_CIBLE;
    }
    
    if (caseCaisse == CASE_VIDE) {
        plateau[ligneCaisse][colonneCaisse] = CAISSE;
    } else if (caseCaisse == CIBLE) {
        plateau[ligneCaisse][colonneCaisse] = CAISSE_SUR_CIBLE;
    }
}

bool deplacer_avec_caisse(t_plateau plateau, int ligneJoueur, 
                         int colonneJoueur, int nouvelleLigne, 
                         int nouvelleColonne, char direction) {
    int ligneCaisse, colonneCaisse;
    
    calculer_position_caisse(nouvelleLigne, nouvelleColonne, direction, 
                            &ligneCaisse, &colonneCaisse);
    
    if (!caisse_peut_bouger(plateau, ligneCaisse, colonneCaisse)) {
        return false;
    }
    
    effectuer_deplacement_caisse(plateau, ligneJoueur, colonneJoueur, 
                                nouvelleLigne, nouvelleColonne, 
                                ligneCaisse, colonneCaisse);
    
    nombreDeplacements++;
    return true;
}

void deplacer(t_plateau plateau, char direction) {
    if (!trouver_joueur(plateau)) {
        return;
    }
    
    int nouvelleLigne = ligneJoueurTrouvee;
    int nouvelleColonne = colonneJoueurTrouvee;
    
    switch (direction) {
        case TOUCHE_AVANCER: nouvelleLigne--; break;
        case TOUCHE_RECULER: nouvelleLigne++; break;
        case TOUCHE_GAUCHE: nouvelleColonne--; break;
        case TOUCHE_DROITE: nouvelleColonne++; break;
    }
    
    if (nouvelleLigne < 0 || nouvelleLigne >= TAILLE || 
        nouvelleColonne < 0 || nouvelleColonne >= TAILLE) {
        return;
    }
    
    char caseDestination = (char)plateau[nouvelleLigne][nouvelleColonne];
    
    if (caseDestination == MUR) {
        return;
    } else if (caseDestination == CASE_VIDE || 
               caseDestination == CIBLE) {
        deplacer_joueur_simple(plateau, ligneJoueurTrouvee, 
                              colonneJoueurTrouvee, 
                              nouvelleLigne, nouvelleColonne);
    } else if (caseDestination == CAISSE || 
               caseDestination == CAISSE_SUR_CIBLE) {
        deplacer_avec_caisse(plateau, ligneJoueurTrouvee, 
                           colonneJoueurTrouvee, 
                           nouvelleLigne, nouvelleColonne, direction);
    }
}

// ===== LE MAIN =====

int main() {
    t_plateau plateau;
    char niveau[50];
    char fichierEnregistrement[50];
    
    // Demander à l'utilisateur quel niveau jouer
    printf("Choisissez un niveau (1-6): ");
    int choixNiveau;
    scanf("%d", &choixNiveau);
    sprintf(niveau, "niveau%d.sok", choixNiveau);

    char touche = '\0';
    bool continuerJeu = true;

    charger_partie(plateau, niveau);
    afficher_entete(niveau);
    afficher_plateau(plateau);

    while (continuerJeu == true) {
        touche = '\0';
        if (kbhit()) {
            touche = getchar();
            
            if (touche == TOUCHE_ABANDONNER) {
                printf("Fichier d'enregistrement: ");
                scanf("%s", fichierEnregistrement);
                enregistrer_partie(plateau, fichierEnregistrement);
                printf("\nPartie sauvegardee. Au revoir!\n");
                continuerJeu = false;
                
            } else if (touche == TOUCHE_AVANCER || 
                      touche == TOUCHE_RECULER || 
                      touche == TOUCHE_GAUCHE || 
                      touche == TOUCHE_DROITE) {
                deplacer(plateau, touche);
                afficher_entete(niveau);
                afficher_plateau(plateau);
                
                continuerJeu = gagne(plateau);
                
            } else if (touche == TOUCHE_RECOMMENCER) {
                char reponse;
                printf("Recommencer? (O/N): ");
                scanf(" %c", &reponse);
                
                if (reponse == 'O' || reponse == 'o') {
                    charger_partie(plateau, niveau);
                    nombreDeplacements = 0;
                    afficher_entete(niveau);
                    afficher_plateau(plateau);
                } else {
                    continuerJeu = false;
                }
            }
        }
    }

    return 0;
}



