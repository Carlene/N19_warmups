-- Get a list of the 3 long-standing customers for each country

WITH oldest_customers AS(
SELECT
	contactname
	,orderdate
	,country
	,RANK() OVER (PARTITION BY country ORDER BY orderdate) as c_by_country

FROM
	customers as c
JOIN
	orders as o
ON
	c.customerid = o.customerid)

SELECT
	*

FROM
	oldest_customers

WHERE
	c_by_country < 4


-- Modify the previous query to get the 3 newest customers in each each country.

WITH newest_customers AS(
SELECT
	contactname
	,orderdate
	,country
	,RANK() OVER (PARTITION BY country ORDER BY orderdate DESC) as c_by_country

FROM
	customers as c
JOIN
	orders as o
ON
	c.customerid = o.customerid)

SELECT
	*

FROM
	newest_customers

WHERE
	c_by_country < 4


-- Get the 3 most frequently ordered products in each city
-- FOR SIMPLICITY, we're interpreting "most frequent" as 
-- "highest number of total units ordered within a country"
-- hint: do something with the quanity column