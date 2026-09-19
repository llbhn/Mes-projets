-- INSERT INTO Inscription (id_joueur, id_tournoi, date_inscription)
-- SELECT 
--     j.id_joueur, 
--     t.id_tournoi,
--     t.date_tournoi - (random() * 365 * 0.5)::int
-- FROM Joueur j
-- CROSS JOIN Tournoi t
-- WHERE random() < 0.4;

set schema 'parcoursup2';

insert into _type_bac (type_bac)
    VALUES ('general'), ('techno'), ('pro'), ('autres');

insert into _mention_bac (libelle_mention)
    VALUES ('sans_info'), ('sans_mention'), ('assez_bien'), ('bien'), ('tres_bien'), ('tres_bien_fel')

insert into _session(session_annee)
    select
        session_annee
    from import_data;

--peuplement de admission_selon_type_neo_bac : une insertion par type de bac (4)
insert into _admissions_selon_type_neo_bac (cod_aff_form, session_annee, type_bac, effectif_candidat_neo_bac_classes)
    select
        cod_aff_form,
        session_annee,
        'general',
        effectif_candidat_neo_bac_classes_type_general
    from import_data;
insert into _admissions_selon_type_neo_bac (cod_aff_form, session_annee, type_bac, effectif_candidat_neo_bac_classes)
    select
        cod_aff_form,
        session_annee,
        'techno',
        effectif_candidat_neo_bac_classes_type_techno
    from import_data;
insert into _admissions_selon_type_neo_bac (cod_aff_form, session_annee, type_bac, effectif_candidat_neo_bac_classes)
    select
        cod_aff_form,
        session_annee,
        'pro',
        effectif_candidat_neo_bac_classes_type_pro
    from import_data;
insert into _admissions_selon_type_neo_bac (cod_aff_form, session_annee, type_bac, effectif_candidat_neo_bac_classes)
    select
        cod_aff_form,
        session_annee,
        'autres',
        effectif_candidat_classes_type_autres
    from import_data;


--peuplement de effectif_selon_mention : une insertion par mention possible (6)
insert into _effectif_selon_mention(cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
    select
        cod_aff_form,
        session_annee,
        'sans_info',
        effectif_admis_neo_bac_selon_mention_type_mention_sans_info 
    from import_data;
insert into _effectif_selon_mention(cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
    select
        cod_aff_form,
        session_annee,
        'sans_mention',
        effectif_admis_neo_bac_selon_mention_type_mention_sans_mention
    from import_data;
insert into _effectif_selon_mention(cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
    select
        cod_aff_form,
        session_annee,
        'assez_bien',
        effectif_admis_neo_bac_selon_mention_type_mention_assez_bien
    from import_data;
insert into _effectif_selon_mention(cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
    select
        cod_aff_form,
        session_annee,
        'bien',
        effectif_admis_neo_bac_selon_mention_type_mention_bien
    from import_data;
insert into _effectif_selon_mention(cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
    select
        cod_aff_form,
        session_annee,
        'tres_bien',
        effectif_admis_neo_bac_selon_mention_type_mention_tres_bien
    from import_data;
insert into _effectif_selon_mention(cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
    select
        cod_aff_form,
        session_annee,
        'tres_bien_fel',
        effectif_admis_neo_bac_selon_mention_type_mention_tres_bien_fel 
    from import_data;


insert into _admissions_generalites(cod_aff_form, session_annee, selectivite, capacite, effectif_total_candidats, effectif_total_candidates)
    select 
        cod_aff_form,
        session_annee,
        selectivite,
        capacite,
        effectif_total_candidats,
        effectif_total_candidates
    from import_data;

--peuplement de regroupement : 1 insert par regroupement (3) remplacées par des union car plus rapide
insert into _regroupement(libelle_regroupement)
    select 
        regroupement_1
    from import_data

    union
        regroupement_2
        from import_data

    union
        regroupement_3
        from import_data;

insert into _rang_dernier_appele_selon_regroupement(cod_aff_form, session_annee, libelle_regroupement, rang_dernier_appele)
    select
        cod_aff_form,
        session_annee,
        regroupement_1,
        rang_dernier_appele_groupe1,
    from import_data

    union
    cod_aff_form,
        session_annee,
        regroupement_2,
        rang_dernier_appele_groupe2,
    from import_data

    union
    cod_aff_form,
        session_annee,
        regroupement_3,
        rang_dernier_appele_groupe3,
    from import_data;
