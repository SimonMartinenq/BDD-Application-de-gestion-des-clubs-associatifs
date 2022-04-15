DROP DATABASE if exists clubs_efrei;
CREATE database clubs_efrei; 
USE clubs_efrei; 


drop table if exists clubs_efrei.administration;  	
drop table if exists clubs_efrei.description_etat; 
drop table if exists clubs_efrei.donner_subvention;
drop table if exists clubs_efrei.etat;
drop table if exists clubs_efrei.generer_rapport;
drop table if exists clubs_efrei.organise_event;
drop table if exists clubs_efrei.recompense;
drop table if exists clubs_efrei.sanction;
drop table if exists clubs_efrei.rediger;
drop table if exists clubs_efrei.signe;
drop table if exists clubs_efrei.sponsor;
drop table if exists club; 
drop table if exists clubs_efrei.donnateur;
drop table if exists clubs_efrei.rapport_activitee;
drop table if exists responsable_tache; 
drop table if exists clubs_efrei.tache;
drop table if exists membre_temporaire;
drop table if exists clubs_efrei.comite_organisation; 
drop table if exists clubs_efrei.calendrier;
drop table if exists clubs_efrei.evenement;
drop table if exists clubs_efrei.budget; 
drop table if exists clubs_efrei.membre;
drop table if exists clubs_efrei.etudiant; 

CREATE TABLE Club(
   Id_Club INT NOT NULL auto_increment,
   Nom VARCHAR(50) NOT NULL,
   Date_creation DATE,
   Type VARCHAR(50),
   Description VARCHAR(100),
   PRIMARY KEY(Id_Club)
)Engine='InnoDB';

CREATE TABLE Etudiant(
   Num_etudiant INT NOT NULL auto_increment,
   Prenom VARCHAR(50),
   Nom VARCHAR(50),
   Genre VARCHAR(1),
   Classe VARCHAR(50),
   Niveau INT,
   Date_naissance DATE,
   PRIMARY KEY(Num_etudiant)
)Engine='InnoDB';

CREATE TABLE Tache(
   Id_Tache INT,
   Libelle VARCHAR(50),
   montant INT,
   id_responsable INT NOT NULL, 
   PRIMARY KEY(Id_Tache)
)Engine='InnoDB';

CREATE TABLE Rapport_activitee(
   Id_Rapport_activitee INT,
   annee INT,
   PRIMARY KEY(Id_Rapport_activitee)
)Engine='InnoDB';

CREATE TABLE Membre(
   Id_Membre INT NOT NULL auto_increment,
   Responsabilite VARCHAR(50),
   Debut_affectation DATE,
   Fin_affectation DATE,
   Id_Club INT NOT NULL,
   Num_etudiant INT NOT NULL,
   PRIMARY KEY(Id_Membre),
   FOREIGN KEY(Id_Club) REFERENCES Club(Id_Club),
   FOREIGN KEY(Num_etudiant) REFERENCES Etudiant(Num_etudiant)

)Engine='InnoDB';

CREATE TABLE Etat(
   Id_Etat INT,
   Libelle enum ('absent', 'en cours de creation', 'en attente de signature','signé', 'soumis'),
   Date_debut DATE,
   Date_fin DATE,
   PRIMARY KEY(Id_Etat)
   
)Engine='InnoDB';

CREATE TABLE Administration(
   Id_Administration INT,
   Nom VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Administration)
)Engine='InnoDB';


CREATE TABLE Donnateur(
   Id_Donnateur INT,
   Nom VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Donnateur)
)Engine='InnoDB';


CREATE TABLE Sponsor(
   Id_Sponsor INT NOT NULL,
   Nom VARCHAR(50),
   PRIMARY KEY(Id_Sponsor)
)Engine='InnoDB';

CREATE TABLE Budget(
   Id_Budget INT NOT NULL,
   Budget INT,
   PRIMARY KEY(Id_Budget)
)Engine='InnoDB';

CREATE TABLE Calendrier(
   Id_Calendrier INT NOT NULL,
   date_ DATE,
   description VARCHAR(50),
   PRIMARY KEY(Id_Calendrier)
)Engine='InnoDB';

