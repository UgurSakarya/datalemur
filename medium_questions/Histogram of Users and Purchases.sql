--Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.
--
--Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.
--
--Starting from November 10th, 2022, the official solution was updated, and the expected output of transaction date, number of users, and number of products was changed to the current expected output.
--user_transactions Table:
--									Column Name			Type
--									product_id			integer
--									user_id				integer
--									spend				decimal
--									transaction_date	timestamp
--user_transactions Example Input:
--									product_id	user_id	spend	transaction_date
--									3673		  123	68.90	07/08/2022 12:00:00
--									9623		  123	274.10	07/08/2022 12:00:00
--									1467		  115	19.90	07/08/2022 12:00:00
--									2513		  159	25.00	07/08/2022 12:00:00
--									1452		  159	74.50	07/10/2022 12:00:00
--Example Output:
--									transaction_date		user_id	purchase_count
--									07/08/2022 12:00:00		115			1
--									07/08/2022 12:00:000	123			2
--									07/10/2022 12:00:00		159			1

-- SOLUTION
with cte as (
SELECT 
transaction_date,
product_id,
user_id,
rank() over(partition by user_id order by transaction_date desc) as trx_rank
FROM user_transactions
)
select 
transaction_date,
user_id,
count(product_id) as purchase_count
from 
cte where trx_rank = 1
group by transaction_date, user_id
;
