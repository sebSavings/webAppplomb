/*
DataBase Plumblr creation


create database Plumblr;


create type title 		from nvarchar(100);	-- libellé
create type code 		from nvarchar(25); -- code article (item)

create type shortword 	from nvarchar(25);  -- pour les chaines courtes
create type longword 	from nvarchar(50);  -- pour les chaines moyennes
create type sentence 	from nvarchar(100); -- pour les chaines longues

create type courtesy 	from nvarchar(15);  -- pour le titre de civilité."  	-- 'M.', 'Me.', 'Mme.', 'Mlle.', 'Dr.', ...

create type zipcode 	from nvarchar(5); 	--  '02000', foreign zip codes 

create type phone 		from nvarchar(14); 	--  'xx xx xx xx xx' 	

create type login 		from nvarchar(20);
create type password 	from nvarchar(15);

create type primary_id 	from int (10)  auto_increment; 
create type foreign_id 	from int (10) not null;
*/

-- 1
create table item 	-- article
	(item_id 			int (10)  auto_increment
	,primary key (item_id)

	,item_defaultName	nvarchar(100) -- title type = libellé		--  nom par défaut
	,item_class			nvarchar(50) 	--  catégorie raccord cuivre, raccord gaz Cu, raccord gaz Fe, fixation,  
	,item_pic			blob		--  image

	)engine=innodb, charset=utf8
	;
-- 2
create table supplier --  fournisseur
	(supplier_id 		int (10)  auto_increment
	,primary key (supplier_id)

	,supplier_name		nvarchar(50)
	,supplier_adress	nvarchar(50)

	,supplier_town		nvarchar(50)
	,supplier_phone		nvarchar(14)
	,supplier_fax		nvarchar(14)
	,supplier_www		nvarchar(50)
	
	,supplier_contactName		nvarchar(50)
	,supplier_contactCourtesy 	nvarchar(15)
	,supplier_contactPhone		nvarchar(14)

	)engine = innodb, charset = utf8
	;

-- 3
create table toReferenceItem
	(toReferenceItem_id 	int (10)  auto_increment
	,primary key (toReferenceItem_id)

	,supplierNaming 		nvarchar(100) -- title type = libellé
	,supplierReferencing 	nvarchar(25) -- code article (item)
	,supplierMeasUnit 		nvarchar(25)  /*pour les chaines courtes check (orderline_measUnit in ('mètre(s)' 'unité(s)' 'kg' 'boîtes' '...'))*/
	
	,supplier_id 			int (10) not null
	,foreign key (supplier_id) references supplier(supplier_id)

	,item_id 				int (10) not null
	,foreign key (item_id) references item(item_id)

	)engine = innodb, charset = utf8
	;

