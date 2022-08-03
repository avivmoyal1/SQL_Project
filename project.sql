-- Create table ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE DATABASE pet_store;

USE pet_store;

CREATE TABLE store_role(
	role_id int NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(100),
	PRIMARY KEY(role_id)
);

CREATE TABLE street(
	street_id INT NOT NULL AUTO_INCREMENT,
    street_name VARCHAR(100),
    PRIMARY KEY(street_id)
);

CREATE TABLE city(
	city_id INT NOT NULL AUTO_INCREMENT,
    city_name VARCHAR(100),
    PRIMARY KEY(city_id)
);

CREATE TABLE address(
	address_id INT NOT NULL AUTO_INCREMENT,
    city_id INT,
    street_id INT,
    street_num INT,
    PRIMARY KEY(address_id),
    FOREIGN KEY(city_id) REFERENCES city(city_id),
    FOREIGN KEY(street_id) REFERENCES street(street_id)
);

CREATE TABLE person(
	person_id INT NOT NULL AUTO_INCREMENT,
    p_name VARCHAR(100),
    p_address INT,
    p_phone varchar(20),
    PRIMARY KEY(person_id),
    FOREIGN KEY(p_address) REFERENCES address(address_id)
);

CREATE TABLE family_kind(
	family_id INT NOT NULL AUTO_INCREMENT,
    family_name VARCHAR(100),
    PRIMARY KEY(family_id)
);

CREATE TABLE pet_kind(
	pet_id INT NOT NULL AUTO_INCREMENT,
    family_id INT,
    kind_name VARCHAR(100),
    PRIMARY KEY(pet_id),
    FOREIGN KEY(family_id) REFERENCES family_kind(family_id)
);

CREATE TABLE pet(
	pet_id INT NOT NULL AUTO_INCREMENT,
    pet_name VARCHAR(100),
    pet_kind INT,
    pet_age INT,
    PRIMARY KEY(pet_id),
    FOREIGN KEY(pet_kind) REFERENCES pet_kind(pet_id)
);

CREATE TABLE customer(
	customer_id INT NOT NULL AUTO_INCREMENT,
    person_id INT,
    pet_id INT,
    PRIMARY KEY(customer_id),
    FOREIGN KEY(person_id) REFERENCES person(person_id),
	FOREIGN KEY(pet_id) REFERENCES pet(pet_id)
);


create table crew(
	member_id INT NOT NULL AUTO_INCREMENT,
    role_id INT,
    person_id INT,
    PRIMARY KEY(member_id),
    FOREIGN KEY(role_id) REFERENCES store_role(role_id),
    FOREIGN KEY(person_id) REFERENCES person(person_id)
);

CREATE TABLE category(
	category_id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100),
	PRIMARY KEY(category_id)
);

create table product(
	product_id INT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(100),
    category INT,
    price INT,
    amount INT,
    PRIMARY KEY(product_id),
    FOREIGN KEY(category) REFERENCES category(category_id)
);

CREATE TABLE inventory_changes(
	-- num INT NOT NULL AUTO_INCREMENT,
	member_id INT,
    product_id INT, 
    product_amount INT,    
    change_date DATE,
    PRIMARY KEY(product_id,product_amount,member_id,change_date),
    FOREIGN KEY(product_id) REFERENCES product(product_id),
    FOREIGN KEY(member_id) REFERENCES crew(member_id)
);

create table delivery(
	delivery_id INT NOT NULL AUTO_INCREMENT,
    member_id INT,
    delivery_date DATE,
    delivery_price INT,
    PRIMARY KEY(delivery_id),
    FOREIGN KEY(member_id) REFERENCES crew(member_id)
);

CREATE TABLE store_order(
	order_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT,
    member_id INT,
    delivery INT,
    price INT DEFAULT 0,
    order_date DATE,
    PRIMARY KEY(order_id),
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY(delivery) REFERENCES delivery(delivery_id),
	FOREIGN KEY(member_id) REFERENCES crew(member_id)
);

CREATE TABLE order_products(
	order_id INT,	
    product_id INT,
    product_amount INT,
    PRIMARY KEY(order_id,product_id,product_amount),
    FOREIGN KEY(order_id) REFERENCES store_order(order_id),
    FOREIGN KEY(product_id) REFERENCES product(product_id)
);


-- Trigger ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DELIMITER $$
CREATE TRIGGER update_order_products AFTER INSERT ON order_products FOR EACH ROW BEGIN 

	INSERT INTO inventory_changes (change_date, product_amount, member_id, product_id)
		SELECT 	(select order_date from store_order where order_id = NEW.order_id),
				NEW.product_amount,
				(SELECT member_id FROM store_order where order_id = NEW.order_id),
				NEW.product_id
			FROM store_order s
			WHERE s.order_id = NEW.order_id;
        
	UPDATE store_order
		SET price = price + ((SELECT price FROM product WHERE product_id = NEW.product_id) * NEW.product_amount)
		where order_id = NEW.order_id;
    
    UPDATE product
		SET amount = amount - NEW.product_amount
		WHERE product_id = NEW.product_id;
        
 		UPDATE delivery 
 			SET delivery_price = IF(((SELECT price FROM store_order WHERE order_id = NEW.order_id) > 180), 0, 30)
				WHERE delivery_id = (SELECT delivery FROM store_order WHERE order_id = NEW.order_id);

