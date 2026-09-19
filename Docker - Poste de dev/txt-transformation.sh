#!/usr/bin/bash

# Le script créé un dossier "/ouput/texts", puis traite des fichiers texte sans extension
# situés dans le répertoire courant. Il parse le contenu en recherchant des marqueurs
# spéciaux ("SECT=", "SUB_SECT=", "TEXT=") et crée pour chaque section ("SECT=")
# un fichier distinct dans "/ouput/texts" en sélectionnant ce qui suit "SECT=" et en remplaçant
# les espaces par des underscores. Le contenu qui se trouve après les "SUB_SECT=" et les
# "TEXT=" est ensuite ajouté à chaque fichier créé.

output_dir="/output/texts"
mkdir -p "$output_dir" #L'option -p permet de créer même si il existe déjà

# Trouver tous les fichiers sans extension
for input_file in $(find . -maxdepth 1 -type f ! -name "*.*" -exec basename {} \;); do # find . cherche à partir du répertoire courant (.) -maxdepth 1 limite la recherche au répertoire courant uniquement (ne descend pas dans les sous-dossiers) -type f cherche uniquement les fichiers (pas les dossiers) ! -name "*.*" le ! inverse la condition, donc cherche les fichiers qui n'ont PAS de point dans leur nom (fichiers sans extension) -exec basename {} \; pour chaque fichier trouvé, exécute la commande basename qui extrait uniquement le nom du fichier (sans le chemin) {} remplacé par le chemin du fichier trouvé \; marque la fin de la commande -exec
    
    echo "Traitement du fichier texte : $input_file"
    
    current_file=""

    while IFS= read -r  line; do #IFS c'est Internal Field Separator, et par défaut c'est " \t\n" soit espace, tab et saut de ligne. Donc ici on le set à rien pour qu'il lise toute la ligne. Ensuite read va lire toute la ligne, son option -r permet d'inclure les caractères spéciaux. Et on stock tout ça dans la variable line.
        if [[ "$line" == SECT=* ]]; then #Si line = SECT=n'importe quoi alors
        
            fic_title="${line#SECT=}" #On définit le titre du futur fichier en supprimant avec un dièse le SECT=
            fic_name="${fic_title// /_}.txt" #On redéfinit le titre du futur fichier en remplaçant les espaces par des _ et en ajoutant un .txt

            current_file="$output_dir/$fic_name" #On travaille dans ce fichier

            echo "$fic_title" > "$current_file" #Ajouter le titre de chaque SECT au début de chaque fichier
            echo "" >> "$current_file" #Ajouter rien à la fin de current_file pour qu'il ajoute une ligne vide

            sleep 1 #Petit couldown avant chaque création de fichier
            
            continue #ça saute le reste du code de la boucle et lit la prochaine ligne.
        fi

        [[ -z "$current_file" ]] && continue

        if [[ "$line" == SUB_SECT=* ]]; then

            txt="${line#SUB_SECT=}"
            
            echo "$txt" >> "$current_file"

            continue
        fi

        if [[ "$line" == TEXT=* ]]; then

            txt="${line#TEXT=}"

            echo "$txt" >> "$current_file"

            continue

        fi


    done < "$input_file"
    
    echo "Fichier $input_file traité."
    echo ""
    
done

