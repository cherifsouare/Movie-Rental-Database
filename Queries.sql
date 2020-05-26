--Query 1- How many times preferred categories by families have been rented out?


SELECT
   c.name AS name,
   COUNT(title) AS rental_count 
FROM
   film f 
   JOIN
      film_category fc 
      ON f.film_id = fc.film_id 
   JOIN
      category c 
      ON fc.category_id = c.category_id 
   JOIN
      inventory i 
      ON f.film_id = i.film_id 
   JOIN
      rental r 
      ON i.inventory_id = r.inventory_id 
WHERE
   c.name IN 
   (
      'Animation',
      'Children',
      'Classics',
      'Comedy',
      'Family',
      'Music'
   )
GROUP BY
   1
    
ORDER BY
   1;
  


--Query 2- Comparison of the monthly performance of two stores based on the rental orders

SELECT rental_month, rental_year, id_store, COUNT(*) AS rental_count
FROM (SELECT DATE_PART('month',r.rental_date) AS rental_month, 
             DATE_PART('year', r.rental_date) AS rental_year,
             s.store_id AS id_store
     FROM rental r
     JOIN staff st
     ON r.staff_id = st.staff_id
     JOIN store s
     ON st.store_id = s.store_id) t1
GROUP BY 1,2,3
ORDER BY 4 DESC;


 --Query 3- Who were the top 10 paying customers in 2007 and how much did they order and spend?

/* This subquery join the customer table the payment table and return top 10 customers in 2007 based on spend*/

WITH sub1 AS (SELECT DATE_TRUNC('month',p.payment_date) AS payment_mon,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       COUNT(*) AS paycount_permonth,
       SUM(p.amount)
       FROM customer c
       JOIN payment p
       ON c.customer_id = p.customer_id
       WHERE DATE_PART('year',p.payment_date) = 2007
       GROUP BY 1,2
       ORDER BY 4 DESC
       LIMIT 10)

/*this query return the top 10 customers IN 2007 and order by ascendiong name of the customer and then by month*/

SELECT *
FROM sub1
ORDER BY 2,1;


--Query 4- How are the films and categories are distributed in terms of rental duration?

SELECT name, standard_quartile, COUNT(*) AS Count_total     
FROM (SELECT f.title AS title, c.name AS name, f.rental_duration AS rental_duration, NTILE(4) OVER (PARTITION BY rental_duration ORDER BY rental_duration) AS standard_quartile
           FROM film f
           JOIN film_category fc
           ON f.film_id = fc.film_id
           JOIN category c
           ON fc.category_id = c.category_id) t1
WHERE name IN ('Animation','Children','Classics','Comedy','Family','Music')
GROUP BY 1,2
ORDER BY 1,2;


