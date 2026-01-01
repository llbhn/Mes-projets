#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

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

// ===== VARIABLES GLOBALES =====
int nombreDeplacements = 0;
int ligneJoueurTrouvee = -1;
int colonneJoueurTrouvee = -1;
t_plateau plateau;
t_plateau plateauInitial;
int niveauActuel = 1;
char plateauString[TAILLE * TAILLE + TAILLE + 1];
char niveauData[2048];

// ===== CHARGER NIVEAU DEPUIS STRING =====
void charger_niveau_depuis_string(const char* data) {
    int dataIdx = 0;
    
    printf("DEBUG: charger_niveau_depuis_string appelée\n");
    printf("DEBUG: data pointer = %p\n", (void*)data);
    
    // Initialiser complètement le plateau
    for (int ligne = 0; ligne < TAILLE; ligne++) {
        for (int colonne = 0; colonne < TAILLE; colonne++) {
            plateau[ligne][colonne] = CASE_VIDE;
            plateauInitial[ligne][colonne] = CASE_VIDE;
        }
    }
    
    // Charger le plateau depuis la string
    for (int ligne = 0; ligne < TAILLE && data[dataIdx] != '\0'; ligne++) {
        int colonne = 0;
        
        // Lire jusqu'à la fin de la ligne
        while (colonne < TAILLE && data[dataIdx] != '\n' && data[dataIdx] != '\0') {
            if (data[dataIdx] != '\r') {
                plateau[ligne][colonne] = (int)data[dataIdx];
                plateauInitial[ligne][colonne] = (int)data[dataIdx];
                colonne++;
            }
            dataIdx++;
        }
        
        // Remplir le reste de la ligne avec des espaces
        while (colonne < TAILLE) {
            plateau[ligne][colonne] = CASE_VIDE;
            plateauInitial[ligne][colonne] = CASE_VIDE;
            colonne++;
        }
        
        // Passer le newline
        if (data[dataIdx] == '\n') dataIdx++;
    }
    
    printf("DEBUG: Plateau[0][0] = %c (%d)\n", (char)plateau[0][0], plateau[0][0]);
    printf("DEBUG: Plateau[1][0] = %c (%d)\n", (char)plateau[1][0], plateau[1][0]);
    printf("DEBUG: Plateau[1][1] = %c (%d)\n", (char)plateau[1][1], plateau[1][1]);
    
    nombreDeplacements = 0;
    ligneJoueurTrouvee = -1;
    colonneJoueurTrouvee = -1;
}

// ===== AFFICHAGE =====

void afficher_plateau() {
    memset(plateauString, 0, sizeof(plateauString));
    
    printf("DEBUG: afficher_plateau() appelée\n");
    printf("DEBUG: plateau[0][0] = %c\n", (char)plateau[0][0]);
    
    int idx = 0;
    for (int ligne = 0; ligne < TAILLE; ligne++) {
        for (int colonne = 0; colonne < TAILLE; colonne++) {
            char caractere = (char)plateau[ligne][colonne];
            
            if (caractere == CAISSE_SUR_CIBLE) {
                plateauString[idx++] = '*';
            } else if (caractere == JOUEUR_SUR_CIBLE) {
                plateauString[idx++] = '+';
            } else {
                plateauString[idx++] = caractere;
            }
        }
        plateauString[idx++] = '\n';
    }
    plateauString[idx] = '\0';
    
    printf("DEBUG: plateauString rempli, length = %lu\n", idx);
    printf("DEBUG: plateauString[0] = %c\n", plateauString[0]);
}

bool gagne() {
    for (int ligne = 0; ligne < TAILLE; ligne++) {
        for (int colonne = 0; colonne < TAILLE; colonne++) {
            char caractere = (char)plateau[ligne][colonne];
            if (caractere == CAISSE) {
                return false;
            }
        }
    }
    return true;
}

// ===== FONCTIONS DE DÉPLACEMENT =====

bool trouver_joueur() {
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

bool deplacer_joueur_simple(int ligneJoueur, int colonneJoueur, 
                           int nouvelleLigne, int nouvelleColonne) {
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

bool caisse_peut_bouger(int ligneCaisse, int colonneCaisse) {
    if (ligneCaisse < 0 || ligneCaisse >= TAILLE || 
        colonneCaisse < 0 || colonneCaisse >= TAILLE) {
        return false;
    }
    
    char caseCaisse = (char)plateau[ligneCaisse][colonneCaisse];
    return (caseCaisse == CASE_VIDE || caseCaisse == CIBLE);
}

void effectuer_deplacement_caisse(int ligneJoueur, int colonneJoueur, 
                                 int nouvelleLigne, int nouvelleColonne, 
                                 int ligneCaisse, int colonneCaisse) {
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

bool deplacer_avec_caisse(int ligneJoueur, int colonneJoueur, 
                         int nouvelleLigne, int nouvelleColonne, 
                         char direction) {
    int ligneCaisse, colonneCaisse;
    
    calculer_position_caisse(nouvelleLigne, nouvelleColonne, direction, 
                            &ligneCaisse, &colonneCaisse);
    
    if (!caisse_peut_bouger(ligneCaisse, colonneCaisse)) {
        return false;
    }
    
    effectuer_deplacement_caisse(ligneJoueur, colonneJoueur, 
                                nouvelleLigne, nouvelleColonne, 
                                ligneCaisse, colonneCaisse);
    
    nombreDeplacements++;
    return true;
}

void deplacer(char direction) {
    if (!trouver_joueur()) {
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
    } else if (caseDestination == CASE_VIDE || caseDestination == CIBLE) {
        deplacer_joueur_simple(ligneJoueurTrouvee, colonneJoueurTrouvee, 
                              nouvelleLigne, nouvelleColonne);
    } else if (caseDestination == CAISSE || caseDestination == CAISSE_SUR_CIBLE) {
        deplacer_avec_caisse(ligneJoueurTrouvee, colonneJoueurTrouvee, 
                           nouvelleLigne, nouvelleColonne, direction);
    }
}

// ===== FONCTIONS POUR JAVASCRIPT =====

const char* get_plateau() {
    afficher_plateau();
    return plateauString;
}

int get_moves() {
    return nombreDeplacements;
}

bool is_won() {
    return gagne();
}

void move(char direction) {
    deplacer(direction);
}

// ===== BUFFER GLOBAL POUR EMSCRIPTEN =====
char levelBuffer[2048];

void init_level_from_string() {
    printf("DEBUG: init_level_from_string appelée\n");
    printf("DEBUG: levelBuffer[0] = %c, levelBuffer[1] = %c, levelBuffer[2] = %c\n", 
           levelBuffer[0], levelBuffer[1], levelBuffer[2]);
    charger_niveau_depuis_string(levelBuffer);
    printf("DEBUG: charger_niveau_depuis_string terminée\n");
    printf("DEBUG: plateau[0][0] = %c\n", (char)plateau[0][0]);
}

// Fonction pour obtenir l'adresse du buffer (pour JS)
char* get_level_buffer() {
    return levelBuffer;
}

int get_current_level() {
    return niveauActuel;
}

// ===== MAIN =====

int main() {
    charger_niveau_depuis_string("");
    
    #ifdef __EMSCRIPTEN__
    printf("Sokoban WASM initialized\n");
    #endif
    
    return 0;
}
