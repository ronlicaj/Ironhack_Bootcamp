-- 1 
select count(last_name) as counter, last_name 
from actor
group by last_name
having counter = 1;

-- 2
select count(last_name) as counter, last_name 
from actor
group by last_name
having counter > 1;

-- 3
select count(rental.rental_id), staff.first_name, staff.last_name
from staff
join rental
on staff.staff_id = rental.staff_id
group by staff.first_name;

-- 4
select count(film_id), title from film;

-- 5
select count(film_id) as film_counts, rating from film 
group by rating;

-- 6
select avg(length), rating from film 
group by rating;

-- 7
select round(avg(length),2), rating from film 
group by rating
having round(avg(length),2) > 120;