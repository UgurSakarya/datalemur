--Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.
--
--The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.
--user_transactions Table:
--									Column Name			Type
--									transaction_id		integer
--									product_id			integer
--									spend				decimal
--									transaction_date	datetime
--user_transactions Example Input:
--									transaction_id	product_id	spend	transaction_date
--									1341			123424		1500.60	12/31/2019 12:00:00
--									1423			123424		1000.20	12/31/2020 12:00:00
--									1623			123424		1246.44	12/31/2021 12:00:00
--									1322			123424		2145.32	12/31/2022 12:00:00
--Example Output:
--									year	product_id	curr_year_spend	prev_year_spend	yoy_rate
--									2019	  123424		1500.60			NULL		  NULL
--									2020	  123424		1000.20			1500.60		  -33.35
--									2021	  123424		1246.44			1000.20		  24.62
--									2022	  123424		2145.32			1246.44		  72.12
--Explanation:
--
--Product ID 123424 is analyzed for multiple years: 2019, 2020, 2021, and 2022.
--
--    In the year 2020, the current year's spend is 1000.20, and there is no previous year's spend recorded (indicated by an empty cell).
--    In the year 2021, the current year's spend is 1246.44, and the previous year's spend is 1000.20.
--    In the year 2022, the current year's spend is 2145.32, and the previous year's spend is 1246.44.
--
--To calculate the year-on-year growth rate, we compare the current year's spend with the previous year's spend.For instance, the spend grew by 24.62% from 2020 to 2021, indicating a positive growth rate.

-- SOLUTION
with curr_year as (SELECT 
DATE_TRUNC('YEAR', transaction_date) AS CURR_YEAR,
product_id,
sum(spend) as year_spend
FROM user_transactions
GROUP BY
DATE_TRUNC('YEAR', transaction_date),
DATE_TRUNC('YEAR', (transaction_date - INTERVAL '1 YEAR')),
product_id
)
SELECT 
EXTRACT(year from CURR.CURR_YEAR) AS YEAR,
CURR.PRODUCT_ID,
CURR.year_spend AS CURR_YEAR_SPEND,
PREV.year_spend AS PREV_YEAR_SPEND,
round(((CURR.year_spend / PREV.year_spend) -1) *100 , 2) AS yoy_rate
FROM
CURR_YEAR CURR
LEFT JOIN
CURR_YEAR PREV
ON
CURR.product_id = PREV.product_id AND
PREV.CURR_YEAR = DATE_TRUNC('YEAR', (CURR.CURR_YEAR - INTERVAL '1 YEAR'))
ORDER BY PRODUCT_ID, YEAR
;
