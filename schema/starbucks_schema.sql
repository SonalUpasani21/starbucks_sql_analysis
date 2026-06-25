-- ================================================
-- Starbucks Portfolio Project
-- Data: starbucks_schema.sql
-- Author: Sonal Upasani
-- Date: 2026-05-25
-- ================================================

Create Database If Not Exists starbucks_db;
use starbucks_db;

-- ------------------------------------------------
-- 1. categories (no FKs)
-- ------------------------------------------------
Create Table categories (
    category_id int primary key auto_increment,
	category_name varchar(50) not null,
	category_description varchar(255)
);

-- ------------------------------------------------
-- 2. customers (no FKs)
-- ------------------------------------------------
Create table customers (
    customer_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email_address varchar(100) not null unique,
    phone_number varchar(15),
    city varchar(50),
    province varchar(50),
    signup_date date not null
);

-- ------------------------------------------------
-- 3. stores (manager_id FK added LATER via ALTER)
-- ------------------------------------------------
Create table stores (
    store_id int primary key auto_increment,
    store_address varchar(150) not null,
    city varchar(50) not null,
    province varchar(50) not null,
    store_type varchar(50),
    opening_date date,
    is_active boolean default 1,
    manager_id int  -- FK added after employees table is created
);

-- ------------------------------------------------
-- 4. employees (FK → stores)
-- ------------------------------------------------
Create table employees (
    employee_id int primary key auto_increment,
    store_id int, -- nullable for circular reference
    first_name varchar(50) not null,
    last_name varchar(50) not null, 
    employee_type varchar(50),
    hourly_wage decimal(5,2),
    hours_per_week decimal(4,2),
    start_date date not null,
    is_active boolean default 1,
    foreign key(store_id) references stores(store_id)
    );

-- ------------------------------------------------
-- Circular reference fix: now that employees exists,
-- add the manager_id FK to stores
-- ------------------------------------------------
Alter table stores
add constraint fk_stores_managers
foreign key (manager_id) references employees(employee_id);

-- ------------------------------------------------
-- 5. products (FK → categories)
-- ------------------------------------------------
Create table products (
    product_id int primary key auto_increment,
    category_id int not null, 
    product_name varchar(100) not null,
    product_description varchar(255), 
    product_price decimal(5,2) not null, 
    is_avaliable boolean default 1, 
    product_season varchar(30), 
    foreign key(category_id) references categories(category_id)
    );

-- ------------------------------------------------
-- 6. orders (FK → customers, stores)
-- ------------------------------------------------
Create table orders (
    order_id int primary key auto_increment,
    customer_id int not null, 
    store_id int not null, 
    order_timestamp datetime not null,
    order_total decimal(8,2) not null, 
    order_status varchar(30) not null, 
    foreign key(customer_id) references customers(customer_id),
    foreign key(store_id) references stores(store_id)
    );

-- ------------------------------------------------
-- 7. order_items (FK → orders, products)
-- ------------------------------------------------
Create table order_items (
    item_id int primary key auto_increment,
    order_id int not null,
    product_id int not null, 
    quantity int not null, 
    unit_price decimal(5,2) not null, 
    foreign key(order_id) references orders(order_id),
    foreign key(product_id) references products(product_id)
    );
    
-- ------------------------------------------------
-- 8. payments (FK → orders)
-- ------------------------------------------------
Create table payments (
    payments_id int primary key auto_increment,
    order_id int not null, 
    payment_type varchar(30) not null, 
    amount decimal(8,2) not null, 
    payment_status varchar(30) not null, 
    payment_timestamp datetime not null, 
    foreign key(order_id) references orders(order_id)
    );
    
-- ------------------------------------------------
-- 9. loyalty_rewards (FK → customers)
-- ------------------------------------------------
Create table loyalty_rewards (
    loyalty_id int primary key auto_increment,
    customer_id int not null,
    loyalty_tier varchar(20),
    stars_earned int default 0, 
    stars_redeemed int default 0, 
    stars_balance int default 0, 
    join_date date not null, 
    last_activity_date date, 
    foreign key(customer_id) references customers(customer_id)
    );
    
