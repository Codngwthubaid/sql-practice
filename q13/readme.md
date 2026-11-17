Ques : 
Find the number of rows for each review score earned by 'Hotel Arena'. 
Output the hotel name (which should be 'Hotel Arena'), review score along with the corresponding number of rows with that score for the specified hotel.

EXPLAINATION :
1. Filtering:
Filters hotel_reviews to only rows where hotel_name = 'Hotel Arena'.

2. Grouping and Aggregating:
Groups by hotel_name and reviewer_score, and uses COUNT(*) to count the rows for each score.

3. Sorting the Results:
Orders the results by reviewer_score in ascending order.