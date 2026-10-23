-- Ques:
-- Some forecasting methods are extremely simple and surprisingly effective. 
-- Naïve forecast is one of them. To create a naïve forecast for "distance per dollar" (defined as distance_to_travel/monetary_cost), 
-- first sum the "distance to travel" and "monetary cost" values monthly. This gives the actual value for the current month. 
-- For the forecasted value, use the previous month's value. 
-- After obtaining both actual and forecasted values, calculate the root mean squared error (RMSE) using the formula RMSE = sqrt(mean(square(actual - forecast))). 
-- Report the RMSE rounded to two decimal places.


EXPLAINATION :
1. monthly_aggregates CTE: Aggregates data monthly, grouping by year and month, and sums distance_to_travel as total_distance and monetary_cost as total_cost.
2. distance_per_dollar CTE: Computes the distance per dollar for each month from the aggregated data.
3. naive_forecast CTE: Calculates forecasted values for each month using the previous month's value with the LAG function.
4. Final SELECT Statement: Computes the (RMSE)