CREATE TABLE Evenement(
   Id_Evenement INT,
   Nom_even VARCHAR(50),
   Date_debut DATE,
   Date_fin DATE,
   Heure_debut TIME,
   Heure_fin TIME,
   Type_even VARCHAR(50),
   Id_Budget INT,
   PRIMARY KEY(Id_Evenement),
   FOREIGN KEY(Id_Budget) REFERENCES Budget(Id_Budget)
)Engine='InnoDB';

CREATE TABLE Comite_organisation(
   Id_Comite_organisation INT,
   Date_creation DATE,
   Date_dissolution DATE,
   Id_Evenement INT NOT NULL,
   PRIMARY KEY(Id_Comite_organisation),
   UNIQUE(Id_Evenement),
   FOREIGN KEY(Id_Evenement) REFERENCES Evenement(Id_Evenement)
)Engine='InnoDB';


CREATE TABLE Organise_event(
   Id_Club INT,
   Id_Evenement INT,
   PRIMARY KEY(Id_Club, Id_Evenement),
   FOREIGN KEY(Id_Club) REFERENCES Club(Id_Club),
   FOREIGN KEY(Id_Evenement) REFERENCES Evenement(Id_Evenement)
)Engine='InnoDB';

CREATE TABLE Responsable_tache(
   Id_Comite_organisation INT,
   Id_Tache INT NOT NULL,
   PRIMARY KEY(Id_Comite_organisation, Id_Tache),
   FOREIGN KEY(Id_Comite_organisation) REFERENCES Comite_organisation(Id_Comite_organisation),
   FOREIGN KEY(Id_Tache) REFERENCES Tache(Id_Tache)
)Engine='InnoDB';

CREATE TABLE Rediger(
   Id_Rapport_activitee INT,
   Id_Membre INT,
   Responsabilite VARCHAR(50),
   date_fin_redact DATE, 
   PRIMARY KEY(Id_Rapport_activitee, Id_Membre),
   FOREIGN KEY(Id_Rapport_activitee) REFERENCES Rapport_activitee(Id_Rapport_activitee),
   FOREIGN KEY(Id_Membre) REFERENCES Membre(Id_Membre),
   constraint chk_Responsabilite CHECK (Responsabilite = 'Président')
)Engine='InnoDB';
-- alter table rediger modify id_membre INT CHECK (rediger.id_membre in (select membre.id_membre from membre where responsabilite = 'Président'));

CREATE TABLE Signe(
   Id_Rapport_activitee INT,
   Id_Membre INT,
   Responsabilite VARCHAR(50),
   date_fin_signature DATE,
   PRIMARY KEY(Id_Rapport_activitee, Id_Membre),
   FOREIGN KEY(Id_Rapport_activitee) REFERENCES Rapport_activitee(Id_Rapport_activitee),
   FOREIGN KEY(Id_Membre) REFERENCES Membre(Id_Membre),
   constraint chk1_Responsabilite CHECK (Responsabilite != 'membre' and Responsabilite != 'President')
)Engine='InnoDB';

CREATE TABLE description_etat(
   Id_Rapport_activitee INT,
   Id_Etat INT,
   PRIMARY KEY(Id_Rapport_activitee, Id_Etat),
   FOREIGN KEY(Id_Rapport_activitee) REFERENCES Rapport_activitee(Id_Rapport_activitee),
   FOREIGN KEY(Id_Etat) REFERENCES Etat(Id_Etat)
)Engine='InnoDB';


CREATE TABLE Recompense(
   Id_Club INT,
   Id_Donnateur INT,
   recompense VARCHAR(150),
   date_recompense DATE,
   PRIMARY KEY(Id_Club, Id_Donnateur),
   FOREIGN KEY(Id_Club) REFERENCES Club(Id_Club),
   FOREIGN KEY(Id_Donnateur) REFERENCES Donnateur(Id_Donnateur)
)Engine='InnoDB';

CREATE TABLE Sanction(
   Id_Club INT,
   Id_Administration INT,
   sanction VARCHAR(50),
   date_sanction DATE,
   PRIMARY KEY(Id_Club, Id_Administration),
   FOREIGN KEY(Id_Club) REFERENCES Club(Id_Club),
   FOREIGN KEY(Id_Administration) REFERENCES Administration(Id_Administration)
)Engine='InnoDB';


