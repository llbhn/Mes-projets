#!/usr/bin/bash

#Ce script récupère le fichier csv créé au préalable dans output, et s'en sert pour créer 3 pdfs :
# - un pdf trié par numéro de département
# - un pdf trié par nombre de visiteurs
# - un pdf recensant le nombre de visiteurs par régions.
# pour créer le pdf, il envoie d'abord un script php sur docker, en plus de fichiers utilistaires
# comme DEPTS REGIONS ou l'image des office de tourisme
# il exécute le php, qui va créer 3 html, qui seront ensuite convertis en pdf




#docker image pull bigpapoo/sae103-html2pdf
#docker image pull sae103-html2pdf:latest

echo "run image html2pdf"

#docker run -tid --rm --name html2pdf bigpapoo/sae103-html2pdf
docker run -tid --rm --name html2pdf sae103-html2pdf:latest

#copie du fichier depts vers docker
docker container cp ../utils/DEPTS html2pdf:/work
docker container cp ../utils/REGIONS html2pdf:/work
docker container cp ./csv-to-html.php html2pdf:/work
docker container cp ../utils/office.png html2pdf:/work



for fichier in ../output/*.csv; do
    echo "copy $fichier into image"
    docker container cp "$fichier" html2pdf:/work/file.csv

    echo "execute script in the container"
    docker exec html2pdf bash -c "
        chmod +x csv-to-html.php
        ./csv-to-html.php

        weasyprint sites-dept.html sites-dept.pdf
        weasyprint sites-visites.html sites-visistes.pdf
        weasyprint sites-regions.html sites-regions.pdf

    "

    docker container cp "html2pdf:/work/sites-dept.pdf" ../output
    docker container cp "html2pdf:/work/sites-visistes.pdf" ../output
    docker container cp "html2pdf:/work/sites-regions.pdf" ../output
    #docker container cp "html2pdf:/work/sites-regions.html" ../output
    #docker container cp "html2pdf:/work/sites-dept.html" ../output
    #docker container cp "html2pdf:/work/sites-visites.html" ../output


done

echo "arret de html2pdf"
docker stop html2pdf