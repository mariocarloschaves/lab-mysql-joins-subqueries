USE SAKILA;


SELECT COUNT(*) AS copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'HUNCHBACK IMPOSSIBLE'
);

SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);


SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'ALONE TRIP'
    )
);



SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);


SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);



SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';



SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;



SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);


SELECT title
FROM film
WHERE film_id IN (
    SELECT inventory.film_id
    FROM inventory
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM rental
        WHERE customer_id = (
            SELECT customer_id
            FROM payment
            GROUP BY customer_id
            ORDER BY SUM(amount) DESC
            LIMIT 1
        )
    )
);



SELECT customer_id AS client_id,
       SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) >
(
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS avg_spending
);

