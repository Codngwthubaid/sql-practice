Ques : 
Find the number of transactions that occurred for each product. 
Output the product name along with the corresponding number of transactions and order records by the product id in ascending order. 
You can ignore products without transactions.

EXPLAINATION :
1. Joining Tables:
Joins excel_sql_inventory_data and excel_sql_transaction_data on product_id to combine
product details with their transaction records.

2. Grouping and Aggregating:
Groups by product_id and product_name, and uses COUNT(transaction_id) to count the
transactions for each product.

3. Sorting the Results:
Orders the results by product_id in ascending order.