END;
$$ DELIMITER ;


-- Procedure ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- 1 ----------------------------------------------------------------------------------------------- 
DELIMITER $$ 

CREATE PROCEDURE set_delivery(in_order_id INT, in_member_id INT)
BEGIN
	DECLARE fee INT;
    SELECT price INTO fee FROM store_order where order_id = in_order_id; 
    
    IF fee > 180 THEN 
		SET fee = 0;
    ELSE
		SET fee = 30;
	END IF;
	INSERT INTO delivery (member_id,order_date,delivery_price)
	VALUES
		(in_member_id,curdate(),fee);
	
    UPDATE store_order
    SET
		delivery = (SELECT delivery_id FROM delivery ORDER BY delivery_id DESC LIMIT 1), 
        price = price + fee
	where order_id = in_order_id;

END; $$

DELIMITER ;

-- 2 ----------------------------------------------------------------------------------------------- 
DELIMITER $$ 

CREATE PROCEDURE bestseller(in_amount INT, in_days INT)
BEGIN

        SELECT p.product_id, p.product_name, p.category, p.price ,sum(o.product_amount) AS amount, (p.price * sum(o.product_amount)) AS total_price FROM product p
		INNER JOIN order_products o
		ON
			o.product_id = p.product_id
		INNER JOIN store_order s 
		ON 
			s.order_id = o.order_id
		WHERE s.order_date >= curdate() - INTERVAL in_days DAY
		GROUP BY p.product_id
		ORDER BY amount DESC limit in_amount;

END; $$

DELIMITER ;

-- 3 ----------------------------------------------------------------------------------------------- 
DELIMITER $$ 

CREATE PROCEDURE discount(in_order_id INT, in_percent INT)
BEGIN
	UPDATE store_order
	SET
		price = price - (price * in_percent / 100 )
	where order_id = in_order_id;

END; $$

DELIMITER ;

-- Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$

CREATE FUNCTION 
	employee_income(in_name VARCHAR(100), in_month INT, in_year INT) RETURNS INTEGER
BEGIN
		DECLARE e_count INTEGER DEFAULT 0;
        SELECT sum(price) INTO e_count FROM store_order s
        INNER JOIN crew c
			ON
                s.member_id = c.member_id
		INNER JOIN person p
			ON
				p.person_id = c.person_id
		WHERE p.p_name = in_name and MONTH(s.order_date) = in_month and YEAR(s.order_date) = in_year;
        
		RETURN e_count;
END; $$

DELIMITER ;


-- Insert ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
	(1000,"Shlomi",1,'0501111111'),(1001,"Ruth",2,'0522222222'),(1002,"Narkis",3,'0533333333'),(1003,"Avraham",4,'0544444444'),(1004,"Ben",5,'0555555555'),(1005,"Ofek",6,'0566666666'),(1006,"Daniel",7,'0577777777'),(1007,"Shaul",8,'0588888888'),(1008,"Gefen",9,'0599999999'),(1009,"Rami",10,'0502111111'),(1010,"Aviv",11,'0502131111'),(1011,"Itay",12,'0505844452'),(1012,"Gadi",12,'0545532158'),(1013,"Sapir",13,'0529874111'),(1014,"Ofra",14,'0521234111'),(1015,"Shir",15,'0535274157'),(1016,"Mary",16,'0529874297'),(1017,"Roy",17,'0526854321'),(1018,"Yarden",18,'0523854391'),(1019,"Tomer",19,'0542222911'),(1020,"Barak",20,'0521234567'),(1021,"Zippi",21,'0551472583'),(1022,"Tanya",22,'0523692585'),(1023,"Emanuel",23,'0585478659');
    
insert into family_kind(family_id,family_name) 
values
	(1,"Dog"),(2,"Cat"),(3,"Rabbit"),(4,"Parrot"),(5,"Chameleon"),(6,"Fish"),(7,"Iguana"),(8,"Hamster");
    
insert into pet_kind(pet_id,family_id,kind_name)
values
	(60,1,"Labrador"),(61,1,"Border Collie"),(62,1,"Poodle"),(63,2,"Siamese"),(64,2,"Persian"),(65,3,"Netherland Dwarf"),(66,3,"American Fuzzy Lop"),(67,4,"African Grey"),(68,4,"Cockatoos"),(69,5,"Panther"),(70,5,"Veiled"),(71,6,"Golden"),(72,6,"Salmon"),(73,7,"Green"),(74,7,"Cuban Rock"),(75,8,"Dwarf Roborovski"),(76,8,"Campbell’s Dwarf Russian");
    