CREATE TABLE Generer_rapport(
   Id_Club INT,
   Id_Rapport_activitee INT,
   PRIMARY KEY(Id_Club, Id_Rapport_activitee),
   FOREIGN KEY(Id_Club) REFERENCES Club(Id_Club),
   FOREIGN KEY(Id_Rapport_activitee) REFERENCES Rapport_activitee(Id_Rapport_activitee)
)Engine='InnoDB';


CREATE TABLE Donner_subvention(
   Id_Comite_organisation INT,
   Id_Sponsor INT,
   Dons INT,
   PRIMARY KEY(Id_Comite_organisation, Id_Sponsor),
   FOREIGN KEY(Id_Comite_organisation) REFERENCES Comite_organisation(Id_Comite_organisation),
   FOREIGN KEY(Id_Sponsor) REFERENCES Sponsor(Id_Sponsor)
)Engine='InnoDB';

CREATE TABLE Gerer_calendrier(
   Id_Comite_organisation INT,
   Id_Calendrier INT,
   PRIMARY KEY(Id_Comite_organisation, Id_Calendrier),
   FOREIGN KEY(Id_Comite_organisation) REFERENCES Comite_organisation(Id_Comite_organisation),
   FOREIGN KEY(Id_Calendrier) REFERENCES Calendrier(Id_Calendrier)
)Engine='InnoDB';

CREATE TABLE Membre_temporaire(
   Id_Comite_organisation INT,
   Id_Membre INT,
   Responsabilite_tmp VARCHAR(50),
   PRIMARY KEY(Id_Comite_organisation, Id_Membre),
   FOREIGN KEY(Id_Comite_organisation) REFERENCES Comite_organisation(Id_Comite_organisation),
   FOREIGN KEY(Id_Membre) REFERENCES Membre(Id_Membre)
)Engine='InnoDB';


insert into etudiant (prenom, nom, genre, classe, niveau, date_naissance) values 
   ('Antonin', 'Lampin', 'H', 'A', 2, '2001-02-02'),
   ('Simon', 'Martinenq', 'H', 'A', 1, '2001-07-25'),
   ('Paola', 'Forte', 'F', 'A', 3, '2001-10-08'), 
   ('Patrick', 'Mila', 'H', 'D', 2, '2002-08-23'), 
   ('Fred', 'Kiju', 'H', 'B', 4, '2000-03-15'), 
   ('Simon', 'Paola', 'F', 'A', 5, '2001-10-08'),
   ('Lola', 'LISI', 'F', 'D', 5, '2002-11-18'),
   ('Paul', 'MALO', 'H', 'B', 5, '2001-08-24'),
   ('Pierre', 'CAILLOU', 'H', 'A', 3, '2001-02-15'),
   ('Bruno', 'RICHO', 'H', 'C', 4, '2001-01-23'),
   ('Lucas', 'MORI', 'H', 'A', 3, '2001-09-23'),
   ('Celia', 'COMA', 'F', 'B', 3, '2001-05-21'),
   ('Mathilde', 'GUILLO', 'F', 'A', 1, '2001-06-20'),
   ('Alicia', 'HIRL', 'F', 'B', 1, '2001-11-03'),
   ('Vincent', 'CHAUM', 'H', 'C', 3, '2001-12-24'),
   ('Tom', 'TAR', 'H', 'A', 3, '2002-11-28'),
   ('Claudia', 'CESAR', 'F', 'A', 3, '2000-10-01'),
   ('Mathis', 'RUG', 'H', 'A', 2, '2001-06-30'),
   ('Romain', 'NEL', 'H', 'C',1, '2001-12-31'),
   ('Louise', 'BEAU', 'F', 'A', 4, '2001-06-14'),
   ('Alexis', 'GAL', 'H', 'B',1, '2001-10-10'),
   ('Tom', 'THAR', 'F', 'C', 2, '2001-02-02'),
   ('Arnaud', 'LET', 'H', 'D',1, '2001-04-14'),
   ('Sylvie', 'REO', 'F', 'D', 3, '2001-06-17'),
   ('Veronique', 'SANSON', 'F', 'C', 2, '2001-12-24'),
   ('Alfred', 'DUPON', 'H', 'B', 5, '2001-02-26'),
   ('Patricia', 'LOUIS', 'F', 'A', 4, '2001-08-14'),
   ('Ginette', 'STRONG', 'F', 'D', 2, '2001-11-13'),
   ('Roger', 'MOPU', 'H', 'A', 1, '2001-12-18'),
   ('Marine', 'Lopinj', 'F', 'C', 2, '2002-04-03'), 
   ('Lou', 'DUVALET', 'F', 'B', 3, '2001-01-01')
    ;

