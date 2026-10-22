-- Ques : 
-- Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue. 
-- The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, 
-- and sorted from the beginning of the year to the end of the year. 
-- The percentage change column will be populated from the 2nd month forward and calculated as 
-- ((this month’s revenue — last month’s revenue) / last month’s revenue)*100.

USE sql_de_practice;

CREATE TABLE IF NOT EXISTS sf_transactions(
	id 				INT, 
    created_at 		DATETIME, 
    value 			INT, 
    purchase_id 	INT
);

INSERT INTO sf_transactions VALUES 
(1, '2019-01-01 00:00:00',  172692, 43), (2,'2019-01-05 00:00:00',  177194, 36),(3, '2019-01-09 00:00:00',  109513, 30),
(4, '2019-01-13 00:00:00',  164911, 30),(5, '2019-01-17 00:00:00',  198872, 39), (6, '2019-01-21 00:00:00',  184853, 31),
(7, '2019-01-25 00:00:00',  186817, 26), (8, '2019-01-29 00:00:00',  137784, 22),(9, '2019-02-02 00:00:00',  140032, 25), 
(10, '2019-02-06 00:00:00', 116948, 43), (11, '2019-02-10 00:00:00', 162515, 25), (12, '2019-02-14 00:00:00', 114256, 12), 
(13, '2019-02-18 00:00:00', 197465, 48), (14, '2019-02-22 00:00:00', 120741, 20), (15, '2019-02-26 00:00:00', 100074, 49), 
(16, '2019-03-02 00:00:00', 157548, 19), (17, '2019-03-06 00:00:00', 105506, 16), (18, '2019-03-10 00:00:00', 189351, 46), 
(19, '2019-03-14 00:00:00', 191231, 29), (20, '2019-03-18 00:00:00', 120575, 44), (21, '2019-03-22 00:00:00', 151688, 47), 
(22, '2019-03-26 00:00:00', 102327, 18), (23, '2019-03-30 00:00:00', 156147, 25);


SELECT * FROM sf_transactions;

WITH monthly_revenue AS (
	SELECT 
		SUM(value) AS total_revenue,
		DATE_FORMAT(created_at, '%Y-%m') AS date_by_year_month
	FROM sf_transactions
	GROUP BY DATE_FORMAT(created_at, '%Y-%m')
),
revenue_change AS (
	SELECT 
		date_by_year_month,
		total_revenue,
		LAG(total_revenue) 
			OVER(ORDER BY date_by_year_month) AS previous_revenue
	FROM monthly_revenue	
)
SELECT 
	rc.date_by_year_month,
    rc.total_revenue,
	ROUND( CASE 
			WHEN rc.previous_revenue IS NULL THEN NULL
			ELSE ((rc.total_revenue - rc.previous_revenue) * 100.0) / rc.previous_revenue
			END, 2
		) AS revenue_changing_percentage
FROM revenue_change AS rc
ORDER BY rc.date_by_year_month;
