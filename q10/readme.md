Ques : 
Write a query that'll identify returning active users. 
A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. 
Output a list of user_ids of these returning active users.

EXPLAINATION :
1. transactions_record CTE:
Uses LEAD(created_at) partitioned by user_id to fetch the next purchase date for each row,
and ROW_NUMBER() to order each user's purchases chronologically.

2. Final SELECT:
Keeps only the first purchase of each user where the gap between the first and second
purchase is at most 7 days (DATEDIFF <= 7), and reports the days between them.