-- drop database pet_store;

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






