Ques : 
You're given a table of Uber rides that contains the mileage and the purpose for the business expense.
You're asked to find business purposes that generate the most miles driven for passengers that use Uber for their business transportation.
Find the top 3 business purpose categories by total mileage.

EXPLAINATION :
1. Window Aggregation:
Uses SUM(miles) OVER (PARTITION BY purpose ORDER BY miles DESC) to calculate a running total of miles for each purpose, starting from the longest ride.

2. Ordering and Limiting:
Orders the individual rides by miles descending and keeps the top 3 rows with LIMIT 3.

3. Note:
Because the script orders individual rides instead of purpose totals, it does not answer the question as stated. A correct solution groups by purpose, sums the miles, orders by that total descending, and limits the result to 3 rows. The main README shows the expected output of the script as written and the intended query.
