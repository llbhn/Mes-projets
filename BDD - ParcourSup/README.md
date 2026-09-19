# SAÉ 2.04 — Base de données ParcourSup

Projet de BUT Informatique (IUT de Lannion, semestre 2) : modéliser, peupler puis exploiter statistiquement une base de données réaliste à partir des données ParcourSup 2022 (13 644 formations).

Le projet se déroule en 3 parties.

## Partie 1 — Implantation du schéma

Traduction du diagramme de classe UML fourni (`ParcourSup_simple.jpg`) en un schéma relationnel PostgreSQL.

Le schéma modélise les formations ParcourSup (établissement, commune, département, région, académie, filière) ainsi que les données d'admission qui en dépendent (généralités, répartition par type de bac, par mention, rang du dernier appelé par regroupement).

**Fichier livré :** `create_parcoursup2_db.sql` : crée le schéma `parcoursup2` et l'ensemble des tables (`_academie`, `_region`, `_departement`, `_commune`, `_etablissement`, `_filiere`, `_formation`, `_session`, `_mention_bac`, `_type_bac`, `_regroupement`, `_admissions_generalites`, `_admissions_selon_type_neo_bac`, `_effectif_selon_mention`, `_rang_dernier_appele_selon_regroupement`).

## Partie 2 — Peuplement de la base

Import des données du fichier `fr-esr-parcoursup_2022.csv` dans le schéma créé en partie 1.

Méthode : le CSV est d'abord chargé une seule fois dans une table temporaire (`import_data`) via `WbImport` (SQLWorkbench/J), puis les données sont réparties dans les tables finales par des `INSERT ... SELECT`.

**Fichiers livrés :**
- `populate_parcoursup2_db.sql` : création de la table temporaire et import du CSV
- `imort-partie-droite.sql` : répartition des données de `import_data` vers les tables normalisées (types de bac, mentions, regroupements, rangs d'appel)

## Partie 3 — Exploitation statistique

À partir d'un extrait de la base (`cormention.csv` : nom de la formation, longueur du nom, coefficient de proximité avec l'équateur, code département, proportion de candidates, proportion de mentions Bien/Très Bien), le script :

- affiche des boîtes à moustaches et des nuages de points pour visualiser les données
- calcule une **régression linéaire multiple** (à la main, en algèbre matricielle avec `numpy`) pour estimer le poids de chaque variable sur la proportion de mentions Bien/Très Bien
- calcule le **coefficient de corrélation** du modèle

**Résultat obtenu** (voir `rlm.txt`) : un coefficient de corrélation de 0.36, jugé trop faible pour conclure à un lien réel entre les variables étudiées et l'obtention d'une mention.

**Fichier principal :** `exploitation_parcoursup.py` — version aboutie du script (titres de graphiques, structure en sections, calculs de variance/corrélation).

D'autres scripts du dossier (`Louis.py`, `Terence.py`, `scriptSAE.py`) sont des versions de travail individuelles produites par les membres de l'équipe au cours du développement.
