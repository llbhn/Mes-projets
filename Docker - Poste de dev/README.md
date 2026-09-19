# SAÉ 1.03 — Chaîne de traitement automatisée de fichiers

Projet de groupe réalisé en 1ère année de BUT Informatique. Le but est d'automatiser la préparation de fichiers bruts (Excel, images, textes) reçus par une équipe de développement Web, pour les rendre exploitables sur un site touristique.

Toute la chaîne s'appuie sur des conteneurs Docker fournis : chaque script local envoie des fichiers dans un conteneur, y exécute un traitement, puis récupère le résultat.


Les fichiers à traiter doivent être placés dans un dossier `../input/`. Les résultats finaux se retrouvent dans le dossier `../output/`.

## Fichiers

`main.sh` : lance les 4 scripts dans l'ordre 
`xlsx-to-csv.sh` : .xlsx vers .csv, tri et complétion des départements 
`csv-to-pdf.sh` : .csv vers .html vers .pdf 
`csv-to-html.php` : Génère les 3 fichiers .htlm utilisés par `csv-to-pdf.sh` 
`img-to-better-img.sh` : Images simples vers .webp 
`text-to-txt.sh` : traitement des fichiers texte 
`txt-transformation.sh` : Découpe un fichier texte en plusieurs fichiers par sections

