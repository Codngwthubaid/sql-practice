Ques : 
You are given a table of product launches by company by year. 
Write a query to count the net difference between the number of products companies launched in 2020 
with the number of products companies launched in the previous year. 
Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

EXPLAINATION :
1. product_counts CTE:
Counts the number of products launched by each company in 2019 and 2020 using conditional
aggregation with SUM(CASE WHEN year = ... THEN 1 ELSE 0 END), grouped by company_name.

2. Final SELECT:
Subtracts the 2019 count from the 2020 count to get the net difference, and sorts the
result in descending order so the largest net gain appears first.