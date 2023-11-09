--A Microsoft Azure Supercloud customer is defined as a company that purchases at least one product from each product category.
--
--Write a query that effectively identifies the company ID of such Supercloud customers.
--
--As of 5 Dec 2022, data in the customer_contracts and products tables were updated.
--customer_contracts Table:
--							Column Name	Type
--							customer_id	integer
--							product_id	integer
--							amount		integer
--customer_contracts Example Input:
--							customer_id	product_id	amount
--							1				1		1000
--							1				3		2000
--							1				5		1500
--							2				2		3000
--							2				6		2000
--products Table:
--							Column Name			Type
--							product_id			integer
--							product_category	string
--							product_name		string
--products Example Input:
--							product_id	product_category	product_name
--							1				Analytics		Azure Databricks
--							2				Analytics		Azure Stream Analytics
--							4				Containers		Azure Kubernetes Service
--							5				Containers		Azure Service Fabric
--							6				Compute			Virtual Machines
--							7				Compute			Azure Functions
--Example Output:
--							customer_id
--								1
--Explanation:
--
--Customer 1 bought from Analytics, Containers, and Compute categories of Azure, and thus is a Supercloud customer. Customer 2 isn't a Supercloud customer, since they don't buy any container services from Azure.

-- SOLUTION   
with prod_cat as (SELECT 
cc.customer_id,
count(distinct p.product_category) as uniq_prod
FROM customer_contracts cc
inner JOIN products p
on cc.product_id = p.product_id
group by cc.customer_id
)
SELECT
customer_id
from prod_cat
where 
uniq_prod = (select count(distinct product_category) from products);
