use pet_store;

insert into street(street_id,street_name)
values 
	(100,"Bialik"),(101,"Rotchild"),(102,"Zait"),(103,"Balfur"),(104,"Aluf Sade"),(105,"Kalisher"),(106,"Salant"),(107,"Vingate"),(108,"Vered");

insert into city(city_id,city_name)
values 
	(1,"Tel Aviv"),(2,"Petah Tikva"),(3,"Ramat Gan"),(4,"Givatayim"),(5,"Netanaya"),(6,"Bat Yam"),(7,"Eilat"),(8,"Kfar Saba"),(9,"Raanana");
    
    
insert into address(address_id,city_id,street_id,street_num)
values
	(1,1,100,29),(2,1,101,4),(3,2,103,89),(4,2,105,5),(5,3,107,54),(6,4,108,10),(7,5,104,65),(8,5,102,44),(9,7,103,2),(10,9,107,132),(11,9,104,32),(12,4,102,24),(13,9,101,22),(14,5,103,43),(15,7,106,1),(16,1,102,54),(17,1,102,52),(18,1,103,82),(19,2,101,3),(20,5,103,42),(21,5,103,3),(22,2,101,99),(23,9,106,87);
    
insert into store_role(role_id,role_name)
values 
	(1,"cashier"),(2,"storage_keeper"),(3,"delivery_guy");
    
insert into person(person_id,p_name,p_address,p_phone) 
values
	(1000,"Shlomi",1,'0501111111'),(1001,"Ruth",2,'0522222222'),(1002,"Narkis",3,'0533333333'),(1003,"Avraham",4,'0544444444'),(1004,"Ben",5,'0555555555'),(1005,"Ofek",6,'0566666666'),(1006,"Daniel",7,'0577777777'),(1007,"Shaul",8,'0588888888'),(1008,"Gefen",9,'0599999999'),(1009,"Rami",10,'0502111111'),(1010,"Aviv",11,'0502131111'),(1011,"Itay",12,'0505844452'),(1012,"Gadi",12,'0545532158'),(1013,"Sapir",13,'0529874111'),(1014,"Ofra",14,'0521234111'),(1015,"Shir",15,'0535274157'),(1016,"Mary",16,'0529874297'),(1017,"Roy",17,'0526854321'),(1018,"Yarden",18,'0523854391'),(1019,"Tomer",19,'0542222911'),(1020,"Barak",20,'0521234567'),(1021,"Zippi",21,'0551472583'),(1022,"Tanya",22,'0523692585'),(1023,"Emanuel",23,'0585478659'),(1024,"Vera",24,'0500045236');
    
insert into family_kind(family_id,family_name) 
values
	(1,"Dog"),(2,"Cat"),(3,"Rabbit"),(4,"Parrot"),(5,"Chameleon"),(6,"Fish"),(7,"Iguana"),(8,"Hamster");
    
insert into pet_kind(pet_id,family_id,kind_name)
values
	(60,1,"Labrador"),(61,1,"Border Collie"),(62,1,"Poodle"),(63,2,"Siamese"),(64,2,"Persian"),(65,3,"Netherland Dwarf"),(66,3,"American Fuzzy Lop"),(67,4,"African Grey"),(68,4,"Cockatoos"),(69,5,"Panther"),(70,5,"Veiled"),(71,6,"Golden"),(72,6,"Salmon"),(73,7,"Green"),(74,7,"Cuban Rock"),(75,8,"Dwarf Roborovski"),(76,8,"Campbell’s Dwarf Russian");
    
insert into pet(pet_id,pet_name,pet_kind,pet_age)
values
	(200,"Rexi",60,2),(201,"Pitzi",63,5),(202,"Snow",61,6),(203,"Sasha",64,6),(204,"Gezer",65,4),(205,"Sprarrow",67,4),(206,"Lizzi",69,3),(207,"Nemo",71,2),(208,"Iggy",73,6),(209,"Hamtaro",76,1),(210,"Tiny",6,72);
    
insert into customer(customer_id,person_id,pet_id)
values
	(10000,1000,200),(10001,1001,201),(10002,1002,202),(10003,1003,203),(10004,1004,204),(10005,1005,205),(10006,1012,206),(10007,1013,207),(10008,1014,208),(10009,1015,209),(10010,1019,210);
    
insert into crew(member_id,role_id,person_id)
values
	(80,1,1006),(81,2,1018),(82,3,1007),(83,2,1008),(84,1,1009),(85,1,1010),(86,1,1010),(87,1,1011),(88,3,1016),(89,1,1017),(90,1,1018);
    
insert into category (category_id,category_name)
values
	(1,"toys"),(2,"food"),(3,"beds"),(4,"cages");
    
insert into product (product_id,product_name,category,price,amount)
values
	(150,"Dogly",2,150,20),(151,"Brown Bone",1,30,10),(152,"Comfort Bed",3,250,5),(153,"Big Black Cage",4,400,6),(154,"Golden prestigious Cage",4,800,2),(155,"Catly",2,80,15),(156,"Carrot",2,10,59),(157,"Lettuce",2,10,40),(158,"Lazer",1,50,6),(159,"Ball Of String",1,30,7);
    
insert into delivery (delivery_id,member_id,order_date,delivery_price)
values
	(500,82,"2022-02-06",50),(501,82,"2022-01-04",40),(502,82,"2021-11-20",10),(503,82,"2022-02-20",50),(504,88,"2022-02-21",50),(505,88,"2022-02-20",10),(506,88,"2021-12-20",15),(507,88,"2020-02-28",5),(508,82,"2022-05-30",40),(509,88,"2022-04-20",45);
    
insert into store_order (order_id,customer_id,member_id,delivery,order_date)
values
	(6000,10000,80,500,"2022-02-06"),(6001,10001,81,501,"2022-07-06"),(6002,10002,82,502,"2022-07-24"),(6003,10004,80,503,"2022-07-25"),(6004,10004,80,504,"2022-07-25");

insert into store_order (order_id,customer_id,member_id,order_date)
values   
    (6005,10000,80,"2022-07-25"),(6006,10000,84,"2022-07-25"),(6007,10005,85,"2022-07-25"),(6008,10003,85,"2022-07-27"),(6009,10002,84,"2022-07-31");
    
insert into order_products (order_id,product_id,product_amount)
values  
	(6000,150,5),(6001,151,2),(6002,152,1),(6003,153,1),(6004,154,1),(6005,155,6),(6006,156,15),(6007,157,2),(6008,158,2),(6009,159,3),(6010,151,1),(6010,150,1),(6010,152,1),(6000,151,2),(6001,155,2);