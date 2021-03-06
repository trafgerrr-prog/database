CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	address VARCHAR(3000) NOT NULL,
	phone_number VARCHAR(40) NOT NULL
)

CREATE TABLE menu(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	sostav VARCHAR(3000) NOT NULL,
	weight INTEGER NOT NULL,
	belki INTEGER NOT NULL,
	zhiri INTEGER NOT NULL,
	uglevodi INTEGER NOT NULL,
	kcal INTEGER NOT NULL,
	price INTEGER
)

CREATE TABLE order_list(
	id SERIAL PRIMARY KEY,
	user_id INTEGER,
	order_status VARCHAR(255) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users (id)
)

CREATE TABLE orders(
	order_id INTEGER,
	menu_id INTEGER,
	date_order DATE NOT NULL,
	FOREIGN KEY (order_id) REFERENCES order_list (id),
	FOREIGN KEY (menu_id) REFERENCES menu (id)
)

------
INSERT INTO menu (id, name, sostav, weight,
				 belki, zhiri, uglevodi, kcal, price)
VALUES (1,'Стейк из черпорога', '2 стейка, олив. масло, слив. масло, соль, 
		северные пряности, чеснок измел., чеснок целый, сухое вино.', 1000, 270, 150, 0, 2520, 5000);

INSERT INTO menu (id, name, sostav, weight,
				 belki, zhiri, uglevodi, kcal, price)
VALUES (2,'Жаренные ножки лесного долгонога', '4 индюшиных ножки, соль, чесночный порошок,
		молотый кориандр, сушеный майоран, паприка, черный перец.', 2000, 390, 134, 0, 2880, 7500);
		
INSERT INTO menu (id, name, sostav, weight,
				 belki, zhiri, uglevodi, kcal, price)
VALUES (3,'Яйца, запеченные с травами', '4 кур. яйца, тимьян, розмарин, петрушка, соль, черный перец,
        тертый пармезан, сливки, слив. масло, хлеб.', 120, 15, 11, 1, 171, 200);
		
INSERT INTO menu (id, name, sostav, weight,
				 belki, zhiri, uglevodi, kcal, price)
VALUES (4,'Чудесный вишневый пирог', 'Вишня, мука, слив. масло, вишневый сок, сахар, 
		кукурузный крахмал, корица, молотый кардамон, молотый имбирь, соль, кур. яйцо', 800, 40, 13, 208, 1000, 1500);
------
INSERT INTO users (id, name, address, phone_number)
VALUES (1, 'Петр', 'г. Дубна, ул. Ленинградская, д. 14', '88005553535');

INSERT INTO users (id, name, address, phone_number)
VALUES (2, 'Иван', 'г. Москва, ул. Пушкина, д. Колотушкина', '89001234567');
------
INSERT INTO order_list (id, user_id, order_status)
VALUES (100, 1, 'Доставлено')

INSERT INTO order_list (id, user_id, order_status)
VALUES (101, 1, 'Готовится')

INSERT INTO order_list (id, user_id, order_status)
VALUES (102, 2, 'Готовится')

INSERT INTO order_list (id, user_id, order_status)
VALUES (103, 2, 'Доставляется')
-----
INSERT INTO orders (order_id, menu_id, date_order)
VALUES (100, 1, now())

INSERT INTO orders (order_id, menu_id, date_order)
VALUES (100, 3, now())

INSERT INTO orders (order_id, menu_id, date_order)
VALUES (101, 1, now())

INSERT INTO orders (order_id, menu_id, date_order)
VALUES (102, 2, now())

INSERT INTO orders (order_id, menu_id, date_order)
VALUES (102, 4, now())

INSERT INTO orders (order_id, menu_id, date_order)
VALUES (103, 4, now())
----- ЗАПРОСЫ -----
SELECT m.name as название, m.sostav as состав, m.weight as вес, m.belki as белки, 
	   m.zhiri as жиры, m.uglevodi as углеводы, m.kcal as ккал, m.price as цена
FROM menu m

SELECT u.name as имя, ol.id as id_заказа, m.name as блюдо, o.date_order as дата_заказа, ol.order_status as статус_заказа
FROM users u,
	 menu m,
	 order_list ol,
	 orders o
WHERE u.id = ol.user_id AND ol.id = o.order_id AND o.menu_id = m.id

SELECT ol.id as id_заказа, m.name as блюдо, u.name as имя, u.address as адрес, u.phone_number as телефон
FROM users u,
	 menu m,
	 order_list ol,
	 orders o
WHERE u.id = ol.user_id AND ol.id = o.order_id AND o.menu_id = m.id

SELECT ol.id, ol.order_status
FROM order_list ol
WHERE ol.order_status = 'Готовится'

SELECT u.name as имя, u.address as адрес, u.phone_number as телефон
FROM users u

SELECT count(*) as количество_заказов
FROM order_list
WHERE order_status = 'Готовится'

SELECT distinct ol.id as id_заказа, o.date_order as дата_заказа
FROM order_list ol,
	 orders o
WHERE ol.id = o.order_id

INSERT INTO users (name, address, phone_number)
VALUES ('Алексей', 'Дубна', 123)

INSERT INTO menu (name, sostav, weight, belki, zhiri, uglevodi, kcal, price)
VALUES ('Доширак', 'Лапша, бульен', 250, 100, 10, 10, 100, 40)

SELECT ol.id, o.menu_id, m.price, o.date_order
FROM orders o,
	 order_list ol,
	 menu m
WHERE ol.id = o.order_id AND m.id = o.menu_id
ORDER BY m.price

SELECT ol.id, o.menu_id, m.price, o.date_order
FROM orders o,
	 order_list ol,
	 menu m
WHERE ol.id = o.order_id AND m.id = o.menu_id
ORDER BY o.date_order

SELECT ol.id, m.name, m.price, o.date_order
FROM orders o,
	 order_list ol,
	 menu m
WHERE ol.id = o.order_id AND m.id = o.menu_id AND o.date_order BETWEEN '2020-01-01' AND '2022-01-01'