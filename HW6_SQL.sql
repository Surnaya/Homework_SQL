USE Lesson4_Sql;

/* 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
с помощью которой можно переместить любого (одного) пользователя из таблицы users 
в таблицу users_old. (использование транзакции с выбором commit или rollback – обязательно). */

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old
(
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DROP PROCEDURE IF EXISTS transfer;
DELIMITER //
CREATE PROCEDURE transfer(user_id INT)
BEGIN
	-- откатить при возникновении ошибки при выполнении процедуры
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
	END;

	START TRANSACTION;
	-- копировать пользователя из таблицы users в таблицу users_old		
		INSERT INTO users_old (id, firstname, lastname, email) 
		(SELECT id, firstname, lastname, email FROM users WHERE user_id = id);
	-- удалить пользователя из таблицы users
		DELETE FROM users WHERE id = user_id;
	COMMIT;
    
END //
DELIMITER ;
CALL transfer(16);

SELECT * FROM users_old;

/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости
 от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */
 
DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS TEXT READS SQL DATA
BEGIN
	DECLARE time_now INT;
	SET  time_now  = HOUR(NOW());
	CASE
		WHEN  time_now  BETWEEN 0 AND 6 THEN RETURN 'Доброй ночи'; 
		WHEN  time_now  BETWEEN 6 AND 12 THEN RETURN 'Доброе утро';
		WHEN  time_now  BETWEEN 12 AND 18 THEN RETURN 'Добрый день';
		WHEN  time_now  BETWEEN 0 AND 6 THEN RETURN 'Добрый вечер';
	END CASE;
END//
DELIMITER ;

SELECT now(), hello();
 
/* 3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи 
в таблицах users, communities и messages в таблицу logs помещается время и дата создания
 записи, название таблицы, идентификатор первичного ключа. */
 
 DROP TABLE IF EXISTS table_logs;
 CREATE TABLE table_logs
 (
    name_table VARCHAR(50) COMMENT 'название таблицы',
    prkey_table INT COMMENT 'первичный ключ table_name',
    create_time DATETIME DEFAULT NOW() COMMENT 'дата и время внесения изменений'
) ENGINE=Archive;
 
DELIMITER //
-- для таблицы users
DROP TRIGGER IF EXISTS log_to_users //
CREATE TRIGGER log_to_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN
	INSERT INTO table_logs (name_table, prkey_table) VALUES('users', NEW.id);
END//

-- для таблицы communities
DROP TRIGGER IF EXISTS log_to_communities //
CREATE TRIGGER log_to_communities AFTER INSERT ON communities
FOR EACH ROW 
BEGIN
	INSERT INTO table_logs (name_table, prkey_table) VALUES('communities', NEW.id);
END//

-- для таблицы messages
DROP TRIGGER IF EXISTS log_to_messages //
CREATE TRIGGER log_to_messages AFTER INSERT ON messages
FOR EACH ROW 
BEGIN
	INSERT INTO table_logs (name_table, prkey_table) VALUES('messages', NEW.id);
END//
DELIMITER ;

-- вносим изменения в таблицы users, communities, messages
INSERT INTO users (firstname, lastname, email) VALUES 
('Roni', 'Now1', 'rony@example.org');
INSERT INTO messages (from_user_id, to_user_id, body, created_at) VALUES
(7, 2, 'Hi',  DATE_ADD(NOW(), INTERVAL 1 MINUTE));
INSERT INTO communities (name) VALUES ('ghy');


SELECT * FROM table_logs;

