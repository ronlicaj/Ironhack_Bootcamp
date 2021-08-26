use sakila;
-- 1.release years
SELECT 
    release_year
FROM
    film;
-- 2.film with the title armageddon
SELECT 
    film.title
FROM
    film
WHERE
    film.title LIKE '%ARMAGEDDON%';

-- 3. film titles ending with apollo
SELECT 
    title
FROM
    film
WHERE
    title REGEXP 'apollo$';
    
-- 4.get 10 longest film
SELECT 
    length, title
FROM
    film
GROUP BY film_id
ORDER BY length
LIMIT 10;

-- 5. film with behind the scenes content
SELECT 
    title, special_features
FROM
    film
WHERE
    special_features LIKE '%Behind the Scenes%'
GROUP BY film_id;

-- 6. drop column picture from staff
alter table staff
drop picture;
SELECT 
    *
FROM
    staff;

-- 7.update databse
INSERT INTO sakila.staff (staff_id, first_name, last_name, 
address_id, email, store_id, `active`, username, 
`password`, last_update) values (3,"TAMMY", "SANDERS", "79",
"TAMMY.SANDERS@sakilacustomer.org", 1, 1, "Tammy", "tammy7689",
'2006-02-15 03:57:16');
SELECT 
    *
FROM
    staff;

-- 8 add rental for movie
SELECT 
    *
FROM
    rental;
SELECT 
    customer_id
FROM
    sakila.customer
WHERE
    first_name = 'CHARLOTTE'
        AND last_name = 'HUNTER';
INSERT INTO sakila.rental (rental_id, rental_date, inventory_id, 
customer_id, return_date, staff_id, last_update) 
values (16050,'2021-08-26 15:38:16', 1, 130,
'2021-09-26 15:38:16', 1,'2021-08-26 15:38:16');
SELECT 
    *
FROM
    rental
GROUP BY rental_id
ORDER BY rental_id DESC
LIMIT 10;  
   
-- 9. add rental for movie
select customer_id from customer 
where customer.active = 0; 

create table deleted_users
as select customer_id, email, create_date 
from customer where customer.active = 0;

select * from deleted_users;

delete from customer where customer.active= 0;



