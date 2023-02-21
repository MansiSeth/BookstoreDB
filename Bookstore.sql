drop database bookstore;

CREATE DATABASE bookstore;
USE bookstore;


CREATE TABLE region(
region_id int,
region_name varchar(20),

PRIMARY KEY (region_id)
);


CREATE TABLE subregion(
subregion_id int,
subregion_name varchar(30),

region_id int,
FOREIGN KEY(region_id) references region(region_id),

PRIMARY KEY (subregion_id)
);


CREATE TABLE warehouse(
warehouse_code int,

subregion_id int,
FOREIGN KEY(subregion_id) references subregion(subregion_id),

PRIMARY KEY (warehouse_code)
);


CREATE TABLE books(
isbn int,
title varchar(45),
price varchar(45),

PRIMARY KEY(isbn)
);

CREATE TABLE year(
year_id int,
year year(4),

PRIMARY KEY(year_id)
);

CREATE TABLE month(
month_id int,
month varchar(15),

year_id int,
FOREIGN KEY(year_id) references year(year_id),

PRIMARY KEY(month_id)
);

CREATE TABLE day(
num_day int,
day_id varchar(45),

month_id int,
FOREIGN KEY(month_id) references month(month_id),

PRIMARY KEY(day_id)
);


CREATE TABLE facts_ticket(
ticket_number int,
sell_by_product double,

isbn int,
FOREIGN KEY(isbn) references books(isbn),

warehouse_code int,
FOREIGN KEY(warehouse_code) references warehouse(warehouse_code),

day_id varchar(45),
FOREIGN KEY(day_id) references day(day_id),


PRIMARY KEY (ticket_number)
);




INSERT INTO region (region_id, region_name)
VALUES (1, 'North America'), 
       (2, 'Europe'), 
       (3, 'Asia'),
       (4, 'South America'),
       (5, 'Africa');

INSERT INTO subregion (subregion_id, subregion_name, region_id)
VALUES (1, 'Northern America', 1), 
       (2, 'Western Europe', 2), 
       (3, 'Eastern Asia', 3),
       (4, 'South America', 4),
       (5, 'Northern Africa', 5);
       
INSERT INTO warehouse (warehouse_code, subregion_id)
VALUES (1, 1), 
       (2, 2), 
       (3, 3),
       (4, 4),
       (5, 5);
       
INSERT INTO books (isbn, title, price)
VALUES (1, 'To Kill a Mockingbird', '10.99'),
       (2, '1984', '9.99'),
       (3, 'The Great Gatsby', '12.99'),
       (4, 'Pride and Prejudice', '8.99'),
       (5, 'Animal Farm', '7.99');

INSERT INTO year (year_id, year)
VALUES (1, 2020),
       (2, 2021),
       (3, 2022),
       (4, 2023),
       (5, 2024);

INSERT INTO month (month_id, month, year_id)
VALUES (1, 'January', 1),
       (2, 'February', 1),
       (3, 'March', 1),
       (4, 'April', 2),
       (5, 'May', 2);
       
INSERT INTO day (num_day, day_id, month_id)
VALUES (1, '2020-01-01', 1),
       (2, '2020-01-02', 1),
       (3, '2020-01-03', 1),
       (4, '2021-04-01', 4),
       (5, '2021-04-02', 4);


INSERT INTO facts_ticket (ticket_number, sell_by_product, isbn, warehouse_code, day_id)
VALUES (1, 25.99, 1, 1, '2020-01-01'),
       (2, 17.99, 2, 1, '2020-01-02'),
       (3, 21.99, 3, 2, '2020-01-03'),
       (4, 11.99, 4, 2, '2021-04-01'),
       (5, 9.99, 5, 3, '2021-04-02');




SELECT sr.subregion_name AS SUBREGION, d.day_id AS DAY, f.isbn AS ISBN, b.title AS TITLE, SUM(f.sell_by_product) AS TOTAL_SALES
FROM facts_ticket f
JOIN books b ON f.isbn = b.isbn
JOIN warehouse w ON f.warehouse_code = w.warehouse_code
JOIN subregion sr ON w.subregion_id = sr.subregion_id
JOIN day d ON f.day_id = d.day_id
GROUP BY sr.subregion_name, d.day_id, f.isbn, b.title;

SELECT y.year AS YEAR, f.isbn AS ISBN, b.title AS TITLE, SUM(f.sell_by_product) AS SALES_AMOUNT
FROM facts_ticket f
JOIN books b ON f.isbn = b.isbn
JOIN day d ON f.day_id = d.day_id
JOIN month m ON d.month_id = m.month_id
JOIN year y ON m.year_id = y.year_id
GROUP BY y.year, f.isbn, b.title;


SELECT r.region_name AS REGIONNAME, COUNT(*) AS NO_TRANSACTIONS
FROM facts_ticket f
JOIN warehouse w ON f.warehouse_code = w.warehouse_code
JOIN subregion s ON w.subregion_id = s.subregion_id
JOIN region r ON s.region_id = r.region_id
JOIN day d ON f.day_id = d.day_id
JOIN month m ON d.month_id = m.month_id
JOIN year y ON m.year_id = y.year_id
WHERE m.month = 'October' AND y.year = 2017
GROUP BY r.region_name
ORDER BY NO_TRANSACTIONS DESC
LIMIT 1;



SELECT r.region_name AS REGIONNAME, m.month AS MONTH, AVG(f.sell_by_product) AS AVG_INVOICE
FROM facts_ticket f
JOIN warehouse w ON f.warehouse_code = w.warehouse_code
JOIN subregion s ON w.subregion_id = s.subregion_id
JOIN region r ON s.region_id = r.region_id
JOIN day d ON f.day_id = d.day_id
JOIN month m ON d.month_id = m.month_id
JOIN year y ON m.year_id = y.year_id
GROUP BY r.region_name, m.month
ORDER BY r.region_name, m.month;



