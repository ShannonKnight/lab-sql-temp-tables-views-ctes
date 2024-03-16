/* Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).*/

CREATE VIEW customer_rental
 AS (
 SELECT
	c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS number_of_rentals
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id);

SELECT * FROM customer_rental;
    
/*Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.*/

CREATE TEMPORARY TABLE total_paid_customer2
SELECT 
	cr.*, 
    SUM(p.amount) AS 'total_paid' 
FROM customer_rental cr
LEFT JOIN payment p
ON cr.customer_id = p.customer_id
GROUP BY customer_id;

SELECT * FROM total_paid_customer2;

/*Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.*/

WITH cte_customer AS (
SELECT 
	cre.customer_name,
    cre.email,
    cre.number_of_rentals,
    c2.total_paid
FROM customer_rental cre
JOIN total_paid_customer2 c2
ON cre.customer_id = c2.customer_id)
SELECT * FROM cte_customer;
	
/*Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.*/

CREATE VIEW final_customer_summary2 AS
WITH cte_customer AS (
    SELECT 
        cre.customer_name,
        cre.email,
        cre.number_of_rentals,
        SUM(cr.amount) AS total_paid
    FROM customer_rental cre
    JOIN payment cr
    ON cre.customer_id = cr.customer_id
    GROUP BY cre.customer_id
)
SELECT 
    c3.*,
    ROUND((c3.total_paid / c3.number_of_rentals),2) AS avg_pmt_per_rental
FROM cte_customer c3;

select * from final_customer_summary2;



