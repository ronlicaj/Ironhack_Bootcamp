USE sakila;

-- Question 1 How many copies of the film Hunchback Impossible exist in the inventory system?

-- old school (-> joins)
select f.title, count(i.inventory_id)
from film as f
inner join inventory as i
on f.film_id = i.film_id
where f.title = "Hunchback Impossible"
group by f.title;

-- child query 
select film_id from film as f
where f.title = "Hunchback Impossible"
group by f.film_id
limit 1;

-- parent query
select count(inventory_id) from inventory as i
where i.film_id = (select film_id from film as f
where f.title = "Hunchback Impossible"
group by f.film_id
limit 1);

-- question 2 -> List all films whose length is longer than the average of all the films.

-- child query
select round(avg(length),2)
from film as f

-- parent query
select title, length from film as f
where f.length > (select round(avg(length),2)
from film as f)
order by f.length
Desc;

-- question 3 -> Use subqueries to display all actors who appear in the film Alone Trip.
-- child query
select film_id from film as f
where title = "Alone Trip";

-- child query 2
select actor_id from film_actor as f_a
where f_a.film_id = (select film_id from film as f
where title = "Alone Trip");

-- parent query
select first_name, last_name from actor as a
where a.actor_id in (select actor_id from film_actor as f_a
where f_a.film_id = (select film_id from film as f
where title = "Alone Trip"));

-- question 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- child query 1
select category_id 
from category as c
where c.name = "family";

-- child query 2
select film_id 
from film_category as f_c
where f_c.category_id = (select category_id 
from category as c
where c.name = "family");

-- parent query
select title, description from film as f
where f.film_id in (select film_id 
from film_category as f_c
where f_c.category_id = (select category_id 
from category as c
where c.name = "family"));

-- question 5 Get name and email from customers from Canada using subqueries. 

-- childquery 1
select country_id 
from country
where country = "canada";

-- childquery 2
select city_id
from city
where country_id = (select country_id 
from country
where country = "canada")

-- childquery 3
select address_id
from address as a
where a.city_id in (select city_id
from city
where country_id = (select country_id 
from country
where country = "canada"));

-- parentquery
select first_name, last_name, email 
from customer as c
where c.address_id in (select address_id
from address as a
where a.city_id in (select city_id
from city
where country_id = (select country_id 
from country
where country = "canada")))
group by c.last_name;

-- via multiple joins
select first_name, last_name, email 
from customer as c
inner join address as a
on a.address_id = c.address_id
inner join city as ci
on ci.city_id = a.city_id
inner join country as co
on co.country_id = ci.country_id
where co.country = "canada"
group by c.last_name;

-- question 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- child query
select actor_id from film_actor
group by actor_id
order by count(actor_ID)
desc
limit 1;

-- child query 2
select distinct film_id from film_actor as f_a
where f_a.actor_id = (select actor_id from film_actor
group by actor_id
order by count(actor_ID)
desc
limit 1);

-- parent query
select title from film as f
where f.film_id in (select distinct film_id from film_actor as f_a
where f_a.actor_id = (select actor_id from film_actor
group by actor_id
order by count(actor_ID)
desc
limit 1))
order by f.title;

-- question 7: Films rented by most profitable customer

-- child query
select customer_id 
from payment as p
group by p.customer_id
order by sum(amount)
desc
limit 1;

-- child query 2
select inventory_id from rental as r
where r.customer_id = (select customer_id 
from payment as p
group by p.customer_id
order by sum(amount)
desc
limit 1);

-- child query 3
select film_id from inventory as i
where i.inventory_id in (select inventory_id from rental as r
where r.customer_id = (select customer_id 
from payment as p
group by p.customer_id
order by sum(amount)
desc
limit 1));

-- parent query
select title from film as f
where f.film_id in ((select inventory_id from rental as r
where r.customer_id = (select customer_id 
from payment as p
group by p.customer_id
order by sum(amount)
desc
limit 1)));

-- Nr.8 Customers who spent more than the average payments
-- child query 1 to identify average per payment
SELECT AVG(amount) FROM payment;

-- child query 2 to identify the customers having > average payments
select distinct customer_id from payment as p
where p.amount > (select avg(amount) from payment);

-- parent query -> but not fully correct
SELECT first_name, last_name
FROM customer
WHERE customer_id IN(
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING avg(amount)>(SELECT AVG(amount) FROM payment));

-- CORRECT SOLUTION BELOW

-- 1) calculate sum of payments per customer

SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id;

-- 2) calculate the average payment amount per customer
SELECT sum(total_paid)/count(distinct(customer_id))
FROM
(SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id) as sum_table;


-- 3) compare and select the customers having > average payments conducted
SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id
HAVING total_paid >
(
SELECT sum(total_paid)/count(distinct(customer_id))
FROM
(SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id) as sum_table);

-- isolate only the customer_ids

Select customer_id 
from(SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id
HAVING total_paid >
(
SELECT sum(total_paid)/count(distinct(customer_id))
FROM
(SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id) as sum_table)) as new_customer_id;

-- Finishing by connecting the customer_ids with the customer names in the customer tabble
Select first_name, last_name from customer as c
where c.customer_id in (Select customer_id 
from(SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id
HAVING total_paid >
(
SELECT sum(total_paid)/count(distinct(customer_id))
FROM
(SELECT customer_id, sum(amount) as total_paid
FROM payment
GROUP BY customer_id) as sum_table)) as new_customer_id);


