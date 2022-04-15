use clubs_efrei;

/*
select * from etudiant; 
select * from membre; 
select * from club; 
select * from organise_event; 
select * from evenement; 
select * from budget; 
select * from comite_organisation;
select * from clubs_efrei.donner_subvention; 
select * from clubs_efrei.sponsor; 
select * from clubs_efrei.tache;
select * from clubs_efrei.responsable_tache; 
select * from clubs_efrei.calendrier; 
select * from clubs_efrei.gerer_calendrier; 
select * from clubs_efrei.membre_temporaire; 
select * from clubs_efrei.sanction;
select * from clubs_efrei.administration; 
select * from clubs_efrei.recompense; 
select * from clubs_efrei.donnateur; 
select * from clubs_efrei.generer_rapport; 
select * from clubs_efrei.rapport_activitee; 
select * from clubs_efrei.description_etat; 
select * from clubs_efrei.etat;
select * from clubs_efrei.rediger; 
select * from clubs_efrei.signe; 
*/

/*--------------------------------------------------------------------------------   
                             LES REQUETES 
--------------------------------------------------------------------------------*/   
-- 1 
select c.nom, c.type, c.description, membre.responsabilite, etudiant.nom, 
		etudiant.prenom, etudiant.classe, etudiant.niveau, etudiant.num_etudiant from club c
inner join membre using(id_club)
inner join etudiant using(num_etudiant)
where membre.responsabilite = 'Président';

/*--------------------------------------------------------------------------------*/   
-- 2
select evenement.*, com.*, budget.budget, depense.depense  from evenement 
inner join budget using (id_budget)
left join comite_organisation com using(id_evenement)
left join (select comorg.id_comite_organisation, SUM(tache.montant) as depense from tache
		inner join responsable_tache using(id_tache)
		left join comite_organisation comorg using(id_comite_organisation)
		group by id_comite_organisation) depense using(id_comite_organisation)
where date_fin like '%2021%' and date_debut like '%2021%' ; 

/*--------------------------------------------------------------------------------*/   
-- 3
SELECT Club.Nom, Libelle AS Etat_rapport, Rapport_activitee.annee FROM Etat, Rapport_activitee, description_etat, Generer_rapport, Club 
WHERE Etat.Id_Etat = description_etat.Id_Etat and 
	description_etat.Id_Rapport_activitee = Rapport_activitee.Id_Rapport_activitee and 
    Rapport_activitee.Id_Rapport_activitee = Generer_rapport.Id_Rapport_activitee and
    Generer_rapport.Id_Club = Club.Id_Club;
/*--------------------------------------------------------------------------------*/   
-- 4 
-- Pour les rapports en cours de signature, afficher la liste des membres qui n’ont pas encore signé.
select annee, libelle, responsabilite, date_fin_signature, nom, prenom from rapport_activitee
	inner join description_etat using(id_rapport_activitee)
	inner join etat using(id_etat)
	inner join signe using(id_rapport_activitee)
	inner join (select id_membre, nom, prenom from membre 
				inner join etudiant using(num_etudiant) ) etu using(id_membre)
where libelle = 'en attente de signature' and date_fin_signature is NULL; 

/*--------------------------------------------------------------------------------*/   
-- 5
select m.responsabilite, club.nom as nom_club, etudiant.nom, etudiant.prenom from membre m
inner join etudiant using(num_etudiant)
inner join club using(id_club)
where etudiant.num_etudiant in ( select num_etudiant from membre
								inner join etudiant using(num_etudiant)
								group by num_etudiant
								having count(num_etudiant) > 1); 
/*--------------------------------------------------------------------------------*/                
-- 6
select libelle, montant, responsabilite, etudiant.nom, etudiant.prenom from tache
inner join membre on tache.id_responsable = membre.id_membre
inner join etudiant using(num_etudiant)
order by montant desc
LIMIT 10; 
/*--------------------------------------------------------------------------------*/   
-- 7 
select nom_even as Nom_evenement, responsabilite_tmp as Responsabilite_temporaire, prenom, nom, genre from comite_organisation
inner join evenement e using(id_evenement)
inner join membre_temporaire mb using(id_comite_organisation)
natural join membre 
natural join etudiant
where nom_even in (select distinct nom_even from evenement 
			inner join organise_event using (id_evenement)
			group by id_evenement
			having count(organise_event.id_club) > 1);
/*--------------------------------------------------------------------------------*/   
-- 8
SELECT c.Nom as Club, r.recompense, d.Nom as provenance
FROM Club c, recompense r, Donnateur d
WHERE c.Id_Club = r.Id_Club
and r.Id_Donnateur = d.Id_Donnateur;



