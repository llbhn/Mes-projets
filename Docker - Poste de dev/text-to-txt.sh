#!/usr/bin/bash

# Ce script télécharge une image Docker (sae103-html2pdf), puis lance un conteneur qui exécute
# le script txt-transformation.sh sur tous les fichiers texte sans extension. Les dossiers input/output
# sont montés comme volumes dans le conteneur pour que les fichiers traités soient automatiquement 
# disponibles sur la machine hôte. À la fin, les résultats se retrouvent dans le dossier output.


img_name="sae103-html2pdf"
#img_name="bigpapoo/sae103-html2pdf"

set -e

docker_name="sae103-text"
script_dir=".."

echo "   Automatisation docker txt-transformation.sh"


# dl l'image docker
echo "Téléchargement de l'image Docker..."
#docker pull "$img_name"

# Vérifier qu'on a des fichiers à traiter
if [ -z "$(ls -A "$script_dir/input/" 2>/dev/null)" ]; then
    echo "Le dossier input/ est vide!"
    echo "Mettez vos fichiers txt dans: $script_dir/input/"
    exit 1
fi

echo "Fichiers trouvés dans input/"

mkdir -p "$script_dir/output/texts"
chmod -R 777 "$script_dir/output"


# Lancer le conteneur avec les volumes montés
echo "Exécution du script dans Docker !"

docker run \
    --rm \
    --name "$docker_name" \
    --user $(id -u):$(id -g) \
    -v "$script_dir/input:/input" \
    -v "$script_dir/output:/output" \
    -v "./txt-transformation.sh:/txt-transformation.sh" \
    "$img_name" \
    bash -c "cd /input && bash /txt-transformation.sh"

    # le --user sert a ce qu'on puisse modifier les fichiers après les avoir mis dans output, on
    # les associent au user executant le programme


    #Grâce aux -v on monte des dossiers input et output dans le docker, 
    #ils sont donc reliés aux dossiers du même nom sur ma machine,
    #et doncc tout ce qu'on fait dans les dossiers :/ (ceux sur docker),
    #Sera automatiquement fait dans ceux présents sur ma machine.
    #Donc c'est pour ça que y'a pas besoin d'aller chercher les fichiers traités sur docker
    #et de les mettre sur ma machine, avec une commande cp !!!

echo ""


echo "Fichiers textes traités"
