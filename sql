-- Get a list of the 3 long-standing customers for each country

-- Customers with oldest orders by orderdate

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

-- Customers with oldest orders by amount of days from their first order to last order

WITH newest_orders AS(
	SELECT
		o.orderdate
		,c.customerid
		,c.country

	FROM
		customers as c
	JOIN
		orders as o
	ON
		c.customerid = o.customerid

	ORDER BY
		o.orderdate DESC)

,oldest_orders AS(
	SELECT
		o.orderdate
		,c.customerid
		,c.country

	FROM
		customers as c
	JOIN
		orders as o
	ON
		c.customerid = o.customerid

	ORDER BY
		o.orderdate)

SELECT *
FROM (
SELECT
	oo.orderdate - no.orderdate 
	,oo.customerid
	,oo.country
	,RANK() OVER (PARTITION BY oo.country ORDER BY oo.orderdate - no.orderdate DESC) as most_days
	
FROM
	oldest_orders as oo
JOIN
	newest_orders as no
ON
	oo.customerid = no.customerid


ORDER BY
	3) as makingtop3

WHERE
	most_days < 4



-- The above query gives duplicate people but has a top 3. SELECT DISTINCT in my outer query also gives me duplicate people. Will work on later.

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

-- Ignores quantity ties, picks a top 3

WITH most_ordered AS(
SELECT
	p.productname
	,o.shipcity
	,od.quantity
	,o.shipcountry
	,ROW_NUMBER() OVER (PARTITION BY o.shipcountry ORDER BY od.quantity DESC) as country_orders

FROM
	orders as o
JOIN
	orderdetails as od 
ON
	o.orderid = od.orderid
JOIN 
	products as p
ON
	od.productid = p.productid)

SELECT 
	* 
FROM
	most_ordered
WHERE
	country_orders < 4;


-- Shows ties of quantity

WITH most_ordered AS(
SELECT
	p.productname
	,o.shipcity
	,od.quantity
	,o.shipcountry
	,RANK() OVER (PARTITION BY o.shipcountry ORDER BY od.quantity DESC) as country_orders

FROM
	orders as o
JOIN
	orderdetails as od 
ON
	o.orderid = od.orderid
JOIN 
	products as p
ON
	od.productid = p.productid)

SELECT 
	* 
FROM
	most_ordered
WHERE
	country_orders < 4;