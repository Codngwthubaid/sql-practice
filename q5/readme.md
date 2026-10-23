-- Ques:
-- Some forecasting methods are extremely simple and surprisingly effective. 
-- Naïve forecast is one of them. To create a naïve forecast for "distance per dollar" (defined as distance_to_travel/monetary_cost), 
-- first sum the "distance to travel" and "monetary cost" values monthly. This gives the actual value for the current month. 
-- For the forecasted value, use the previous month's value. 
-- After obtaining both actual and forecasted values, calculate the root mean squared error (RMSE) using the formula RMSE = sqrt(mean(square(actual - forecast))). 
-- Report the RMSE rounded to two decimal places.


EXPLAINATION :
1. Joining Tables: The initial step involves joining the ms_projects and ms_emp_projects tables on the project ID to combine project details (including titles and budgets) with employee assignments.
2. Grouping and Aggregating: The data is then grouped by project title and budget, allowing for the calculation of budget per employee by dividing the total budget of each project by the count of employees assigned to that project.
3. Rounding and Ordering: Finally, the computed budget per employee is rounded to the nearest integer, and the results are ordered in descending order to prioritize projects with the highest budget allocation per employee.