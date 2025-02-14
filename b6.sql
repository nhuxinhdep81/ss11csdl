-- 1
use sakila;

-- 2 so do erd

-- 3
create view view_film_category as
select f.film_id, f.title, c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id;

-- 4
create view view_high_value_customers as
select c.customer_id, c.first_name, c.last_name, sum(p.amount) as total_payment
from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name
having total_payment > 100;

-- 5
create index idx_rental_rental_date 
on rental (rental_date);

explain analyze select * from rental
where rental_date = '2005-06-14';

-- 6
delimiter //
create procedure CountCustomerRentals (
    in customer_id_in int,
    out rental_count int
)
begin
    select count(*) into rental_count
    from rental
    where customer_id = customer_id_in;
end //
delimiter ;

call CountCustomerRentals(1, @rental_count);
select @rental_count;

-- 7
delimiter //
create procedure GetCustomerEmail (
    in customer_id_in int,
    out customer_email varchar(50)
)
begin
    select email into customer_email
    from customer
    where customer_id = customer_id_in;
end //
delimiter ;

call GetCustomerEmail(1, @customer_email);
select @customer_email;

-- 8
drop view view_film_category;
drop view view_high_value_customers;

drop index idx_rental_rental_date on rental;

drop procedure CountCustomerRentals;
drop procedure GetCustomerEmail;



