Ques : 
A table named “famous” has two columns called user id and follower id. 
It represents each user ID has a particular follower ID. 
These follower IDs are also users of #Facebook / #Meta. Then, find the famous percentage of each user. 
Famous Percentage = number of followers a user has / total number of users on the platform.

Explaination : 
1. distinct_users CTE:
Combines user_id and follower_id using UNION to get all unique users on the platform. 
This helps us determine the total number of users.

2. follower_count CTE:
Counts the number of followers for each user_id by grouping the rows in the famous table. 
This gives a list of users with their follower counts.

3. Final SELECT Statement:
Uses the data from follower_count and distinct_users to calculate the famous percentage for each user.
