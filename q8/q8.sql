-- ques : 
-- You are given a table of product launches by company by year. 
-- Write a query to count the net difference between the number of products companies launched in 2020 with the number of products companies launched in the previous year. 
-- Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

USE sql_de_practice;

CREATE TABLE car_launches(
	year int, 
	company_name varchar(15), 
    product_name varchar(30)
);

INSERT INTO car_launches VALUES
(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),
(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),
(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),(2020,'Chevrolet','Blazer'),
(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler');

SELECT * FROM car_launches;

WITH product_counts AS (
	SELECT 
		company_name,
		SUM(CASE WHEN year = 2019 THEN 1 ELSE 0 END) AS product_2019,
		SUM(CASE WHEN year = 2020 THEN 1 ELSE 0 END) AS product_2020
	FROM 
		car_launches
	WHERE 
		year IN (2019, 2020)
	GROUP BY 
		company_name
)
SELECT 
	company_name,
    (product_2020 - product_2019) AS net_difference
FROM 
	product_counts 
ORDER BY 
	net_difference DESC;