insert into club ( Nom, Date_creation, Type, Description) values 
    ('Bureau des étudiant','2010-04-12', 'evenementiel', 'Organise la vie de l école'),
    ('Efight','2020-01-02', 'sportif', 'Sport de combat'),
    ('4esport','2010-03-25', 'sportif', 'Jeux vidéos'),
    ('FAP','2012-05-05', 'humanitaire', 'Humanitaire'),
    ('Efreistyle','2011-06-01', 'sportif', 'Danse'),
    ('Continental','2019-012-03', 'evenementiel', 'Bar'),
    ('Efrei Poker','2009-009-01', 'culturel', 'Poker'),
    ('Efrei Tir','2002-08-17', 'sportif', 'Organise la vie de l école'),
    ('Make me up','2020-07-10', 'evenementiel', 'Maquillage'),
    ('Efrei chef','2019-06-04', 'evenementiel', 'Cuisine'),
    ('Live','2020-04-01', 'musical', 'Musique')
    ;


insert into MEMBRE (id_club, responsabilite, debut_affectation, fin_affectation, num_etudiant) values 
   (1, 'Président', '2021-04-12', '2021-12-12',1), 
   (2, 'Président', '2021-03-28', '2021-10-12',3), 
   (3, 'Président', '2021-03-26', '2021-11-28',5), 
   (4, 'Président', '2021-04-02', '2021-12-09',6), 
   (5, 'Président', '2021-03-11', '2021-12-12',10), 
   (6, 'Président', '2021-04-12', '2021-12-12',15), 
   (7, 'Président', '2021-02-27', '2021-12-12',16), 
   (8, 'Président', '2021-04-03', '2021-12-12',19), 
   (9, 'Président', '2021-04-16', '2021-12-12',20), 
   (10, 'Président', '2021-03-17', '2021-12-12',21), 
   (11, 'Président', '2021-03-19', '2021-12-12',30), 
   (1, 'Trésorier', '2020-02-20', '2021-04-12',2),
   (2, 'Trésorier', '2020-04-09', '2021-04-12',4),
   (3, 'Trésorier', '2020-04-12', '2021-04-12',7),
   (4, 'Trésorier', '2020-04-11', '2021-04-12',8),
   (5, 'Trésorier', '2020-01-19', '2021-04-12',9),
   (6, 'Trésorier', '2020-03-16', '2021-04-12',11),
   (7, 'Trésorier', '2020-03-14', '2021-04-12',13),
   (8, 'Trésorier', '2020-04-10', '2021-04-12',23),
   (9, 'Trésorier', '2020-03-12', '2021-04-12',29),
   (10, 'Trésorier', '2020-04-28', '2021-04-12',25),
   (11, 'Trésorier', '2020-01-29', '2021-04-12',26),
   (1, 'Vice-président', '2019-04-12', '2021-12-12',22),
   (4, 'Vice-président', '2019-02-26', '2021-12-12',12),
   (8, 'Vice-président', '2019-04-18', '2021-12-12',9),
   (10, 'Vice-président', '2019-03-10', '2021-12-12',28),
   (3, 'Membre', '2021-01-12', '2022-12-02',28),
   (3, 'Membre', '2020-02-12', '2021-03-11',24),
   (4, 'Membre', '2021-03-10', '2021-04-04',23),
   (6, 'Membre', '2020-04-12', '2021-03-10',22),
   (11, 'Membre', '2019-05-12', '2021-12-12',21),
   (8, 'Membre', '2021-06-05', '2021-08-12',4),
   (8, 'Membre', '2020-07-08', '2021-01-11',15),
   (7, 'Membre', '2020-01-10', '2021-02-11',18),
   (9, 'Membre', '2020-09-10', '2021-02-03',20),
   (2,'Membre', '2020-10-07', '2021-12-12',11),
   (1,'Secrétaire', '2020-11-10', '2021-12-12',17),
   (6, 'Secrétaire', '2021-12-04', '2022-04-12',18),
   (6, 'Responsable Tech', '2019-12-12', '2021-05-12',2),
   (1, 'Responsable Partenariats', '2021-10-12', '2021-11-12',30),
   (1, 'Responsable Communication', '2020-11-12', '2021-04-12',29),
   (3, 'Responsable Tech', '2021-11-12', '2021-03-12',25),
   (4, 'Responsable Communication', '2019-11-29', '2021-11-12',1),
   (5, 'Responsable Design', '2021-11-03', '2021-09-12',5),
   (11, 'Responsable Communication', '2021-10-29', '2021-12-12',8),
   (6, 'Responsable Communication', '2015-12-16', '2021-04-05',13);
   
