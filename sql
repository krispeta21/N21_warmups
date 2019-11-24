-- For each product in the database, calculate how many more orders where placed in 
-- each month compared to the previous month.

-- IMPORTANT! This is going to be a 2-day warmup! FOR NOW, assume that each product
-- has sales every month. Do the calculations so that you're comparing to the previous 
-- month where there were sales.
-- For example, product_id #1 has no sales for October 1996. So compare November 1996
-- to September 1996 (the previous month where there were sales):
-- So if there were 27 units sold in November and 20 in September, the resulting 
-- difference should be 27-7 = 7.
-- (Later on we will work towards filling in the missing months.)

-- BIG HINT: Look at the expected results, how do you convert the dates to the 
-- correct format (year and month)?


WITH month_sales AS (
    SELECT
    od.product_id,
    od.order_id,
    SUM(od.quantity) as units,
    SUM(od.unit_price*od.quantity*(1-od.discount)) as total,
    o.order_date,
    DATE_PART('year', o.order_date) as year,
    DATE_PART('month',o.order_date) as month
FROM order_details as od
JOIN
orders as o
ON 
od.order_id = o.order_id
GROUP BY
od.order_id,
od.product_id,
o.order_date, 
month
ORDER BY
od.product_id, 
o.order_date),
previous AS (
SELECT
    ms.product_id,
    SUM(ms.units) as unit,
    ms.year,
    ms.month,
    LAG(SUM(ms.units),1) OVER(PARTITION BY ms.product_id ORDER BY ms.year, ms.month) as previous
FROM month_sales as ms
GROUP BY
ms.product_id, ms.year, ms.month
ORDER BY
ms.product_id,
ms.year,
ms.month)
SELECT *,
COALESCE(unit-previous,0) AS difference 
FROM
previous;

 product_id | unit | year | month | previous | difference 
------------+------+------+-------+----------+------------
          1 |   63 | 1996 |     8 |          |           
          1 |   20 | 1996 |     9 |       63 |        -43
          1 |   27 | 1996 |    11 |       20 |          7
          1 |   15 | 1996 |    12 |       27 |        -12
          1 |   34 | 1997 |     1 |       15 |         19
          1 |   15 | 1997 |     3 |       34 |        -19
          1 |   40 | 1997 |     4 |       15 |         25
          1 |    8 | 1997 |     5 |       40 |        -32
          1 |   10 | 1997 |     6 |        8 |          2












Background work

*Almost there, need to complete the window functions portion to get the lag


WITH month_sales AS (
    SELECT
    od.product_id,
    od.order_id,
    SUM(od.quantity) as units,
    SUM(od.unit_price*od.quantity*(1-od.discount)) as total,
    o.order_date,
    DATE_PART('year', o.order_date) as year,
    DATE_PART('month',o.order_date) as month
FROM order_details as od
JOIN
orders as o
ON 
od.order_id = o.order_id
GROUP BY
od.order_id,
od.product_id,
o.order_date, 
month
ORDER BY
od.product_id, 
o.order_date)
SELECT
    ms.product_id,
    SUM(ms.units) as unit,
    ms.year,
    ms.month
FROM month_sales as ms
GROUP BY
ms.product_id, ms.year, ms.month
ORDER BY
ms.product_id,
ms.year,
ms.month;


 product_id | unit | year | month 
------------+------+------+-------
          1 |   63 | 1996 |     8
          1 |   20 | 1996 |     9
          1 |   27 | 1996 |    11
          1 |   15 | 1996 |    12
          1 |   34 | 1997 |     1
          1 |   15 | 1997 |     3
          1 |   40 | 1997 |     4
          1 |    8 | 1997 |     5
          1 |   10 | 1997 |     6
          1 |   29 | 1997 |     7
          1 |   40 | 1997 |     8
          1 |   70 | 1997 |    10
          1 |   58 | 1997 |    11
          1 |   84 | 1998 |     1
          1 |   90 | 1998 |     2
          1 |   81 | 1998 |     3
          1 |  104 | 1998 |     4
          1 |   40 | 1998 |     5
          2 |  105 | 1996 |     7
          2 |   40 | 1996 |     9






product_id, year, month, unit_sold, prev_month, difference



How many more orders where placed?

Count(order_id)

Month
extract month

Lag and default to last value


SELECT
    od.product_id,
    od.order_id,
    SUM(od.quantity),
    SUM(od.unit_price*od.quantity*(1-od.discount)) as total,
    o.order_date
    FROM order_details as od
    JOIN
    orders as o
    ON 
    od.order_id = o.order_id
    GROUP BY
    od.order_id,
    od.product_id,
    o.order_date
    ORDER BY
    od.product_id;


PRODUCT SALES WITH YEARS AND MONTHS

SELECT
    od.product_id,
    od.order_id,
    SUM(od.quantity),
    SUM(od.unit_price*od.quantity*(1-od.discount)) as total,
    o.order_date,
    DATE_PART('year', o.order_date) as year,
    DATE_PART('month',o.order_date) as month
    FROM order_details as od
    JOIN
    orders as o
    ON 
    od.order_id = o.order_id
    GROUP BY
    od.order_id,
    od.product_id,
    o.order_date
    ORDER BY
    od.product_id;


     product_id | order_id | sum |      total       | order_date | year | month 
------------+----------+-----+------------------+------------+------+-------
          1 |    10285 |  45 | 518.399984335899 | 1996-08-20 | 1996 |     8
          1 |    10294 |  18 | 259.199993133545 | 1996-08-30 | 1996 |     8
          1 |    10317 |  20 | 287.999992370605 | 1996-09-30 | 1996 |     9
          1 |    10348 |  15 | 183.599993848801 | 1996-11-07 | 1996 |    11
          1 |    10354 |  12 | 172.799995422363 | 1996-11-14 | 1996 |    11
          1 |    10370 |  15 | 183.599993848801 | 1996-12-03 | 1996 |    12
          1 |    10406 |  10 | 143.999996185303 | 1997-01-07 | 1997 |     1
          1 |    10413 |  24 | 345.599990844727 | 1997-01-14 | 1997 |     1
          1 |    10477 |  15 | 215.999994277954 | 1997-03-17 | 1997 |     3
          1 |    10522 |  40 | 575.999997854233 | 1997-04-30 | 1997 |     4




          WITH sales_monthly AS(
SELECT
    od.product_id,
    od.order_id,
    SUM(od.quantity),
    SUM(od.unit_price*od.quantity*(1-od.discount)) as total,
    o.order_date,
    DATE_PART('year', o.order_date) as year,
    DATE_PART('month',o.order_date) as month
    FROM order_details as od
    JOIN
    orders as o
    ON 
    od.order_id = o.order_id
    GROUP BY
    od.order_id,
    od.product_id,
    o.order_date
    ORDER BY
    od.product_id), 
    month_lag AS (
    SELECT *,
	LAG(s.total,1) OVER(PARTITION BY s.month ORDER BY s.total) as previous
    FROM sales_monthly as s)
    SELECT
    previous
    FROM
    month_lag;


         previous     
------------------
                 
 8.49999994039536
 8.64000032901764
 14.3999999463558
 14.4000005722046
 18.3999996185303
  20.799999922514
  24.820000474453
 26.4599996128678
 35.4000005722046
               36


