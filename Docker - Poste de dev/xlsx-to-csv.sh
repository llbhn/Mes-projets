#!/usr/bin/bash

#Rôle de ce script : 
#-recupère tous les fichiers xlsx, les transformes en csv
#-tris les sites touristiques en fonction de leur numéro de départements (y compris les corses qui sont considérées comme 20 et pas 2)
#-insére aussi les departements pour lesquels il n'y a aucun site

#docker image pull bigpapoo/sae103-excel2csv
#docker image pull sae103-excel2csv:latest

echo "run image excel2csv"

#docker run -tid --rm --name excel2csv bigpapoo/sae103-excel2csv
docker run -tid --rm --name excel2csv sae103-excel2csv

#copie du fichier depts vers docker
docker container cp ../utils/DEPTS excel2csv:/app

for fichier in ../input/*.xlsx; do
    nomFichier="$(basename "${fichier}")"
    echo "copy $nomFichier into excel2csv"
    docker container cp "$fichier" excel2csv:/app

    echo "execute le script dans le container"
    docker exec excel2csv bash -c "
        cd /app
        echo \"dans docker, traite les fichiers csv\"
        # On retire .xlsx a fichier, pour garder uniquement l'extension csv
        nom_sortie=\"${nomFichier%.xlsx}.csv\"
        ssconvert \"$nomFichier\" \"\$nom_sortie\"


        #------------------------------------------CSV transformation script-----------------------------------------------------

        #on envève toutes les lignes avec 2 virgules consécutives (titre et lignes vides)
        grep -v ',,' \"\$nom_sortie\" > tmp && rm -f \"\$nom_sortie\" && mv tmp \"\$nom_sortie\"

        #on retire la première ligne (entete des colonnes)
        tail -n +2 < \"\$nom_sortie\" > tmp && rm -f \"\$nom_sortie\" && mv tmp \"\$nom_sortie\"

        # on transforme tous les 2A en 20A et 2B en 20B pour que le tri marche mieux
        sed -i 's/2A/20A/g' \"\$nom_sortie\"
        sed -i 's/2B/20B/g' \"\$nom_sortie\"

        #tri en fonction des numero de départements
        sort -t ',' -k 2 -n < \"\$nom_sortie\" > tmp && rm -f \"\$nom_sortie\" && mv tmp \"\$nom_sortie\"

        #on retransforme dans l'autre sens pour garder le code exact, une fois que le tri est fait
        sed -i 's/20A/2A/g' \"\$nom_sortie\"
        sed -i 's/20B/2B/g' \"\$nom_sortie\"

        #to set the last dept
        echo \",95,\" >> \"\$nom_sortie\"

        #on parcourt chaque ligne du fichier pour ajouter les departements manquants et y associer les noms des départemetns
        current_dep=0
        touch tmp

        #IFS : séparateur, read -r : pour lire ligne par ligne (il n'y avais pas l'air d'avoir d'autres solutions pour parcourir le fichier en cli)
        while IFS=',' read -r site dep visiteurs; do
            # on s'assure que c'est un nombre (=~ pour comparer avec un regex)
            if [[ \"\$dep\" =~ ^[0-9]+\$ ]]; then

                # on ajoute les départements qui manquent
                while (( current_dep + 1 < dep )); do

                    #on ne veut pas ajouter le dep 20 car il s'agit de la corse, et elle a un autre code de département
                    if (( current_dep + 1 != 20 )); then

                        #si dep > 20 (après les corses), il y a un décallage de 1, on doit le prendre en compte
                        deptsLine=\$(( current_dep + 1 ))
                        if (( deptsLine > 20 )); then
                            deptsLine=\$(( current_dep + 2 ))
                        fi

                        echo \",\$(head -n \$deptsLine DEPTS | tail -n 1),\$((current_dep + 1)),\" >> tmp
                    fi
                    # on incrémente le compteur
                    current_dep=\$((current_dep + 1))
                done

                #si dep > 20 (après les corses), il y a un décallage de 1, on doit le prendre en compte
                deptsLine=\$(( dep ))
                if (( deptsLine > 20 )); then
                    deptsLine=\$(( dep + 1 ))
                fi

                #on affiche les lignes basiques (quand il n'y a pas de manque de département)
                echo \"\$site,\$(head -n \$deptsLine DEPTS | tail -n 1),\$dep,\$visiteurs\" >> tmp

                current_dep=\$dep

            #si c'est pas un nombre, c'est potenitelement les corses, donc on le vérifie
            elif [[ \"\$dep\" = \"2A\" || \"\$dep\" = \"2B\" ]]; then
                echo \"\$site,\$(head -n \$((current_dep + 1)) DEPTS | tail -n 1),\$dep,\$visiteurs\" >> tmp
                current_dep=\$((current_dep + 1))
            fi

        done < \"\$nom_sortie\"

        rm -f \"\$nom_sortie\" && mv tmp \"\$nom_sortie\"

        

        #------------------------------------------------------------------------------------------------------
    "
    docker container cp "excel2csv:/app/${nomFichier%.xlsx}.csv" ../output
done

echo "arret de l'image excel2csv"
docker stop excel2csv