insert into pet(pet_id,pet_name,pet_kind,pet_age)
values
	(200,"Rexi",60,2),(201,"Pitzi",63,5),(202,"Snow",61,6),(203,"Sasha",64,6),(204,"Gezer",65,4),(205,"Sprarrow",67,4),(206,"Lizzi",69,3),(207,"Nemo",71,2),(208,"Iggy",73,6),(209,"Hamtaro",76,1),(210,"Tiny",72,6);
    
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
	(150,"Dogly",2,150,20),(151,"Brown Bone",1,30,10),(152,"Comfort Bed",3,170,5),(153,"Big Black Cage",4,400,6),(154,"Golden prestigious Cage",4,800,2),(155,"Catly",2,80,15),(156,"Carrot",2,10,59),(157,"Lettuce",2,10,40),(158,"Lazer",1,50,6),(159,"Ball Of String",1,30,7);
    
insert into delivery (delivery_id,member_id,delivery_date,delivery_price)
values
	(500,82,"2022-02-06",50),(501,82,"2022-07-06",40),(502,82,'2022-07-24',10),(503,82,'2022-07-25',50),(504,88,'2022-07-25',50);
    
    
insert into store_order (order_id,customer_id,member_id,delivery,order_date)
values
	(6000,10000,80,500,"2022-02-06"),(6001,10001,81,501,"2022-03-06"),(6002,10002,82,502,"2022-03-24"),(6003,10004,80,503,"2022-04-15"),(6004,10004,80,504,"2022-05-25");

insert into store_order (order_id,customer_id,member_id,order_date)
values   
    (6005,10000,80,"2022-05-01"),(6006,10000,84,"2022-05-03"),(6007,10005,85,"2022-06-14"),(6008,10003,85,"2022-07-27"),(6009,10002,84,"2022-07-31");
    
insert into order_products (order_id,product_id,product_amount)
values  
	(6000,150,1),(6001,151,2),(6002,152,1),(6003,153,1),(6004,154,1),(6005,155,6),(6006,156,15),(6007,157,2),(6008,158,2),(6009,159,3),(6009,151,1),(6009,150,1),(6009,152,1),(6000,151,2),(6001,155,1);
    
    
-- Querys ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- 1 -----------------------------------------------------------------------------------------------
SELECT product_name, amount from product;

-- 2 ----------------------------------------------------------------------------------------------- 
SELECT s.order_id, s.customer_id, s.member_id, s.delivery, s.price, s.order_date, p.product_name, o.product_amount FROM store_order s
	LEFT JOIN order_products o 
	ON
		s.order_id = o.order_id
	LEFT JOIN product p
	ON
		p.product_id = o.product_id
	WHERE order_date >= curdate() - INTERVAL 100 WEEK
    ORDER BY order_date DESC; 

-- 3 -----------------------------------------------------------------------------------------------
SELECT c.member_id, p.p_name,sum(o.product_amount) AS total_amount FROM person p
	INNER JOIN crew c 
    ON
		c.person_id = p.person_id
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	LEFT JOIN order_products o
    ON 
		o.order_id = s.order_id
	GROUP BY p.p_name
	ORDER BY sum(o.product_amount) DESC LIMIT 1;        
       
-- 4  -----------------------------------------------------------------------------------------------
SELECT c.member_id ,p.p_name, sum(s.price) AS total_price FROM person p
	INNER JOIN crew c 
    ON
		c.person_id = p.person_id
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	LEFT JOIN order_products o
    ON 
		o.order_id = s.order_id
	GROUP BY p.p_name
	ORDER BY total_price DESC LIMIT 1; 
    
    SELECT * FROM person p
	INNER JOIN crew c 
    ON
		c.person_id = p.person_id
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	LEFT JOIN order_products o
    ON 
		o.order_id = s.order_id;  
    
-- 5  -----------------------------------------------------------------------------------------------
SELECT c.customer_id, p.p_name, s.order_id, pr.product_name,s.price FROM person p	
	INNER JOIN customer c 
    ON
		p.person_id = c.person_id
	INNER JOIN store_order s 
	ON
		s.customer_id = c.customer_id
	LEFT JOIN order_products o
	ON
		o.order_id = s.order_id
	LEFT JOIN product pr
    ON
		pr.product_id = o.product_id
	WHERE delivery IS NULL;
    
-- 6 -----------------------------------------------------------------------------------------------
SELECT  c.customer_id, p.p_name FROM person p	
	INNER JOIN customer c 
    ON
		p.person_id = c.person_id
	LEFT JOIN store_order s 
	ON
		s.customer_id = c.customer_id
	WHERE s.customer_id IS NULL;
	
-- 7 -----------------------------------------------------------------------------------------------
SELECT c.customer_id, p.p_name, count(*) AS delivery_amount FROM person p 
	INNER JOIN customer c
    ON 	
		p.person_id = c.person_id
	INNER JOIN store_order s
    ON
		c.customer_id = s.customer_id
	GROUP BY p.p_name
    having delivery_amount > 1
    ORDER BY delivery_amount DESC;

-- 8 -----------------------------------------------------------------------------------------------
SELECT sum(price) as revenues FROM store_order 
	WHERE order_date >= curdate() - INTERVAL 6 month; 
    
    
    

