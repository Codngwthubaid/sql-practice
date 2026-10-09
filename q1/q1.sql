-- ques : 
-- A table named “famous” has two columns called user id and follower id. It represents each user ID has a particular follower ID. 
-- These follower IDs are also users of #Facebook / #Meta. Then, find the famous percentage of each user. 
-- Famous Percentage = number of followers a user has / total number of users on the platform.

USE sql_de_practice;

CREATE TABLE IF NOT EXISTS famous (
	user_id 		INT,
    follower_id 	INT
);

INSERT INTO famous VALUES 
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3), 
(11, 7), (12, 8), (13, 5), (13, 10), 
(14, 12), (14, 3), (15, 14), (15, 13);

WITH follower_count AS (
	SELECT 
		user_id,
		COUNT(follower_id) AS follower_count
	FROM famous
	GROUP BY user_id
),
distinct_users AS (
	SELECT user_id AS users FROM famous
	UNION 
	SELECT follower_id AS users FROM famous
)
SELECT 
	fc.user_id,
    ROUND((fc.follower_count * 100) / (SELECT COUNT(*) FROM distinct_users), 2) AS follower_percentage
FROM follower_count AS fc;


