-- CRÉATION DES TABLES :

-- Region :

CREATE TABLE _region (
    region_nom VARCHAR,

    -- Primary key :
    constraint _region_pk primary key (region_nom)
);



-- Département :

CREATE TABLE _departement (
    departement_code VARCHAR,
    departement_nom VARCHAR,

    -- Foreign key :
    region_nom VARCHAR,

    -- primary key :
    constraint _departement_pk primary key (departement_code),

    -- foreign key :
    constraint _departement_fk1 foreign key (region_nom) references _region(region_nom)
);



-- Commune :

CREATE TABLE _commune (
    commune_nom VARCHAR,

    -- Clé étrangère :
    departement_code VARCHAR,

    -- Primary key :
    constraint _commune_pk primary key (commune_nom, departement_code),

    -- Foreign key :
    constraint _commune_fk1 foreign key (departement_code) references _departement(departement_code)
);



-- Etablissement :

CREATE TABLE _etablissement (
    etablissement_code_uai VARCHAR,
    etablissement_nom VARCHAR,
    etablissement_statut VARCHAR,

    -- Primary key :
    constraint _etablissement_pk primary key (etablissement_code_uai)
);



-- Academie :

CREATE TABLE _academie (
    academie_nom VARCHAR,

    -- Primary key :
    constraint _academie_pk primary key (academie_nom)
);



-- Filiere :

CREATE TABLE _filiere (
    filiere_id INT,
    filiere_libelle VARCHAR,
    filiere_libelle_tres_abrege VARCHAR,
    filiere_libelle_abrege VARCHAR,
    filiere_libelle_detaille_bis VARCHAR,

    -- PRIMARY KEY :
    constraint _filiere_pk primary key (filiere_id)
);



-- FORMATION : 

CREATE TABLE _formation (
    cod_aff_form VARCHAR,
    filiere_libelle_detaille VARCHAR,
    coordonnees_gps VARCHAR,
    list_com VARCHAR,
    concours_communs_banque_epreuve VARCHAR,
    url_formation VARCHAR,
    tri VARCHAR,

    -- Clé étrangères :

    filiere_id INT,
    academie_nom VARCHAR,
    etablissement_code_uai VARCHAR,
    commune_nom VARCHAR,

    -- PRIMARY KEY :

    constraint _formation_pk primary key (cod_aff_form)

    -- FOREIGN KEYS :

    constraint _formation_fk1 foreign key (filiere_id) references _filiere(filiere_id),
    constraint _formation_fk2 foreign key (academie_nom) references _academie(academie_nom),
    constraint _formation_fk3 foreign key (etablissement_code_uai) references _etablissement(etablissement_code_uai),
    constraint _formation_fk4 foreign key (commune_nom) references _commune(commune_nom),

);





create table _type_bac(
    type_bac varchar(10),
    constraint _type_bac_pk primary key(type_bac)
);

create table _session(
    session_annee integer,
    constraint _session_pk primary key(session_annee)
);

create table _admissions_selon_type_neo_bac(
    effectif_candidat_neo_bac_classes integer,
    type_bac varchar(10),
    session_annee integer,
    cod_aff_form varchar(10),
    constraint _admissions_selon_type_neo_bac_pk primary key(type_bac, session_annee, cod_aff_form),
    constraint _admissions_selon_type_neo_bac_fk_1 foreign key(cod_aff_form) references _formation(cod_aff_form),
    constraint _admissions_selon_type_neo_bac_fk_2 foreign key(type_bac) references _type_bac(type_bac),
    constraint _admissions_selon_type_neo_bac_fk_3 foreign key(session_annee) references _session(session_annee)
);


create table _mention_bac(
    libelle_mention varchar(30),
    constraint _mention_bac_pk primary key(libelle_mention)
);

create table _effectif_selon_mention(
    effectif_admis_neo_bac_selon_mention integer,
    cod_aff_form varchar(10),
    libelle_mention varchar(30),
    session_annee integer,
    constraint _effectif_selon_mention_pk primary key(cod_aff_form, libelle_mention, session_annee),
    constraint _effectif_selon_mention_fk_1 foreign key(cod_aff_form) references _formation(cod_aff_form),
    constraint _effectif_selon_mention_fk_2 foreign key(libelle_mention) references _mention_bac(libelle_mention),
    constraint _effectif_selon_mention_fk_3 foreign key(session_annee) references _session(session_annee)
);


create table _admissions_generalites(
    selectivite varchar(30),
    capacite integer,
    effectif_total_candidats integer,
    effectif_total_candidates integer,
    session_annee integer,
    cod_aff_form varchar(10),
    constraint _admissions_generalites_pk primary key(session_annee, cod_aff_form),
    constraint _admissions_generalites_fk_1 foreign key(cod_aff_form) references _formation(cod_aff_form),
    constraint _admissions_generalites_fk_2 foreign key(session_annee) references _session(session_annee)
);


create table _regroupement(
    libelle_regroupement varchar(20),
    constraint _regroupement_pk primary key(libelle_regroupement)
);

create table _rang_dernier_appele_selon_regroupement(
    rang_dernier_appele integer,
    cod_aff_form varchar(10),
    libelle_regroupement varchar(20),
    session_annee integer,
    constraint _rang_dernier_appele_selon_regroupement_pk primary key(cod_aff_form, libelle_regroupement, session_annee),
    constraint _rang_dernier_appele_selon_regroupement_fk_1 foreign key(cod_aff_form) references _formation(cod_aff_form),
    constraint _rang_dernier_appele_selon_regroupement_fk_2 foreign key(libelle_regroupement) references _regroupement(libelle_regroupement),
    constraint _rang_dernier_appele_selon_regroupement_fk_3 foreign key(session_annee) references _session(session_annee)
);








