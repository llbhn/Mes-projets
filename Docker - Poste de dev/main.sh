#!/usr/bin/bash



echo "========================================="
echo lancement du script xlsx-to-csv.sh
echo "========================================="

chmod +x ./xlsx-to-csv.sh
./xlsx-to-csv.sh

echo "========================================="
echo lancement du script csv-to-pdf.sh
echo "========================================="

chmod +x ./csv-to-pdf.sh
./csv-to-pdf.sh

echo "========================================="
echo lancement du script img-to-better-img.sh
echo "========================================="

chmod +x ./img-to-better-img.sh
./img-to-better-img.sh

echo "========================================="
echo lancement du script text-to-txt.sh
echo "========================================="

chmod +x ./text-to-txt.sh
./text-to-txt.sh



echo "========================================="
echo "Fin d'execution, fichiers finaux dans le dossier output"
echo "========================================="


