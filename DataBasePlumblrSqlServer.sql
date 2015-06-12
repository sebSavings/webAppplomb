
----------------------------------------------
--				DOT  P L U M B L R			--
----------------------------------------------
--
-- database and tables creation script

-- database creation
use master
go

if exists (select * from sysdatabases where name='webAppplomb')
drop database webAppplomb
go

create database webAppplomb
go


-- Set DATEFORMAT so that the date strings are interpreted correctly regardless of
-- the default DATEFORMAT on the server.
set dateformat ymd
go
												--cd Logiciels/JMerise 
use "webAppplomb"									--java -jar JMerise.jar
go


-- specific database types settings
create type title 		from nvarchar(100)	--libellé // ex itemDefaultName, supplierNaming, toolName, privateNaming
go
create type code 		from nvarchar(25) --code article (item) // not already used
go
create type shortword 	from nvarchar(25)  --pour les chaines courtes // not already used
go
create type longword 	from nvarchar(50)  --pour les chaines moyennes ex : itemClass, site & supplierName, site & supplierTown, contactName(s), toolStoragePlace, employee Surname & FirstName,
go 										   --	
create type sentence 	from nvarchar(100) --pour les chaines longues
go
--create type text 		from nvarchar(250) -- pour les commentaires

go
create type courtesy 	from nvarchar(15)  --pour le titre de civilité."  	--'M.', 'Me.', 'Mme.', 'Mlle.', 'Dr.', ...
go
create type zipcode 	from nvarchar(5) 	-- '02000', foreign zip codes 
go
create type phone 		from nvarchar(14) 	-- 'xx xx xx xx xx' 
go

create type login 		from nvarchar(20)
go
create type password 	from nvarchar(15)
go

create type primary_id 	from int not null 
go	
create type foreign_id 	from int not null
go

create type boolean 	from bit
go

--1
create table item 	--article
	(item_id 			primary_id
	,constraint pk_item primary key (item_id)

	,item_defaultName	title --title type = libellé		-- nom par défaut
	,item_class			longword 	-- catégorie raccord cuivre, raccord gaz Cu, raccord gaz Fe, fixation,  
--	,item_pic			blob		-- image

	)
	go
--2
create table supplier -- fournisseur
	(supplier_id 		primary_id identity(1,1)
	,constraint pk_supplier primary key (supplier_id)

	,supplier_name		longword
	,supplier_adress	sentence
	,supplier_zipcode	zipcode
	,supplier_town		longword

	,supplier_phone		phone
	,supplier_fax		phone
	,supplier_www		sentence
	
	,supplier_contactName		longword
	,supplier_contactCourtesy 	courtesy
	,supplier_contactPhone		phone

	) 
	go

--3
create table toReferenceItem
	(toReferenceItem_id 	primary_id identity(1,1)
	,constraint pk_toReference primary key (toReferenceItem_id)

	,supplierNaming 		title --title type = libellé
	,supplierReferencing 	nvarchar(25) --code article (item)
	,supplierMeasUnit 		nvarchar(25)  /*pour les chaines courtes check (orderline_measUnit in ('mètre(s)' 'unité(s)' 'kg' 'boîtes' '...'))*/
	
	,supplier_id 			int not null
	,constraint fk_Toref_supplier foreign key (supplier_id)
	 references supplier(supplier_id)

	,item_id 				int not null
	,constraint fk_Toref_item foreign key (item_id)
	 references item(item_id)

	) 
	go

