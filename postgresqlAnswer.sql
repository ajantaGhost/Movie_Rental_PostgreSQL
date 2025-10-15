-- 1.List the first name and last name of all customers.--
SELECT first_name, last_name FROM customer;

-- 2.Find all the movies that are currently rented out.--
SELECT film.title 
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL;

-- 3.Show the titles of all movies in the 'Action' category.--
SELECT film.title FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Action';

-- 4.Count the number of films in each category.--
SELECT category.name AS category, COUNT(film.film_id) AS film_count FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name;

-- 5.What is the total amount spent by each customer?--
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id;

-- 6.Find the top 5 customers who spent the most.--
SELECT customer_id, SUM(amount) AS total_spent FROM payment
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 7.Display the rental date and return date for each rental.--
SELECT rental_date, return_date FROM rental;

-- 8.List the names of staff members and the stores they manage.--
SELECT staff.first_name, staff.last_name, store.store_id FROM staff
JOIN store ON staff.staff_id = store.manager_staff_id;

-- 9.Find all customers living in 'California'.--
SELECT customer.first_name, customer.last_name FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE address.district = 'California';

-- 10.Count how many customers are from each city.--
SELECT city.city, COUNT(customer.customer_id) AS customer_count FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city.city;

-- 11.Find the film(s) with the longest duration.--
SELECT title, length FROM film
WHERE length = (SELECT MAX(length) FROM film);

-- 12. Which actors appear in the film titled 'Alien Center'?--
SELECT actor.first_name, actor.last_name FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Alien Center';

-- 13.Find the number of rentals made each month.--
SELECT DATE_TRUNC('month', rental_date) AS month, COUNT(*) AS rentals FROM rental
GROUP BY month ORDER BY month;

-- 14.Show all payments made by customer 'Mary Smith'.--
SELECT payment.* FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
WHERE customer.first_name = 'Mary' AND customer.last_name = 'Smith';

-- 15.List all films that have never been rented.--
SELECT film.title FROM film
JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;

-- 16.What is the average rental duration per category?--
SELECT category.name, AVG(film.rental_duration) AS avg_duration FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name;

-- 17.Which films were rented more than 50 times?--
SELECT film.title, COUNT(*) AS rental_count FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title HAVING COUNT(*) > 50;

-- 18.List all employees hired after the year 2005.--
SELECT staff_id, first_name, last_name, email, last_update FROM staff
WHERE last_update > '2005-12-31';

-- 19.Show the number of rentals processed by each staff member.--
SELECT staff_id, COUNT(*) AS rental_count FROM rental GROUP BY staff_id;

-- 20.Display all customers who have not made any payments.--
SELECT customer.first_name, customer.last_name FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment.payment_id IS NULL;

-- 21.What is the most popular film (rented the most)?--
SELECT film.title, COUNT(*) AS rental_count FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title ORDER BY rental_count DESC LIMIT 1;

-- 22.Show all films longer than 2 hours.--
SELECT title, length FROM film WHERE length > 120;

-- 23.Find all rentals that were returned late.--
SELECT * FROM rental WHERE return_date > rental_date + INTERVAL '3 day';

-- 24.List customers and the number of films they rented.--
SELECT customer_id, COUNT(*) AS film_count FROM rental GROUP BY customer_id;

-- 25.Write a query to show top 3 rented film categories.--
SELECT category.name, COUNT(*) AS rental_count FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY rental_count DESC LIMIT 3;

-- 26.Create a view that shows all customer names and their payment totals.--
CREATE VIEW customer_payment_totals AS
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_payment FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name;

-- 27.Update a customer's email address given their ID.--
UPDATE customer SET email = 'newemail@example.com' WHERE customer_id = 1;

-- 28.Insert a new actor into the actor table.--
INSERT INTO actor (first_name, last_name) VALUES ('John', 'Doe');

-- 29.Delete all records from the rentals table where return_date is NULL.--
DELETE FROM rental WHERE return_date IS NULL;

SELECT * FROM rental WHERE return_date IS NULL;

-- 30.Add a new column 'age' to the customer table.--
ALTER TABLE customer ADD COLUMN age INT;

-- 31.Create an index on the 'title' column of the film table.--
CREATE INDEX idx_film_title ON film(title);

-- 32.Find the total revenue generated by each store.--
SELECT store.store_id, SUM(payment.amount) AS total_revenue FROM payment
JOIN staff ON payment.staff_id = staff.staff_id
JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id;

-- 33.What is the city with the highest number of rentals?--
SELECT city.city, COUNT(*) AS rental_count FROM rental
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city.city
ORDER BY rental_count DESC LIMIT 1;

-- 34.How many films belong to more than one category?--
SELECT COUNT(*) 
FROM (
    SELECT film_id FROM film_category
    GROUP BY film_id
    HAVING COUNT(category_id) > 1
) AS multi_category_films;

-- 35.List the top 10 actors by number of films they appeared in.--
SELECT actor.first_name, actor.last_name, COUNT(*) AS film_count FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
ORDER BY film_count DESC LIMIT 10;

-- 36.Retrieve the email addresses of customers who rented 'Matrix Revolutions'.--
SELECT DISTINCT customer.email FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'Matrix Revolutions';

-- 37.Create a stored function to return customer payment total given their ID.--
CREATE OR REPLACE FUNCTION get_customer_total_payment(cust_id INT)
RETURNS NUMERIC (10,2) AS $$
DECLARE
    total NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM (amount), 0.00)
	INTO total
	FROM payment
	WHERE customer_id = cust_id;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- 38.Begin a transaction that updates stock and inserts a rental record.--
BEGIN;
UPDATE inventory
SET last_update = NOW()
WHERE inventory_id = 1;
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, last_update)
VALUES (NOW(), 1, 1, 1, NOW());
COMMIT;

-- 39.Show the customers who rented films in both 'Action' and 'Comedy' categories.--
SELECT customer_id
FROM (
    SELECT customer_id, category.name
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film_category ON inventory.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
    GROUP BY customer_id, category.name
) AS cat_rents GROUP BY customer_id
HAVING COUNT(DISTINCT name) FILTER (WHERE name IN ('Action', 'Comedy')) = 2;

-- 40.Find actors who have never acted in a film.--
SELECT * FROM actor
WHERE actor_id NOT IN (SELECT actor_id FROM film_actor);