/*--------------------------------------------------------------------------------   
                             LES VUES 
--------------------------------------------------------------------------------*/   
-- 1 
DROP VIEW IF exists top_clubs; 
CREATE view top_clubs as 
	select * from club 
    where nom not in (select nom from (select club.*, e.nom_even as Nom_event, e.Type_even, b.budget, ifnull(depense, 0) as depense from club 
		inner join organise_event using(id_club)
		inner join evenement e using(Id_Evenement)
		inner join budget b using(id_budget)
		left join (select comorg.id_evenement, (SUM(d.dons)-SUM(tache.montant)) as depense from tache
			inner join responsable_tache using(id_tache)
			left join comite_organisation comorg using(id_comite_organisation)
			left join donner_subvention d using(id_comite_organisation)
			group by id_comite_organisation) depense_gain using(id_evenement)) dep
		where budget + depense < 0); 
select * from top_clubs; 

/*--------------------------------------------------------------------------------*/
-- 2
CREATE OR REPLACE VIEW top_president AS 
	SELECT m.Id_Membre, Nom, Prenom, m.Responsabilite, Libelle, Date_debut, Date_fin, DATEDIFF(Date_fin, Date_debut) AS DuréeSignature
	FROM Membre m 
	JOIN Rediger r ON r.Id_Membre = m.Id_Membre
	JOIN Rapport_activitee rap ON rap.Id_Rapport_activitee = r.Id_Rapport_activitee 
	JOIN description_etat des ON  des.Id_Rapport_activitee = r.Id_Rapport_activitee 
	JOIN Etat e ON e.Id_Etat= des.Id_Etat
	JOIN Etudiant et ON et.Num_etudiant = m.Num_etudiant
	WHERE m.Responsabilite = 'président' AND Libelle = 'en cours de creation'
	ORDER BY DuréeSignature;

Select * from top_president;
/*--------------------------------------------------------------------------------*/
-- 3
DROP VIEW IF EXISTS aujourdhui; 
CREATE VIEW aujourdhui AS 
	select * from evenement e
    left join organise_event org using(id_evenement)
    left join club using(id_club)
    where date_debut = current_date() 
    order by heure_debut asc;
    
select * from aujourdhui; 
/*--------------------------------------------------------------------------------*/
-- 4 Créer une vue appelée « fainéant », qui donne le nom du membre du comité d’organisation 
-- d’un club donné qui signe le rapport en dernier.

drop view if exists faineant; 
create view faineant as 
	select e.nom, e.prenom, club.nom as nom_club, max_date.date_fin_signa from signe s
		inner join (select id_rapport_activitee as id_rapp, MAX(date_fin_signature) as date_fin_signa from signe s
					group by id_rapport_activitee) max_date 
                    on max_date.date_fin_signa = s.date_fin_signature 
                    and max_date.id_rapp = s.id_rapport_activitee
		inner join membre using(id_membre)
		inner join club using(id_club)
		inner join etudiant e using(num_etudiant); 
select * from faineant; 
/*--------------------------------------------------------------------------------*/
-- 5
DROP VIEW IF EXISTS trouble_fête; 
CREATE VIEW trouble_fête AS 
	select  club.nom, count(id_club) as nb_sanction from sanction
    left join club using(id_club)
    group by id_club
    order by nb_sanction DESC
    LIMIT 1; 
select * from trouble_fête;
/*--------------------------------------------------------------------------------*/
-- 6
DROP VIEW IF EXISTS vaut_mieux_acheter; 
CREATE VIEW vaut_mieux_acheter AS 
	select * from tache
    where libelle like '%location%'
    order by montant DESC
    limit 10 ; 
    -- on a choisi d'en afficher les 10 plus conteuses 
select * from vaut_mieux_acheter;
/*--------------------------------------------------------------------------------*/
-- 7
DROP VIEW IF EXISTS teachers_pet; 
CREATE VIEW teachers_pet AS 
	select club.*,count(id_club) as nb_recompense from recompense
    inner join club using(id_club)
    group by id_club
    order by nb_recompense DESC
    limit 1;
select * from teachers_pet;
/*--------------------------------------------------------------------------------*/
-- 8 

create or replace view perf as 
    select c.nom as club_name, m.responsabilite, m.debut_affectation, m.fin_affectation, etudiant.nom, etudiant.prenom, 
            evenement.nom_even as event_organise, IFNULL(som_sponsor.argent_sp, 0) as argent_sponsors, temps.tmp as Temps_redaction,
            ifnull(recompense, 'AUCUNE') as recompense, ifnull(sanction,'AUCUNE') as sanction
    from membre m
    natural join club c 
    inner join etudiant using(num_etudiant)
    inner join organise_event using(id_club)
    inner join evenement using(id_evenement)
    left join (select id_comite_organisation, id_evenement , sum(dons) as argent_sp from donner_subvention
                natural join comite_organisation 
                group by id_comite_organisation) som_sponsor using(id_evenement)
    left join (select id_club, datediff(date_fin, date_debut) as tmp from rapport_activitee 
                natural join description_etat
                natural join etat
                natural join generer_rapport
                where libelle = 'en attente de signature') temps using(id_club)
    left join recompense using(id_club)
    left join sanction using(id_club)
    where m.responsabilite = 'Président'; 
select * from perf;

/*--------------------------------------------------------------------------------*/
