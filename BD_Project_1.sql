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
	kcal INTEGER NOT NULL
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
