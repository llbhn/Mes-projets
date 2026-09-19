drop schema if exists parcoursup2 cascade;

create schema parcoursup2;
set schema 'parcoursup2';

create table _academie(
    academie_nom  varchar(50),
    constraint _academie_pk primary key(academie_nom)
);

create table _region(
    region_nom  varchar(50),
    constraint _region_pk primary key(region_nom)
);

create table _departement(
    departement_code    varchar(3),
    departement_nom     varchar(50) not null,
    region_nom          varchar(50) not null,
    constraint _departement_pk primary key(departement_code),
    constraint _departemnent_fk_region foreign key (region_nom)
        references _region(region_nom)
);

create table _commune(
    commune_nom         varchar(50),
    departement_code    varchar(3),
    constraint _commune_pk primary key (commune_nom, departement_code),
    constraint _commune_fk_departement foreign key (departement_code)
        references _departement(departement_code) 
);

create table _etablissement(
    etablissement_code_uai  varchar(10),
    etablissement_nom       varchar(150) not null,
    etablissement_statut    varchar(40) not null,
    constraint _etablissement_pk primary key (etablissement_code_uai)
);

create table _filiere(
    filiere_id                      serial,
    filiere_libelle                 varchar(400)    not null,
    filiere_libelle_tres_abrege     varchar(30)     not null,
    filiere_libelle_abrege          varchar(100)    not null,
    filiere_libelle_detaille_bis    varchar(150)    not null,
--    filiere_libelle_tres_detaille   varchar(400), -- possiblement vide
    constraint _filiere_pk primary key (filiere_id)
);

create table _formation (
    filiere_libelle_detaille          varchar(400)    not null, -- toutes les infos, y compris l'établissement
    coordonnees_gps                   varchar(30)     not null,
    list_com                          varchar(60),    -- possiblement vide
    cod_aff_form                      varchar(20)     not null, -- identifiant pour une année
    tri                               varchar(20)     not null,
    concours_communs_banques_epreuves varchar(100),   -- possiblement vide
    url_formation                     varchar(150),   -- possiblement vide
    filiere_id                        integer         not null,
    etablissement_code_uai            varchar(15)     not null,
    commune_nom                       varchar(50)     not null,
    departement_code                  varchar(3)      not null,
    academie_nom                      varchar(50)     not null,
    constraint _formation_pk primary key (cod_aff_form),
    constraint _formation_fk_filiere foreign key (filiere_id)
        references _filiere(filiere_id),
    constraint _formation_fk_etablissement foreign key (etablissement_code_uai)
        references _etablissement(etablissement_code_uai),
    constraint _formation_fk_commune foreign key(commune_nom, departement_code)
        references _commune(commune_nom, departement_code),
    constraint _formation_fk_academie foreign key(academie_nom)
        references _academie(academie_nom)
);

create table _session(
    session_annee   numeric(4), -- sensible au bug de l'an 10000
    constraint _session_pk primary key (session_annee)
);

create table _mention_bac(
    libelle_mention     varchar(40),
    constraint _mention_pk primary key (libelle_mention)
);

create table _type_bac(
    type_bac    varchar(20),
    constraint _type_bac_pk primary key (type_bac)
);

create table _regroupement(
    libelle_regroupement    varchar(100),
    constraint _regroupement_pk primary key(libelle_regroupement)
);

create table _admissions_generalites(
    cod_aff_form                            varchar(20),
    session_annee                           numeric(4),
    selectivite                             varchar(30)     not null,
    capacite                                integer         not null,
    effectif_total_candidats                integer         not null, -- candidates incluses
    effectif_total_candidates               integer         not null,
    constraint _admissions_generalites_pk
        primary key(cod_aff_form,session_annee),
    constraint _admissions_generalites_fk_formation
        foreign key (cod_aff_form) references _formation(cod_aff_form),
    constraint _admissions_generalites_fk_session
        foreign key (session_annee) references _session(session_annee),
    constraint _admissions_generalite_ck_candidats_candidates
        check (effectif_total_candidats >= effectif_total_candidates)
);

create table _admissions_selon_type_neo_bac(
    cod_aff_form                                    varchar(20),
    session_annee                                   numeric(4),
    type_bac                                        varchar(20),
    effectif_candidat_neo_bac_classes               integer     not null,
    constraint _admissions_selon_type_neo_bac_pk 
        primary key (cod_aff_form, session_annee, type_bac),
    constraint _admissions_selon_type_neo_bac_fk_formation
        foreign key (cod_aff_form) references _formation(cod_aff_form),
    constraint _admissions_selon_type_neo_bac_fk_session
        foreign key (session_annee) references _session(session_annee),
    constraint _admissions_selon_type_neo_bac_fk_type_bac
        foreign key (type_bac) references _type_bac(type_bac)
);

create table _effectif_selon_mention(
    cod_aff_form                            varchar(20),
    session_annee                           numeric(4),
    libelle_mention                         varchar(40),
    effectif_admis_neo_bac_selon_mention    integer     not null,
    constraint _effectif_selon_mention_pk 
        primary key (cod_aff_form, session_annee, libelle_mention),
    constraint _effectif_selon_mention_fk_formation
        foreign key (cod_aff_form) references _formation(cod_aff_form),
    constraint _effectif_selon_mention_fk_session
        foreign key(session_annee) references _session(session_annee),
    constraint _effectif_selon_mention_fk_mention_bac
        foreign key(libelle_mention) references _mention_bac(libelle_mention)
);

create table _rang_dernier_appele_selon_regroupement(
    cod_aff_form                        varchar(20),
    session_annee                       numeric(4),
    libelle_regroupement                varchar(100),
    rang_dernier_appele                 integer        not null,
    constraint _rang_dernier_appele_selon_regroupement_pk
        primary key (cod_aff_form, session_annee, libelle_regroupement),
    constraint _rang_dernier_appele_selon_regroupement_fk_formation
        foreign key (cod_aff_form) references _formation(cod_aff_form),
    constraint _rang_dernier_appele_selon_regroupement_fk_session
        foreign key (session_annee) references _session(session_annee),
    constraint _rang_dernier_appele_selon_regroupement_fk_regroupement
        foreign key (libelle_regroupement) references _regroupement(libelle_regroupement)
);

commit; -- utile si oubli de l'autocommit dans la configuration