INSERT INTO BUDGET (id_budget, budget) values 
	(1,1000),
	(2,NULL), 
   (3,42500), 
   (4,1050), 
   (5,NULL), 
   (6,NULL), 
   (7,200), 
   (8,2852), 
   (9,450), 
   (10,NULL),
   (11,NULL), 
   (12,658), 
   (13,123); 
    
insert into Evenement (Id_Evenement, Nom_even, Date_debut, Date_fin, Heure_debut, Heure_fin, Type_even, id_Budget) values 
	(1, 'Halloween', '2020-09-10', '2020-11-10', '20:00:00', '05:00:00', 'Soirée', 1), 
	(2, 'Week-end intégration', '2022-10-01', '2022-10-03', '06:30:00', '18:00:00', 'Soiree', 8), 
	(3, 'séjour ski', '2021-03-20', '2021-03-27', '07:00:00', '23:30:00', 'Evenementielle', 3), 
	(4, 'Presentation Majeures', '2022-02-04', '2022-02-04', '13:50:00', '14:45:00', 'Formation', 2),
	(5, 'Journée international', '2021-01-19', '2021-01-19', '08:00:00', '16:45:00', 'Langue', 6),
	(6, 'Epicerie Solidaire', '2021-04-09', '2021-04-10', '09:30:00', '20:00:00', 'associatif', 10),
	(7, 'Qualification jeu', '2020-06-10', '2020-06-17', '08:00:00', '18:00:00', 'associatif', 7), 
	(8, 'Remise de diplome', '2020-10-06', '2020-10-06', '19:00:00', '23:00:00', 'Evenementielle', 4),
	(9, 'Journée airsoft', '2020-07-10', '2020-07-15', '08:00:00', '18:00:00', 'associatif', 5), 
	(10, 'Campagne BDE', '2021-03-10', '2021-04-11', '11:30:30', '20:00:00', 'associatif', 9), 
    (11, 'Laser Game', '2022-04-11', '2021-04-11', '15:30:30', '20:00:00', 'associatif', 13), 
    (12, 'Top chefs', '2019-03-10', '2019-03-28', '10:15:00', '16:00:00', 'associatif', 12),
    (13, 'Concert de musique', '2022-04-11', '2022-04-12', '19:30:30', '05:00:00', 'associatif', 11); 

insert into organise_event (id_evenement, id_club) values 
	(1, 9),
    (2, 4),
	(2, 6),
    (2, 11),
    (3, 2),
    (3, 1), 
    (4, 1), 
    (5, 9),
    (5, 5),
    (6, 10), 
    (7, 3), 
    (7, 7), 
    (8, 1), 
    (9, 8), 
	(10, 1),
    (10, 4),
    (10,11); 