--4
create table tool		-- outillage (set of tools, equipement)
	(tool_id			primary_id identity(1,1)
	,constraint pk_tool primary key (tool_id)

	,tool_name			title --title type = libellé		--nom
	,tool_label			nvarchar(25)  /*pour les chaines courtes*/	--marque
	,tool_storagePlace	longword	--lieu de rangement
--	,tool_availability	bool		--disponibilité calculable avec les dates 
	,tool_state			nvarchar(25)  /*pour les chaines courtes*/	--état (neuf, un peu usé, usé, mauvais état, pret à rendre l'ame, dangereux...)

	)
	go
--5
create table employee
	(employee_id		primary_id identity(1,1)
	,constraint pk_employee primary key (employee_id)

--	,responsible_id		int not null									-- à répercuter dans la table de relation reflexive responsable de ie beResponsibleOf
--	,foreign key (responsible_id) references employee(employee_id)

	,employee_courtesy 	courtesy 	--civilité
	,employee_surname 	longword	--nom
	,employee_firstName	longword	--prénom
--	,employee_adress 	longword	--adresse (numero etrue)
--	,employee_town		longword	--ville/commune
--	,employee_zipcode	zipcode 	--code postal
	,employee_cellphone	phone 	--mobile
--	,employe_homephone	phone 	--fixe
	,employee_proMail	longword	--adresse mail

	,employee_leader 	boolean			--cadre
	,employee_grants	nvarchar(25)   /*pour les chaines courtes*/	--droits d'acces système
	,employee_login		login 	--nom utilisateur
	,employee_password	password 	--code d'accès

	)
	go

--6
create table toNameItem  	-- nommer 
	(toNameItem_id	primary_id identity(1,1)
	, constraint pk_toNameItem primary key (toNameItem_id)

	,privateNaming	title --title type = libellé

	,item_id 		int not null
	,constraint fk_toName_item foreign key (item_id)
	 references item(item_id)

	,employee_id 	int not null
	,constraint fk_toName_employee foreign key (employee_id)
	 references employee(employee_id)

	)
	go
--7
create table toLead 
	(toLead_id 	primary_id identity(1,1)
	,constraint pk_lead primary key(toLead_id)

	,fellow_id	foreign_id
	,constraint fk_lead_fellow foreign key (fellow_id) 
	 references employee(employee_id)

	,master_id 	foreign_id
	,constraint fk_lead_master foreign key (master_id) 
	 references employee(employee_id)
	)
	go

--8
create table site
	(site_id		primary_id identity(1,1) 	-- l'entreprise correspond au site 000000000000
	,constraint pk_site primary key (site_id)

	,site_viewable		boolean

	,site_name			longword
	,site_adress		sentence
	,site_town			longword
	,site_zipcode		zipcode

	,site_startDate		date
	,site_endDate		date
	,site_recordDate	date 	-- date de clotûre

	,site_travelTime	nvarchar(25)   /*pour les chaines courtes*/ -- ou int ou timestamp
	,site_km			int
	,site_area			nvarchar (25) -- zone

	,site_contactCourtesy 	courtesy
	,site_contactName		longword
	,site_contactPhone		phone
	
	,site_customerName		longword
	
	,site_shell				longword 	-- gros oeuvre
	,site_masterCourtesy 	courtesy
	,site_shellMasterName	longword
	,site_masterPhone		longword

	,site_architectCourtesy courtesy
	,site_architectName		longword
	,site_architectPhone	phone

	) 
	go
--9
create table batch 	-- = lot la traduction la plus approppriée serait "item" mais serait porteuse de confusion avec les items d'une commande
	(batch_id		primary_id identity(1,1)	
	,constraint pk_batch primary key (batch_id)
	
	,batch_number 	shortword   not null -- le site global correspond au batch_number = 00
	,batch_field	shortword  /*pour les chaines courtes*/	-- plomberie ou gaz par exemple // le site correspond batch "global" ou 
								-- "ensmble" ou "total" ou "aggregate" ...  à définir
	,site_id 		foreign_id
	,constraint fk_batch_site foreign key (site_id) 
	 references site(site_id)

	) 
	go

--10
create table toWorkOnBatch
	(workOn_id		primary_id identity(1,1)
	,constraint pk_workOn primary key(workOn_id)

	,workStartDate 	date
	,workEndDate 	date

	,asSupervisor 	boolean
	,asDriver 		boolean

	,worker_id 		foreign_id
	,constraint fk_toW_worker foreign key (worker_id) 
	 references employee(employee_id)

	,batch_id 		foreign_id
	,constraint fk_toW_batch foreign key (batch_id) 
	 references batch(batch_id)

	) 
	go

--11
create table listHead 		-- mémoListe
	(list_id		primary_id identity(1,1)
	,constraint pk_list primary key (list_id)

	,list_comment		sentence
	,list_status		nvarchar(25)  /*pour les chaines courtes check (list_status in ( 'envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée' ))*/
						-- ou 	enum ('envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée')
						-- le status peut être calculé avec listLine_quantity et provided
	,list_emailingDate		date
	,list_receiptDate		date
	,list_packingEndDate	date

	,provider_id		foreign_id	--préparateur
	,constraint fk_list_provider foreign key (provider_id) 
	 references employee(employee_id)

	,sender_id			foreign_id
	,constraint fk_list_sender foreign key (sender_id) 
	 references employee(employee_id)

	,batch_id			foreign_id
	,constraint fk_list_batch foreign key (batch_id) 
	 references batch(batch_id)

	) 
	go

--12
create table listLine	-- item de ligne
	(line_id		primary_id identity(1,1)
	,constraint pk_listLine primary key (line_id)

	,measUnit	nvarchar(25)  /*pour les chaines courtes check (listline_measUnit in ('mètre(s)' 'unité(s)' 'kg' 'boîtes' '...'))*/
	,quantity	int
	,prov_ided	int

	,list_id 		foreign_id
	,constraint fk_list foreign key (list_id) 
	 references listHead(list_id)

	,item_id		foreign_id
	,constraint fk_itemList foreign key (item_id)
	 references item(item_id)

	) 
	go

--13
create table toBookTool		--réserver
	(toBookTool_id		primary_id identity(1,1)
	,constraint pk_toBook primary key (toBookTool_id)	

	,bookingDate		date
	,bookReturnDate		date

	,tool_id			foreign_id
	,constraint fk_Book_tool foreign key(tool_id) 
	 references tool(tool_id)

	,list_id 			foreign_id
	,constraint fk_Book_list foreign key (list_id)
	 references listHead(list_id)

	) 
	go

--14
create table orderHead 		-- order
	(order_id			primary_id identity(1,1)
	,constraint pk_order primary key (order_id)

	,order_creationDate	date
	,order_sendDate		date

	,order_delivPlace	longword
	,order_comment		sentence -- or text
--	,order_status		nvarchar(25)go  /*pour les chaines courtes*/ check (order_status in ( 'envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée' ))
				-- ou 	enum ('envoyée', 'réceptionnée', 'complète', 'partielle', 'refusée')
				-- le status peut être calculé avec orderLine_quantity et provided
	,sender_id	foreign_id	-- rédacteur / resp de la commande
	,constraint pk_order_sender foreign key (sender_id)
	 references employee(employee_id)

	,batch_id 	foreign_id
	,constraint fk_order_batch foreign key (batch_id)
	 references batch (batch_id)

	,supplier_id 	foreign_id
	,constraint fk_order_supplier foreign key (supplier_id)
	 references supplier(supplier_id)

	) 
	go
--15
create table orderLine	-- item de ligne
	(orderLine_id		primary_id identity(1,1)
	,constraint pk_orderLine primary key (orderLine_id)

	,measUnit		nvarchar(25)  /*pour les chaines courtes* check (orderline_measUnit in ('mètre(s)' 'unité(s)' 'kg' 'boîtes' '...'))*/
	,quantity		int
	,provided		int

	,order_id 			foreign_id
	,constraint  fk_order foreign key (order_id)
	 references orderHead(order_id)

	,item_id			foreign_id
	,constraint fk_itemOrder foreign key (item_id)
	 references item(item_id)

	) 
	go


