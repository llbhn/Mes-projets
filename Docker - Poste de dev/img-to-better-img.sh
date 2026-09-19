#!/usr/bin/bash

# Script permettant de changer la taille (stockage) en dessous de 180ko, le format 
# (en webp) d’une image. Ce script fait aussi un tri permettant de savoir si l’image 
# correspond au critère de l’équipe de Dev Web.




transformeesDir="../output/images/transformees"
nonValidesDir="../output/images/non-valide"

mkdir -p $nonValidesDir
mkdir -p $transformeesDir

#docker image pull bigpapoo/sae103-imagick

echo "run de l'image imagick"

docker run -tid --rm --name imagick sae103-imagick
#docker run -tid --rm --name imagick bigpapoo/sae103-imagick


docker exec imagick mkdir -p /app/images
for file in ../input/*.{png,jpg,jpeg,webp}; do
    fileName="$(basename "${file}")"

    echo "copy $file dans l'image docker"
    docker container cp "$file" imagick:/app/images/

    docker exec imagick convert "/app/images/$fileName" "/app/images/${fileName%.*}.webp"
    docker cp imagick:/app/images/${fileName%.*}.webp $nonValidesDir

done

for file in $nonValidesDir/*.webp; do


    
    filename=$(basename "$file")  # ex: image.webp
	echo "Traitement de l'image $filename"
    
    docker container cp "$file" imagick:/app/images/
    file_format_width=$(docker exec imagick identify -format "%w" "/app/images/$filename")
    file_format_height=$(docker exec imagick identify -format "%h" "/app/images/$filename")
    minRatio=$(( 350 / 250 ))
    maxRatio=$(( 900 / 620 ))
    imageRatio=$(( $file_format_width / file_format_height ))



    if [[ $imageRatio -ge $minRatio && $imageRatio -le $maxRatio ]]; then
		echo "debug boucle format"
        quality=90
        size=$(du -k "$file" | cut -f1)
        
        file_size=$(du -k "$file" | cut -f1)
        while [[ $size -gt 180 && $quality -ge 10 ]]; do
			echo "Taille fichier $size"
            docker exec imagick convert "/app/images/$filename" -quality "$quality" "/app/images/$filename"
            docker cp "imagick:/app/images/$filename" "$transformeesDir/$filename"

            size=$(du -k "$transformeesDir" | cut -f1) #cut sert à retirer le nom du fichier
            

            quality=$((quality - 10))
        done
            docker cp "imagick:/app/images/$filename" "$transformeesDir/$filename"
    else
        echo "Image non valide"
    fi
done

echo "arret de imagick et traitement des images terminé"
docker stop imagick