insert into Comite_organisation (Id_Comite_organisation, Date_creation, Date_dissolution, Id_Evenement) values 
   (1, '2020-08-15', '2020-11-10', 1),
   (2, '2022-07-01', '2022-10-03', 2),
   (3, '2021-01-01', '2021-01-09', 5),
   (4, '2020-05-01', '2020-06-17', 7),
   (5, '2022-07-01', '2022-10-03', 9),
   (6, '2022-07-03', '2022-07-15', 10),
   (7, '2020-11-18', '2021-03-27', 3), 
   (8, '2020-06-18', '2020-10-06', 8), 
   (9, '2019-02-05', '2019-03-28', 12), 
   (10, '2022-01-20', '2022-04-12', 13); 

insert into Membre_temporaire (Id_Comite_organisation, Id_Membre, Responsabilite_tmp) values 
    (1, 3, 'Président'),
    (1, 18, 'Secretaire'),
    (2, 6, 'Président'),
    (2, 23, 'Vice-président'),
    (2, 26, 'Trésorier'),
    (2, 18, 'Secretaire'),
    (2, 16, 'Respo. partenaria'),
    (3, 9, 'Président'),
    (3, 19, 'Trésorier'),
    (4, 20, 'Président'),
    (5, 26, 'Président'),
    (5, 1, 'Secretaire'), 
    (6, 14, 'Président'),
    (6, 13, 'Vice-président'),
    (6, 19, 'Trésorier'),
    (6, 7, 'Secretaire'),
    (7, 25, 'Président'),
    (7, 12, 'Vice-président'),
    (7, 2, 'Trésorier');
    
insert into sponsor (Id_Sponsor, Nom ) values 
	(1, 'BNB Paribas'), 
    (2, 'Crédit agricole'), 
    (3, 'Ville de villejuif'), 
    (4, 'Region Ile de France'), 
    (5, 'Dassault System'), 
    (6, 'AirFrance'), 
    (7, 'Orange cyberdéfence'), 
    (8, 'Thales'), 
    (9, 'Capgemini'), 
    (10, 'Peaugeot');

insert into donner_subvention (Id_Comite_organisation, Id_Sponsor, Dons) values 
	(1, 3, 150),
    (2, 1, 1000), 
    (2, 4, 3000),
    (2, 9, 1850),    
    (3, 4, 400),
    (4, 8, 1000),
    (4, 7, 1000),
    (5, 5, 650),
    (6, 6, 850),
    (6, 9, 1000),
    (7, 3, 500),
    (7, 2, 1000),
    (7, 1, 1000);

insert into tache (Id_Tache, libelle, montant, id_responsable) values
   (1, 'Location ordinateur', 5652, 2),
   (2, 'Reservation Bus', 1250, 12),
   (3, 'Achat maquillage', 125, 3),
   (4, 'Décoration Halloween', 50, 18),
   (5, 'Location du terrain', 2523, 23),
   (6, 'Nourriture', 2600,26),
   (7, 'Installation des salles', 0,9),
   (8, 'Acheter les places', 180,1),
   (9, 'Affiche pour la Communication', 560,7),
   (10, 'location Matériel pour les activité', 1589,19),
   (11, 'Location sono', 1265,13),
   (12, 'Location table', 200,14),
   (13, 'Location chaise', 150,15),
   (14, 'Location souris', 126,16),
   (15, 'Location verres', 50,17),
   (16, 'Location matériels gonflables', 2456,1),
   (17, 'Location appareil à gauffres', 236,3),
   (18, 'Location appareil à crêpes ', 78,4),
   (19, 'Location appareil à barbe à papa', 156,5),
   (20, 'Achat vestes floquées', 300,6),
   (21, 'Achat pulls', 420,8),
   (22, 'Achat drapeaux', 200,10);
    
insert into Responsable_tache(Id_Comite_organisation, Id_Tache) values 
   (7,1),
   (7,2),
   (1,3),
   (1,4),
   (2,5),
   (2,6),
   (3,7),
   (5,8),
   (6,9),
   (6,10),
   (7,11),
   (8,12),
   (8,13),
   (8,14),
   (9,15),
   (9,16),
   (9,17),
   (10,18),
   (10,19),
   (4,20),
   (5,21),
   (6,22);

