--base
create database garage;

\c garage
--table 
    -- diplome
        create table diplome(
            idDiplome serial primary key,
            diplome VARCHAR(20)
        );

    --genre
        create table genre(
            idGenre serial primary key,
            genre VARCHAR(5)
        );
    
    --Specialite
        create table specialite(
            idSpecialite serial primary key,
            type VARCHAR(30),
            salaire double precision
        );
    --Service
        create table service(
            idService serial primary key,
            nom VARCHAR(30)
        );
    --Materiel
        create table materiel(
            idMateriel serial primary key,
            nom VARCHAR(30),
            unite VARCHAR(20),
            prix double precision
        );
    --Employe
        create table employee(
            idEmploye VARCHAR(7) primary key,
            nom VARCHAR(20),
            prenom VARCHAR(30),
            dateDeNaissance DATE,
            idGenre int,
            idDiplome int,
            foreign key (idGenre) references genre(idGenre),
            foreign key (idDiplome) references diplome(idDiplome)
        );
    --specialite employe 
    create table employeespecialite(
        idSpecialite int,
        idEmploye VARCHAR(7),
        foreign key (idSpecialite) references specialite(idSpecialite),
        foreign key (idEmploye) references employe(idEmploye)
    );
    --services specialite
        create table servicespecialite(
            idService int,
            idSpecialite int,
            duree double precision,
            foreign key (idService) references service(idService),
            foreign key (idSpecialite) references specialite(idSpecialite)
        );
    -- servicemateriel 
        create table servicemateriel(
            idService int,
            idMateriel int,
            quantite double precision,
            foreign key (idService) references service(idService),
            foreign key (idMateriel) references materiel(idMateriel)
        );
    
    --
    
-- view
    --join table service avec specialite et service-specialite
    create view as ServSpec
    select tab1.idSpecialite idSpecialite ,tab1.idType NomSpecialite ,tab1.salaire salaire,  tab2.idService idService, tab3.nom NomService, tab2.duree Duree
        from specialite as tab1
        join servicespecialite as tab2 on tab1.idSpecialite=tab2.idSpecialite
        join service as tab3 on tab2.idService=tab3.idService

    --join table service avec materiel et service-materiel
    create view ServiceMateriels
    select tab1.idMateriel idMateriel ,tab1.nom nomMateriel,tab1.unite Unite, tab1.prix Prix,tab2.idService idService,tab3.nom nomService,tab2.duree duree
        from materiel as tab1
        join servicemateriel as tab2 on tab1.idMateriel=tab2.idMateriel
        join service as tab3 as tab2.idService=tab3.idService
--sequence
        --employe
        CREATE SEQUENCE seqEmploye
        INCREMENT BY 4;
--function
        --take the next sequence
        create function getseqEmploye()
        returns int 
        language plpgsql
        as 
        $$
        declare
            idEmp integer;
        begin
            select nextVal('seqEmploye') into idEmp from seqEmploye;
            
            return idEmp;
        end;
        $$;
--donnees
    --diplome
    insert into diplome values
    (default,'BEPC'),
    (default,'BACC'),
    (default,'BACC +2'),
    (default,'LICENCE'),
    (default,'MASTER');
    --genre
    insert into genre values
    (default,'Homme'),
    (default,'Femme');

    --specialite
    insert into specialite values
    (default,'Vidange',2000),
    (default,'Carrosserie',3200),
    (default,'Changement de piece',3000),
    (default,'Peinture',2200),
    (default,'Vente pieces',3100);
    
    --service
    insert into service values
    (default,'Vidange'),
    (default,'Carrosserie'),
    (default,'Peinture');

    --materiel
    insert into materiel values
    (default,"huile","litre",300),
    (default,"peinture","litre",250),
    (default,"parchoc","kilogramme",160);

    --employe
    insert into employee values
    ('EMP0001','Rabe','Richard',to_date('2001-12-21','YYYY-MM-DD'),1,4),
    ('EMP0002','Rasoa','Koto Kely',to_date('1997-08-11','YYYY-MM-DD'),1,5),
    ('EMP0003','Randria','Bema',to_date('1996-05-03','YYYY-MM-DD'),2,4);

    --employe specialite
    insert into employeespecialite values
    (3,'EMP0001'),
    (1,'EMP0002'),
    (4,'EMP0003');

    --service specialite
    insert into servicespecialite values
    (1,1,2.5),
    (2,2,1.5),
    (3,3,2);

    insert into servicemateriel values
    (1,1,3),
    (2,3,0.5),
    (3,2,2.5);

