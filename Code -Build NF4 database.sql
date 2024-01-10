USE original_db;
ALTER TABLE stores ADD COLUMN country VARCHAR(100) DEFAULT 'Ecuador';
ALTER TABLE holidays_events ADD holiday_id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE holidays_events
RENAME COLUMN type TO holiday_type,
RENAME COLUMN locale TO locale_type;

ALTER TABLE oil
RENAME COLUMN dcoilwtico TO oil_price;

ALTER TABLE train
RENAME COLUMN id TO sales_id,
RENAME COLUMN family TO product_family;

ALTER TABLE stores
RENAME COLUMN type TO store_type,
RENAME COLUMN cluster TO store_cluster;

SELECT *
FROM train t
LEFT JOIN stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN holidays_events h
ON s.country = h.locale_name AND t.date = h.date
UNION DISTINCT
SELECT *
FROM train t
LEFT JOIN stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN holidays_events h
ON s.state = h.locale_name AND t.date = h.date
UNION DISTINCT
SELECT *
FROM train t
LEFT JOIN stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN holidays_events h
ON s.city = h.locale_name AND t.date = h.date
LIMIT 5;

#Create database
CREATE DATABASE new_db;
USE new_db;

#Create tables

CREATE TABLE holiday_events
(
holiday_id INT,
description VARCHAR(100) NOT NULL,
holiday_type VARCHAR(100) NOT NULL,
date DATE,
locale_name VARCHAR(100),
transfered TINYINT(1) DEFAULT 1
);

CREATE TABLE holiday_locale_type
(
locale_name VARCHAR(100),
locale_type VARCHAR(100)
);

CREATE TABLE sales_holiday
(
holiday_id INT,
sales_id INT
);

CREATE TABLE sales
(
sales_id INT,
date DATE,
product_family VARCHAR(100) NOT NULL,
store_nbr INT NOT NULL,
sales DECIMAL(12,2),
onpromotion DECIMAL(12,2)
);

CREATE TABLE store_holiday
(
holiday_id INT,
store_nbr INT
);

CREATE TABLE oil_price
(
date DATE,
oil_price DECIMAL(10,2),
PRIMARY KEY(date)
);

CREATE TABLE stores
(
store_nbr INT,
store_type VARCHAR(100) NOT NULL,
store_cluster VARCHAR(100) NOT NULL,
city VARCHAR(100) NOT NULL
);

CREATE TABLE city
(
city VARCHAR(100) NOT NULL,
state VARCHAR(100) NOT NULL
);

CREATE TABLE state
(
state VARCHAR(100) NOT NULL,
country VARCHAR(100) NOT NULL
);

INSERT INTO sales_holiday (holiday_id, sales_id)
WITH combine AS
(
SELECT t.sales_id, h.holiday_id 
FROM original_db.train t
LEFT JOIN original_db.stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN original_db.holidays_events h
ON s.country = h.locale_name AND t.date = h.date
UNION DISTINCT
SELECT t.sales_id, h.holiday_id 
FROM original_db.train t
LEFT JOIN original_db.stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN original_db.holidays_events h
ON s.state = h.locale_name AND t.date = h.date
UNION DISTINCT
SELECT t.sales_id, h.holiday_id 
FROM original_db.train t
LEFT JOIN original_db.stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN original_db.holidays_events h
ON s.city = h.locale_name AND t.date = h.date
)
SELECT holiday_id, sales_id
FROM combine
;

SELECT *
FROM sales_holiday
LIMIT 1000;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM sales_holiday
WHERE holiday_id IS NULL OR sales_id IS NULL;

INSERT INTO store_holiday (holiday_id, store_nbr)
WITH combine AS
(
SELECT s.store_nbr, h.holiday_id 
FROM original_db.train t
LEFT JOIN original_db.stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN original_db.holidays_events h
ON s.country = h.locale_name AND t.date = h.date
UNION DISTINCT
SELECT s.store_nbr, h.holiday_id 
FROM original_db.train t
LEFT JOIN original_db.stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN original_db.holidays_events h
ON s.state = h.locale_name AND t.date = h.date
UNION DISTINCT
SELECT s.store_nbr, h.holiday_id 
FROM original_db.train t
LEFT JOIN original_db.stores s
ON t.store_nbr = s.store_nbr
LEFT JOIN original_db.holidays_events h
ON s.city = h.locale_name AND t.date = h.date
)
SELECT holiday_id, store_nbr
FROM combine
;

SELECT *
FROM store_holiday
LIMIT 1000;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM store_holiday
WHERE holiday_id IS NULL OR store_nbr IS NULL;

INSERT INTO holiday_events (holiday_id, description, holiday_type, date, locale_name, transfered)
SELECT 
	h.holiday_id,
    h.description,
    h.holiday_type,
    h.date,
    h.locale_name,
    h.transferred
FROM original_db.holidays_events h
;

INSERT INTO holiday_locale_type (locale_name, locale_type)
SELECT 
	h.locale_name,
    h.locale_type
FROM original_db.holidays_events h
GROUP BY h.locale_name, h.locale_type
;

INSERT INTO sales (sales_id, date, product_family, store_nbr ,sales, onpromotion)
SELECT 
	t.sales_id,
    t.date,
    t.product_family,
    t.store_nbr,
    t.sales,
    t.onpromotion
FROM original_db.train t
;

INSERT INTO oil_price (date, oil_price)
SELECT 
	o.date,
    o.oil_price
FROM original_db.oil o
;

INSERT INTO stores (store_nbr, store_type, store_cluster, city)
SELECT 
	s.store_nbr,
    s.store_type,
    s.store_cluster,
    s.city
FROM original_db.stores s
;

INSERT INTO city (city, state)
SELECT 
	s.city,
    s.state
FROM original_db.stores s
GROUP BY s.city, s.state
;

INSERT INTO state (state, country)
SELECT 
	s.state,
    s.country
FROM original_db.stores s
GROUP BY s.state, s.country
;