insert into calendrier (Id_Calendrier, date_, description) values 
   (1, '2020-10-10', 'Mise en place des stands'), 
   (2, '2020-10-11', 'Rangement des stands'), 
   (3, '2022-03-20', 'Depart en bus'), 
   (4, '2022-03-23', 'Soirée ski'), 
   (5, '2021-01-19', 'Acceuil des intervenants'), 
   (6, '2021-01-19', 'Emargement des eleves'), 
   (7, '2020-10-06', 'Distribution du matériel'), 
   (8, '2020-07-15', 'Recompense des vainqueurs'),
   (9, '2021-03-29', 'Fin des candidature'), 
   (10, '2021-01-19', 'Comptage des votes');

insert into Gerer_calendrier (Id_Comite_organisation, Id_Calendrier) values 
   (1,1),
   (1,2),
   (2,3),
   (2,4),
   (4,5),
   (4,6),
   (5,7),
   (5,8),
   (6,9),
   (6,10);

insert into administration (Id_Administration, nom) values
   (1, 'EFREI'),
   (2, 'EFREI'),
   (3, 'EFREI'),
   (4, 'EFREI'),
   (5, 'EFREI'),
   (6, 'EFREI'),
   (7, 'EFREI'),
   (8, 'EFREI'),
   (9, 'EFREI'),
   (10, 'EFREI');

insert into sanction (Id_Administration, id_club, sanction, date_sanction) values
   (1, 1,'Rappel à l ordre', '2019-09-09'),
   (2, 2,'Conseil de discipline', '2020-03-16'),
   (3, 3, 'Réduire les financements', '2018-05-10'),
   (4, 4, 'Couper les financements', '2015-12-16'),
   (5, 5, 'Avertissement', '2019-06-16'),
   (6, 8, 'Rétrogradation', '2020-01-03'),
   (7, 8, 'Fermeture de l asso', '2020-03-17'),
   (8, 8, 'Amende', '2020-10-06'),
   (9, 9, 'Exclusion temporaire d un membre de l association', '2021-05-10'),
   (10, 9, 'Exclusion definitive d un membre de l association', '2022-03-16');
   
insert into donnateur (id_donnateur, Nom) values
   (1, 'EFREI'),
   (2, 'Carrefour'),
   (3, 'Thales'),
   (4, 'Safran'),
   (5, 'ESSEC'),
   (6, 'ALTEN'),
   (7, 'Boulanger'),
   (8, 'Fnac'),
   (9, 'Darty'),
   (10, 'Orange');

insert into recompense (id_donnateur, id_club, recompense, date_recompense) values
   (1,1, 'prime de 1000€', '2022-03-12'), 
   (2,6, '10 gk de taboulé orientale', '2020-12-16'), 
   (4,7,'Stage de 6 mois en tant que assistant pdg(soumis à conditions)', '2013-09-08'), 
   (5,8,'Stage de 6 mois en tant que Product manager (soumis à conditions)', '2016-10-17'), 
   (6,1,"Formations de 30h sur l'administration d'entreprise", '2020-12-16'), 
   (1,10,"Stage en régie d'une entreprise partenaire", '2020-05-16'), 
   (8,1,'PS4 et 10 mannettes', '2022-01-09'), 
   (7,3,'Télé 4k', '2019-05-07'), 
   (9,2,'Robo mixeur Magimix', '2020-12-16'), 
   (10,1,'iPhone 13 pro max', '2022-03-29');

insert into rapport_activitee (Id_Rapport_activitee, Annee) values
   (1,2020),
   (2,2020),
   (3,2020),
   (4,2021),
   (5,2021),
   (6,2020),
   (7,2020),
   (8,2020),
   (9,2020),
   (10,2020),
   (11,2020),
   (12,2020);   
   
