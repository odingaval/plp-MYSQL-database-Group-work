create database bookstore_db;
CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_code VARCHAR(8) NOT NULL,
    language_name VARCHAR(50) NOT NULL
);
-- Publisher table
CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(100) NOT NULL,
    publisher_website VARCHAR(200)
);
-- Author table
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(100) NOT NULL,
    author_bio TEXT,
    birth_date DATE,
    death_date DATE
);

-- Book table
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    num_pages INT,
    publication_date DATE,
    publisher_id INT,
    language_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);
-- Book-author relationship (many-to-many)
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);
-- Country table
CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(3) NOT NULL
);
-- Address status table
CREATE TABLE address_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL
);-- Address table
CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_number VARCHAR(10) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state_province VARCHAR(50),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);
-- Customer table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    password_hash VARCHAR(255) NOT NULL
);
-- Customer address relationship table
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    status_id INT NOT NULL,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);
-- Shipping method table
CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    delivery_time_days INT NOT NULL
);
-- order status table
CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL
);
-- Customer order table
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    method_id INT NOT NULL,
    order_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (method_id) REFERENCES shipping_method(method_id)
);
-- Order line table
CREATE TABLE order_line (
    line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);
-- order history table
CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);
-- Insert sample languages
INSERT INTO book_language (language_code, language_name) VALUES
('en', 'English'),
('es', 'Spanish'),
('fr', 'French'),
('de', 'German'),
('ja', 'Japanese');
-- Insert sample publishers
INSERT INTO publisher (publisher_name, publisher_website) VALUES
('Penguin Random House', 'https://www.penguinrandomhouse.com/'),
('HarperCollins', 'https://www.harpercollins.com/'),
('Simon & Schuster', 'https://www.simonandschuster.com/'),
('Macmillan', 'https://us.macmillan.com/'),
('Hachette', 'https://www.hachette.com/');
-- Insert sample authors
INSERT INTO author (author_name, author_bio, birth_date) VALUES
('J.K. Rowling', 'British author best known for the Harry Potter series', '1965-07-31'),
('Stephen King', 'American author of horror, supernatural fiction, suspense, and fantasy novels', '1947-09-21'),
('George R.R. Martin', 'American novelist and short-story writer in the fantasy, horror, and science fiction genres', '1948-09-20'),
('Agatha Christie', 'English writer known for her detective novels', '1890-09-15'),
('J.R.R. Tolkien', 'English writer, poet, philologist, and academic, best known for The Hobbit and The Lord of the Rings', '1892-01-03');
-- Insert sample books
INSERT INTO book (title, isbn, num_pages, publication_date, publisher_id, language_id, price, stock_quantity) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532743', 223, '1997-06-26', 1, 1, 12.99, 50),
('The Shining', '9780307743657', 447, '1977-01-28', 2, 1, 9.99, 30),
('A Game of Thrones', '9780553103540', 694, '1996-08-01', 3, 1, 15.99, 40),
('Murder on the Orient Express', '9780062073501', 256, '1934-01-01', 4, 1, 8.99, 25),
('The Hobbit', '9780547928227', 310, '1937-09-21', 5, 1, 14.99, 35);

-- Insert book-author relationships
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
-- Insert sample countries
INSERT INTO country (country_name, country_code) VALUES
('United States', 'USA'),
('United Kingdom', 'GBR'),
('Canada', 'CAN'),
('Australia', 'AUS'),
('Germany', 'DEU');
-- Insert address statuses
INSERT INTO address_status (status_name) VALUES
('Current'),
('Previous'),
('Billing'),
('Shipping');
-- Insert sample customers
INSERT INTO customer (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '555-123-4567','hashed_password'),
('Jane', 'Smith', 'jane.smith@example.com', '555-987-6543','hashed_password'),
('Robert', 'Johnson', 'robert.j@example.com', '555-456-7890','hashed_password'),
('Emily', 'Davis', 'emily.d@example.com', '555-789-0123','hashed_password'),
('Michael', 'Wilson', 'michael.w@example.com', '555-234-5678','hashed_password');
-- Insert sample addresses
INSERT INTO address (street_number, street_name, city, state_province, postal_code, country_id) VALUES
('123', 'Main St', 'New York', 'NY', '10001', 1),
('456', 'Oak Ave', 'London', NULL, 'SW1A 1AA', 2),
('789', 'Maple Rd', 'Toronto', 'ON', 'M5V 3L9', 3),
('101', 'Pine Blvd', 'Sydney', 'NSW', '2000', 4),
('202', 'Birch Ln', 'Berlin', NULL, '10115', 5);
-- Insert customer-address relationships
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1);
-- Insert shipping methods
INSERT INTO shipping_method (method_name, cost, delivery_time_days) VALUES
('Standard', 4.99, 5),
('Express', 9.99, 2),
('Overnight', 19.99, 1),
('International', 14.99, 7);
-- Insert order statuses
INSERT INTO order_status (status_value) VALUES
('Pending'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled');
-- Insert sample orders
INSERT INTO cust_order (customer_id, shipping_address_id, method_id, order_total) VALUES
(1, 1, 1, 27.98),
(2, 2, 2, 24.98),
(3, 3, 1, 15.99),
(4, 4, 3, 23.98),
(5, 5, 4, 14.99);

-- Insert order lines
INSERT INTO order_line (order_id, book_id, quantity, price) VALUES
(1, 1, 1, 12.99),
(1, 2, 1, 9.99),
(2, 3, 1, 15.99),
(3, 3, 1, 15.99),
(4, 4, 1, 8.99),
(4, 5, 1, 14.99),
(5, 5, 1, 14.99);
-- Insert order history
INSERT INTO order_history (order_id, status_id) VALUES
(1, 4),
(2, 3),
(3, 2),
(4, 1),
(5, 1);

-- sample quesries for testing
-- get all books with their author
SELECT b.title, a.author_name 
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;

-- get customer order with details
SELECT c.first_name, c.last_name, o.order_id, o.order_date, 
       COUNT(ol.line_id) AS item_count, o.order_total
FROM customer c
JOIN cust_order o ON c.customer_id = o.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
GROUP BY o.order_id;

-- check inventory levels
SELECT b.title, b.stock_quantity 
FROM book b
ORDER BY b.stock_quantity ASC;

-- get order status history
SELECT o.order_id, c.first_name, c.last_name, 
       os.status_value, oh.status_date
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_history oh ON o.order_id = oh.order_id
JOIN order_status os ON oh.status_id = os.status_id
ORDER BY oh.status_date DESC;
