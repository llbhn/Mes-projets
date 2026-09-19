drop schema if exists parcoursup cascade;
create schema parcoursup;
set schema 'parcoursup';

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