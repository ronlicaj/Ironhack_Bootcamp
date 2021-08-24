-- lab day 2
-- question 1
SELECT 
    category.name
FROM
    category
SELECT 
    category.name, COUNT(film_category.film_ID)
FROM
    category
        INNER JOIN
    film_category ON film_category.category_id = category.category_id
GROUP BY category.name

-- quest 2
SELECT 
    COUNT(Film_Actor.actor_id),
    Actor.first_name,
    actor.last_name
FROM
    actor
        INNER JOIN
    film_actor ON film_actor.actor_id = actor.actor_id
GROUP BY Film_Actor.actor_id
ORDER BY COUNT(Film_Actor.actor_id) DESC
LIMIT 1;

-- question 3
SELECT 
    COUNT(rental.rental_id),
    customer.first_name,
    customer.last_name
FROM
    customer
        INNER JOIN
    rental ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 1

-- quation 4
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    address
        INNER JOIN
    staff ON staff.address_ID = address.address_ID;

-- queestion 6

SELECT 
    staff.first_name, staff.last_name, SUM(payment.amount)
FROM
    staff
        INNER JOIN
    payment ON payment.staff_ID = staff.staff_ID
WHERE
    payment.payment_date >= '2005-08-01'
        AND payment.payment_date <= '2005-08-31'
GROUP BY staff.first_name
ORDER BY SUM(payment.amount) DESC;

-- question 7

SELECT 
    film.title, COUNT(Film_Actor.actor_id) AS numb_of_act
FROM
    film
        INNER JOIN
    film_actor ON film_actor.film_id = film.film_id
GROUP BY Film.title
ORDER BY COUNT(numb_of_act) DESC;

-- question 8
SELECT 
    customer.first_name, customer.last_name, SUM(payment.amount)
FROM
    customer
        INNER JOIN
    payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_ID
ORDER BY customer.last_name;

-- question 8 Bonus

SELECT 
    film.title, COUNT(rental.rental_ID) AS times_rented
FROM
    film
        INNER JOIN
    inventory ON film.film_id = inventory.film_id
        INNER JOIN
    rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id
ORDER BY times_rented DESC;
