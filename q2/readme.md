Ques : 
Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue. 
The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, 
and sorted from the beginning of the year to the end of the year. 
The percentage change column will be populated from the 2nd month forward and calculated as : 
((this month’s revenue — last month’s revenue) / last month’s revenue)*100.

EXPLAINATION :
1. MonthlyRevenue CTE:
Aggregates the total revenue for each month using FORMAT to convert the created_at date to the format YYYY-MM.

2. RevenueChange CTE:
Adds a column previous_revenue using the LAG function, which fetches the total revenue of the previous month for each row.

3. Final SELECT:
Calculates the percentage change as ((total_revenue - previous_revenue) / previous_revenue) * 100. 
The ROUND function ensures the percentage is rounded to two decimal places. 
The output is ordered by year_month to display the data chronologically.
