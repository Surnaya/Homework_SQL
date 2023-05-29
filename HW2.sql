CREATE DATABASE HW2_SQL;

USE HW2_SQL;

/* 1. Используя операторы языка SQL,
создайте таблицу “sales”. Заполните ее данными.*/

CREATE TABLE sales
(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
order_date DATE NOT NULL,
count_product INT NOT NULL);

INSERT INTO sales (order_date, count_product)
VALUES ("2022-01-01", 156),
("2022-01-02", 180),
("2022-01-03", 21),
("2022-01-04", 124),
("2022-01-05", 341);

/* 2. Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва :
меньше 100 - Маленький заказ
от 100 до 300 - Средний заказ
больше 300 - Большой заказ */

SELECT id,
CASE 
	WHEN count_product < 100 THEN 'Маленький заказ'
	WHEN count_product > 300 THEN 'Большой заказ'
    ELSE 'Средний заказ'
END AS "Тип заказа"
FROM sales;

/* 3. Создайте таблицу “orders”, заполните ее значениями */

CREATE TABLE orders
(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
employee_id VARCHAR(10) NOT NULL,
amount FLOAT NOT NULL,
order_status varchar(15));

INSERT INTO orders (employee_id, amount, order_status)
VALUES
	('e03', 15.00, 'OPEN'),
    ('e01', 25.50, 'OPEN'),
    ('e05', 100.70, 'CLOSED'),
    ('e02', 22.18, 'OPEN'),
    ('e04', 9.50, 'CANCELLED');
    
/* Выберите все заказы. В зависимости от поля order_status выведите 
столбец full_order_status: 
OPEN – «Order is in open state» ; 
CLOSED - «Order is closed»; 
CANCELLED - «Order is cancelled»
*/

SELECT *,
CASE
	WHEN order_status = 'OPEN' THEN 'Order is in open state'
    WHEN order_status = 'CLOSED' THEN 'Order is closed'
    WHEN order_status = 'CANCELLED' THEN 'Order is cancelled'
END AS full_order_status
FROM orders;

/* 4. Чем 0 отличается от NULL? 
Как я понимаю NULL - это неизвестная информация, т.е. она должна быть, 
но по какой-то причине не введена в БД*/