Ques : 
You are analyzing a social network dataset at Google. 
Your task is to find mutual friends between two users, Karl and Hans. 
There is only one user named Karl and one named Hans in the dataset.
The output should contain 'user_id' and 'user_name' columns.

EXPLAINATION :
1. The CTEs (karl_friend and hans_friend) efficiently find all friends for Karl and Hans, respectively.

2. The main query joins these CTEs with the users table to find the users who are present in both Karl's and Hans's friend lists (mutual friends).