-- 4
create table tool		--  outillage (set of tools, equipement)
	(tool_id			int (10)  auto_increment
	,primary key (tool_id)

	,tool_name			nvarchar(100) -- title type = libellé		-- nom
	,tool_label			nvarchar(25)  /*pour les chaines courtes*/	-- marque
	,tool_storagePlace	nvarchar(50)	-- lieu de rangement
-- 	,tool_availability	bool		-- disponibilité calculable avec les dates 
	,tool_state			nvarchar(25)  /*pour les chaines courtes*/	-- état (neuf, un peu usé, usé, mauvais état, pret à rendre l'ame, dangereux...)

	)engine=innodb, charset=utf8
	;
-- 5
create table employee
	(employee_id		int (10)  auto_increment
	,primary key (employee_id)

-- 	,responsible_id		int (10) not null									--  à répercuter dans la table de relation reflexive responsable de ie beResponsibleOf
-- 	,foreign key (responsible_id) references employee(employee_id)

	,employee_courtesy 	nvarchar(15) 	-- civilité
	,employee_surname 	nvarchar(50)	-- nom
	,employee_firstName	nvarchar(50)	-- prénom
-- 	,employee_adress 	nvarchar(50)	-- adresse (numero etrue)
-- 	,employee_town		nvarchar(50)	-- ville/commune
-- 	,employee_zipcode	nvarchar(5) 	-- code postal
	,employee_cellphone	nvarchar(14) 	-- mobile
-- 	,employe_homephone	nvarchar(14) 	-- fixe
	,employee_proMail	nvarchar(50)	-- adresse mail

	,employee_leader 	boolean			-- cadre
	,employee_grants	nvarchar(25)   /*pour les chaines courtes*/	-- droits d'acces système
	,employee_login		nvarchar(20) 	-- nom utilisateur
	,employee_password	nvarchar(15) 	-- code d'accès

	)engine=innodb, charset=utf8
	;

-- 6
create table toNameItem  	--  nommer 
	(toNameItem_id	int (10)  auto_increment
	,primary key (toNameItem_id)

	,privateNaming	nvarchar(100) -- title type = libellé

	,item_id 		int (10) not null
	,foreign key(item_id) references item(item_id)

	,employee_id 	int (10) not null
	,foreign key(employee_id) references employee(employee_id)

	)engine=innodb, charset=utf8
	;
-- 7
create table toLead
	(toLead_id 	int (10)  auto_increment
	,primary key(toLead_id)

	,fellow_id	int (10) not null
	,foreign key (fellow_id) references employee(employee_id)

	,master_id 	int (10) not null
	,foreign key (master_id) references employee(employee_id)

	)engine=innodb, charset=utf8
	;

-- 8
create table site
	(site_id		int (10)  auto_increment 	--  l'entreprise correspond au site 000000000000
	,primary key (site_id)

	,site_viewable		boolean

	,site_name			nvarchar(50)
	,site_adress		nvarchar(50)
	,site_town			nvarchar(50)
	,site_zipcode		nvarchar(5)

	,site_startDate		date
	,site_endDate		date
	,site_recordDate	date 	--  date de clotûre

	,site_travelTime	nvarchar(25)   /*pour les chaines courtes*/ --  ou int ou timestamp
	,site_km			int
	,site_area			nvarchar (25) --  zone

	,site_contactCourtesy 	nvarchar(15)
	,site_contactName		nvarchar(50)
	,site_contactPhone		nvarchar(14)
	
	,site_customer			nvarchar(50)
	
	,site_shell				nvarchar(50) 	--  gros oeuvre
	,site_masterCourtesy 	nvarchar(15)
	,site_shellMasterName	nvarchar(50)
	,site_masterPhone		nvarchar(50)

	,site_architectCourtesy nvarchar(15)
	,site_architectName		nvarchar(50)
	,site_architectPhone	nvarchar(14)

	)engine = innodb, charset = utf8
	;
-- 9
create table batch 	--  = lot la traduction la plus approppriée serait "item" mais serait porteuse de confusion avec les items d'une commande
	(batch_id		int (10)  auto_increment	
	,primary key (batch_id)
	
	,batch_number 	int(2)   not null --  le site global correspond au batch_number = 00
	,batch_field	nvarchar(25)  /*pour les chaines courtes*/	--  plomberie ou gaz par exemple // le site correspond batch "global" ou 
								--  "ensmble" ou "total" ou "aggregate" ...  à définir
	,site_id 		int (10) not null
	,foreign key (site_id) references site(site_id)

	)engine = innodb, charset = utf8
	;

-- 10
create table toWorkOnBatch
	(workOn_id		int (10)  auto_increment
	,primary key(workOn_id)

	,workStartDate 	date
	,workEndDate 	date

	,asSupervisor 	boolean
	,asDriver 		boolean

	,worker_id 		int (10) not null
	,foreign key (worker_id) references employee(employee_id)

	,batch_id 		int (10) not null
	,foreign key (batch_id) references batch(batch_id)

	)engine = innodb, charset = utf8
	;

-- 11
create table listHead 		--  mémoListe
	(list_id		int (10)  auto_increment
	,primary key (list_id)

	,list_comment		nvarchar(200)
	,list_status		nvarchar(25)  /*pour les chaines courtes check (list_status in ( 'envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée' ))*/
						--  ou 	enum ('envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée')
						--  le status peut être calculé avec listLine_quantity et prov_ided
	,list_emailingDate		date
	,list_dateOfReceipt		date
	,list_datePackingEnd	date

	,provider_id		int (10) not null	-- préparateur
	,foreign key (provider_id) references employee(employee_id)

	,sender_id			int (10) not null
	,foreign key (sender_id) references employee(employee_id)

	,batch_id			int (10) not null
	,foreign key (batch_id) references batch(batch_id)

	)engine = innodb, charset = utf8
	;

-- 12
create table listLine	--  item de ligne
	(listLine_id		int (10)  auto_increment
	,primary key (listLine_id)

	,measUnit			nvarchar(25)  /*pour les chaines courtes check (listline_measUnit in ('mètre(s)' 'unité(s)' 'kg' 'boîtes' '...'))*/
	,quantity			int
	,provided			int

	,list_id 			int (10) not null
	,foreign key (list_id) references listHead(list_id)

	,item_id			int (10) not null
	,foreign key (item_id) references item(item_id)

	)engine = innodb, charset = utf8
	;

-- 13
create table toBookTool		-- réserver
	(toBookTool_id		int (10)  auto_increment
	,primary key (toBookTool_id)	

	,bookingDate		date
	,bookReturnDate		date

	,tool_id			int (10) not null
	,foreign key(tool_id) references tool(tool_id)

	,list_id 			int (10) not null
	,foreign key (list_id) references listHead(list_id)

	)engine = innodb, charset = utf8
	;

-- 14
create table orderHead 		--  order
	(order_id			int (10)  auto_increment
	,primary key (order_id)

	,order_creationDate	date
	,order_sendDate		date

	,order_delivPlace	nvarchar(50)
	,order_comment		nvarchar(200)
-- 	,order_status		nvarchar(25);  /*pour les chaines courtes*/ check (order_status in ( 'envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée' ))
				--  ou 	enum ('envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée')
				--  le status peut être calculé avec orderLine_quantity et prov_ided
	,sender_id	int (10) not null	--  rédacteur / resp de la commande
	,foreign key (sender_id) references employee(employee_id)

	,batch_id 	int (10) not null
	,foreign key (batch_id) references batch (batch_id)

	,supplier_id 	int (10) not null
	,foreign key (supplier_id) references supplier(supplier_id)

	)engine = innodb, charset = utf8
	;
-- 15
create table orderLine	--  item de ligne
	(orderLine_id	int (10)  auto_increment
	,primary key (orderLine_id)

	,measUnit		nvarchar(25)  /*pour les chaines courtes* check (orderline_measUnit in ('mètre(s)' 'unité(s)' 'kg' 'boîtes' '...'))*/
	,quantity		int
	,provided		int

	,order_id 		int (10) not null
	,foreign key (order_id) references orderHead(order_id)

	,item_id		int (10) not null
	,foreign key (item_id) references item(item_id)

	)engine = innodb, charset = utf8
	;

