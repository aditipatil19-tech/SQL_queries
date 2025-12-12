CREATE TABLE books(
	book_id SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10, 2),
	Stock INT
);

CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	book_id INT REFERENCES books(book_id),
	Order_date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10, 2)	
);


select* from books;

select * from customers;

select * from orders;

--1) Retrieve all books in the "Fiction" genre:
SELECT *
FROM books
WHERE genre = 'Fiction';

--2) Find books published after the year 1950:
SELECT *
FROM books
WHERE published_year>1950;

--3) List all customers from the canada:
SELECT *
FROM customers
WHERE country ='Canada';

--4) Show orders placed in November 2023:
SELECT *
FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available:
SELECT SUM(stock) as total_stock
from books;

--6) Find the details of the most expensive book:
SELECT MAX(price) as expensive_book
FROM books;

SELECT * FROM books 
ORDER BY price desc 
LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of a book.
SELECT *
FROM orders
Where quantity >1;

--8) Retrive all the orders where the total amount exceeds $20:
SELECT *
FROM orders
Where total_amount>20;

--9) List all genres available in the books table:
SELECT DISTINCT genre FROM books;

--10)Find the books with the lowest stock:
SELECT MIN(stock) as lowest_stock
from books;

SELECT * FROM books order by stock asc;

--11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) as revenue
from orders;

--Advance Questions:

--1) Retrive the total number of books sold for each genre:
SELECT b.genre, SUM(o.quantity) as total_books_sold
FROM orders as o
INNER JOIN books as b
on o.book_id= b.book_id
GROUP BY b.genre;

--2) Find the average price of book in the "Fantasy" genre:
SELECT AVG(price)
from books
WHERE genre = 'Fantasy';

--3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.order_id)
FROM orders as o
JOIN customers as c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
Having COUNT(order_id)>=2;

--4) Find the most frequently ordered book:
SELECT o.book_id, b.title, COUNT(order_id) as order_count
from orders as o
join books as b
ON o.book_id = b.book_id
Group by o.book_id, b.title
ORDER BY order_count desc
LIMIT 1;

--5) Retrive the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) as total_books_sold
FROM orders o
join books b
on o.book_id = b.book_id
group by b.author;

---6) show the top3 most expensive books of 'Fantasy' Genre:
SELECT*
FROM books
WHERE genre = 'Fantasy'
order by price desc
limit 3;

--7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

--8) Find the customer who spent the most on orders:
SELECT c.name, c.customer_id, SUM(o.total_amount) as total_spent
FROM orders o 
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.name, c.customer_id
ORDER BY  total_spent desc;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.stock, b.book_id, b.title, COALESCE(SUM(quantity),0) as order_quantity, 
b.stock-COALESCE(SUM(quantity),0) as remaining_quantity
FROM books b 
LEFT JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.book_id;
