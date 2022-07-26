-- drop database pet_store;

create database pet_store;

use pet_store;

create table store_role(
	role_id int,
    role_name VARCHAR(100),
    primary key(role_id)
);

create table street(
	street_id INT,
    street_name VARCHAR(100),
    primary key(street_id)
);

create table city(
	city_id INT,
    city_name VARCHAR(100),
    primary key(city_id)
);

create table address(
	address_id INT,
    city_id INT,
    street_id INT,
    street_num INT,
    primary key(address_id),
    foreign key(city_id) references city(city_id),
    foreign key(street_id) references street(street_id)
);

create table person(
	person_id INT,
    p_name VARCHAR(100),
    p_address INT,
    p_phone int,
    primary key(person_id),
    foreign key(p_address) references address(address_id)
);

create table family_kind(
	family_id INT,
    family_name VARCHAR(100),
    primary key(family_id)
);

create table pet_kind(
	pet_id INT,
    kind_id INT,
    kind_name VARCHAR(100),
    primary key(pet_id),
    foreign key(kind_id) references family_kind(family_id)
);

create table pet(
	pet_id INT,
    pet_name VARCHAR(100),
    pet_kind INT,
    pet_age INT,
    primary key(pet_id),
    foreign key(pet_kind) references pet_kind(pet_id)
);

create table customer(
	customer_id INT,
    person_id INT,
    pet_id INT,
    primary key(customer_id),
    foreign key(person_id) references person(person_id),
    foreign key(pet_id) references pet(pet_id)
);


create table crew(
	member_id INT,
    role_id INT,
    person_id INT,
    primary key(member_id),
    foreign key(role_id) references store_role(role_id),
    foreign key(person_id) references person(person_id)
);

create table category(
	category_id INT,
    category_name VARCHAR(100),
    primary key(category_id)
);

create table product(
	product_id INT,
    product_name VARCHAR(100),
    category INT,
    price INT,
    amount INT,
    primary key(product_id),
    foreign key(category) references category(category_id)
);

create table inventory_changes(
	product_id INT, 
    member_id INT,
    change_date DATE,
    primary key(product_id),
    foreign key(product_id) references product(product_id),
    foreign key(member_id) references crew(member_id)
);

create table delivery(
	delivery_id INT,
    member_id INT,
    order_date DATE,
    delivery_price INT,
    primary key(delivery_id),
    foreign key(member_id) references crew(member_id)
);

create table store_order(
	order_id INT,
    customer_id INT,
    member_id INT,
    delivery INT,
    product_id INT,
    price INT,
    primary key(order_id),
    foreign key(customer_id) references customer(customer_id),
	foreign key(delivery) references delivery(delivery_id),
	foreign key(product_id) references product(product_id),
	foreign key(member_id) references crew(member_id)
);




