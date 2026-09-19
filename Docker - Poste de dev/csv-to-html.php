#!/usr/bin/php

<?php
# ce script est exécuté dans docker, il prend un fichier csv, et s'en sert pour créer des fichiers html
# où il va ranger les informations de manière lisible dans un tableau, et y mettre un titre et une image
# ces ficheir html seront ensuite convertis en pdf par le script csv-to-pdf.sh
    



    error_reporting(E_ALL & ~E_WARNING);
    ini_set('display_errors', '0');

    $depts_html = fopen("sites-dept.html", "w");
    $visites_html = fopen("sites-visites.html", "w");
    $regions_html = fopen("sites-regions.html", "w");

    $depts_base = "";
    $visites_base = "";
    $regions_base = "";

    $base = "<!DOCTYPE html>
            <head>
                <style>
                    @page {
                        size: A4;
                        margin: 5mm;
                    }
                    
                    body {
                        margin: 0;
                        padding: 0;
                    }
                    
                    .container {
                        display: flex;
                        gap: 5px;
                    }
                    
                    .column {
                        flex: 1;
                        width: 48%;
                        gap: 5px;
                        margin: 5px;
                    }
                    
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        font-size: 7px;
                    }
                    
                    th, td {
                        border: solid black 0.5px;
                        padding: 1px 2px;
                        font-size: 7px;
                        line-height: 1.2;
                    }
                    
                    th {
                        background-color: #f0f0f0;
                        font-weight: bold;
                    }

                    header {
                        display: flex;
                        flex-direction: row;
                        justify-content: center;
                        text-align: center;
                    }

                    h1 {
                        font-size: 2em;
                    }
                </style>
            </head>
            <body>
            ";
    $depts_base .= $base;
    $depts_base .="
    
    <img width=\"5px\" src=\"./office.png\">
    <header>
                    <h1>Tableau repertoriant les sites touristiques trie par No de departement</h1>
                </header>

                <div class=\"container\">
                <div class=\"column\">
                <table style=\"text-align: center;\">

                <tr>
                    <th>N° Depts</th>
                    <th>Nom Depts</th>
                    <th>Nom site</th>
                    <th>Nb Visites</th>
                </tr>";
    $visites_base .= $base;
    $visites_base .="
    <img width=\"5px\" src=\"./office.png\">
        <header>
                    <h1>Tableau repertoriant les sites touristiques trie par Nb de visiteurs</h1>
                </header>

                <div class=\"container\">
                <div class=\"column\">
                <table style=\"text-align: center;\">
    <tr>
                    <th>Nb Visites</th>
                    <th>Nom site</th>
                    <th>N° Depts</th>
                    <th>Nom Depts</th>
                </tr>";
    $regions_base .= $base;
    $regions_base .="
    <img width=\"5px\" src=\"./office.png\">
    <header>
                    <h1>Tableau repertoriant les regions avec le nombre de visiteurs total</h1>
                </header>

                <div class=\"container\">
                <div class=\"column\">
                <table style=\"text-align: center;\"><tr>
                    <th>Nom Region</th>
                    <th>Departement</th>
                    <th>Nb Visites Depts</th>
                    <th>Nb visites totales</th>
                </tr>";
    fwrite($depts_html, $depts_base);
    fwrite($visites_html, $visites_base);
    fwrite($regions_html, $regions_base);


    $csvLines = file("file.csv");

    $dept_text = "";
    $vistes_text = "";
    $regions_text = "";
    $i = 0;
    $countCsvLines = count($csvLines);
    $midDepts = ceil($countCsvLines / 2);

    foreach($csvLines as $line){

        $parts = explode(",", $line);
        $i++;
        
        if($i == $midDepts) {
            fwrite($depts_html, "</table></div><div class=\"column\"><table style=\"text-align: center;\">");
            fwrite($depts_html, "<tr>
                    <th>N° Depts</th>
                    <th>Nom Depts</th>
                    <th>Nom site</th>
                    <th>Nb Visites</th>
                </tr>");
        }

        $dept_text = "<tr>
        <td> $parts[2] </td>
        <td> $parts[1] </td>
        <td> $parts[0] </td>
        <td> $parts[3] </td>
        </tr>
        ";
        fwrite($depts_html, $dept_text);
    }
    exec('sort -t "," -k 4,4rn -k 3,3n < file.csv > sorted-visit.csv');
    $csvLines = file(filename: "sorted-visit.csv");
    $i = 0;


    foreach($csvLines as $line){
        $parts = explode(",", $line);

        $i++;
        
        if($i == $midDepts) {
            fwrite($visites_html, "</table></div><div class=\"column\"><table style=\"text-align: center;\">");
            fwrite($visites_html, "<tr>
                    <th>Nb Visites</th>
                    <th>Nom site</th>
                    <th>N° Depts</th>
                    <th>Nom Depts</th>
                </tr>");
        }

        $visites_text = "<tr>
        <td> $parts[3] </td>
        <td> $parts[0] </td>
        <td> $parts[2] </td>
        <td> $parts[1] </td>
        </tr>
        ";
        fwrite($visites_html, $visites_text);
    }

    $csvLines = file(filename: "file.csv");

    $regionsLines = file("REGIONS");

    $totalRegions = count($regionsLines);
    $midPoint = ceil($totalRegions / 2);
    $regionCount = 0;
    
    foreach($regionsLines as $region){
        $regionCount++;
        
        if($regionCount == $midPoint) {
            fwrite($regions_html, "</table></div><div class=\"column\"><table style=\"text-align: center;\">");
            fwrite($regions_html, "<tr>
                    <th>Nom Region</th>
                    <th>Departement</th>
                    <th>Nb Visites Depts</th>
                    <th>Nb visites totales</th>
                </tr>");
        }
        
        $regionParts = explode("=", $region);
        $nom = trim($regionParts[0]);
        $noDeptsParts = explode(",", $regionParts[1]);
        $rowspan = count($noDeptsParts);
        

        $regions_text = "<tr><td rowspan=\"$rowspan\">$nom</td>";

        $deptNum = 0;
        
        
        foreach($noDeptsParts as $noDept){
            $deptOccurence = 0;
            
            $totalVisiteReg = 0;
            foreach($csvLines as $line) {
                $csvParts = explode(",", $line);
                if(isset($csvParts[2]) && trim($csvParts[2]) == trim($noDept)){       
                    $deptOccurence++;
                }
                if(in_array($csvParts[2], $noDeptsParts)) {
                        $totalVisiteReg = $totalVisiteReg + (int)$csvParts[3];
                    }
            }

            
            
            $deptCount = 0;
            $nbVisitesDept = 0;
            foreach($csvLines as $line){
                
                $csvParts = explode(",", $line);
                if(isset($csvParts[2]) && trim($csvParts[2]) == trim($noDept)){
                    $deptCount++;
                    $nomDept = $csvParts[1];
                    $nbVisitesDept += (int)$csvParts[3];
                    
                    
                    

                    if($deptCount == $deptOccurence) {
                        if($deptNum != 0){
                            $regions_text .= "<tr>";
                        }

                        $regions_text .= "<td>$noDept - $nomDept</td> <td>$nbVisitesDept</td>";

                        if($deptNum == 0){
                            $regions_text .= "<td rowspan=\"$rowspan\">$totalVisiteReg</td>
                            </tr>";
                        }
                        else{
                            $regions_text .= "</tr>";
                        }
                        $deptNum++;
                    }
                }

            }
        }
        
        fwrite($regions_html, $regions_text);
    }




    $dept_text .= "</table></body>";
    $visites_text .= "</table></body>";
    $regions_text = "</table></div></div></body>";


    fwrite($depts_html, $dept_text);
    fwrite($visites_html, $visites_text);
    fwrite($regions_html, $regions_text);


?>