insert into etat (id_etat, libelle, Date_debut, Date_fin) values
   (1,'en cours de création','2020-01-11', '2022-02-05'),
   (2,'en cours de création','2020-01-20', '2014-01-26'),
   (3,'en attente de signature','2020-08-23', '2020-09-28'),
   (4,'en attente de signature','2020-06-19', '2020-07-04'),
   (5,'signé','2017-05-11', '2017-05-27'), 
   (6,'soumis','2020-09-11', '2020-09-29'), 
   (7,'signé','2018-09-01', '2018-10-12'), 
   (8,'signé','2019-05-18', '2020-06-16'), 
   (9,'soumis','2010-07-11', '2010-08-12'),
   (10,'soumis','2021-06-01', '2021-07-03'), 
   (11,'en attente de signature','2022-06-09', '2022-07-13'),
   (12,'en attente de signature','2022-05-12', '2022-06-26'),
   (13,'absent','2020-01-02', '2020-01-11'),
   (14,'en attente de signature','2020-03-28', '2020-05-04'),
   (15,'en attente de signature','2021-02-25', '2021-04-27'),
   (16,'en attente de signature','2020-05-03', '2020-05-12'),
   (17,'en attente de signature','2020-03-09', '2020-04-11'),
   (18,'en attente de signature','2020-03-14', '2020-03-28'),
   (19,'en attente de signature','2020-03-15', '2020-04-12'),
   (20,'en attente de signature','2020-03-07', '2020-03-25'),
   (21,'en attente de signature','2020-04-13', '2020-05-02');

insert into description_etat (Id_Rapport_activitee, id_etat) values
   (1,1),
   (2,2),
   (3,3),
   (4,1),
   (1,4),
   (5,13),
   (6,5),
   (7,7),
   (8,8),
   (9,9),
   (10,10), 
   (11,11),
   (12,12), 
   (2,14),
   (4,15),
   (5,16),
   (6,17),
   (7,18),
   (8,19),
   (9,20),
   (10,21); 

insert into generer_rapport (id_club, Id_Rapport_activitee) values
   (1,1), 
   (2,2), 
   (3,3), 
   (4,4), 
   (5,5), 
   (6,6), 
   (7,7), 
   (8,8), 
   (9,9), 
   (10,10), 
   (11,11); 

insert into rediger (Id_Rapport_activitee, Id_Membre, responsabilite, date_fin_redact) values
   (1,1, 'President', '2020-05-06'),
   (2,2, 'President', '2020-05-04'),
   (3,3, 'Président', '2020-04-29'),
   (4,4, 'Président', '2021-04-27'),
   (5,5, 'Président', '2020-05-12'),
   (6,6, 'Président', '2020-04-11'),
   (8,7, 'Président', '2020-04-12'),
   (7,8, 'Président', '2020-03-28'),
   (10,9, 'Président', '2020-05-02'),
   (9,10, 'Président', '2020-03-25');

insert into signe (Id_Rapport_activitee, Id_Membre, responsabilite, date_fin_signature) values
   (1,12,'Trésorier', '2020-06-22'),
   (1,23,'Vice-president', NULL),
   (1,37,'Secretaire', '2020-09-29'),
   (1,40,'Responsable Partenariats', '2020-07-02'),
   (1,41,'Responsable Communication', NULL),
   (2,13,'Trésorier', '2020-07-12'),
   (3,14,'Trésorier', '2020-08-26'),
   (3,42,'Responsable Tech', '2020-09-13'),
   (4,15,'Trésorier', '2020-06-12'),
   (4,24,'Vice-president', '2020-07-19'),
   (4,42,'Responsable communication', NULL),
   (5,16,'Trésorier', '2020-06-16'),
   (5,44,'Responsable Design', '2020-06-12'),
   (6,17,'Trésorier', '2020-10-12'),
   (6,38,'Secretaire', NULL),
   (6,39,'Responsable Tech', '2020-06-12'),
   (6,46,'Responsable Communication', NULL),
   (7,18,'Trésorier', '2020-08-09'),
   (8,19,'Trésorier', '2020-08-17'),
   (8,25,'Vice-president', '2020-08-31'),
   (9,20,'Trésorier', '2020-05-10'),
   (10,21,'Trésorier', NULL),
   (10,26,'Vice-president', '2020-06-12'),
   (11,22,'Trésorier', NULL),
   (11,45,'Responsable Communication', '2020-06-12');


select * from etudiant; 
select * from membre; 
select * from club; 
select * from evenement; 
select * from organise_event; 