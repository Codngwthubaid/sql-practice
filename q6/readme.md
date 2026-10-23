-- Ques : Airbnb
-- Find the total number of available beds per hosts' nationality.
-- Output the nationality along with the corresponding total number of available beds.
-- Sort records by the total available beds in descending order.


EXPLAINATION :
1. Joining Tables: The first step involves joining the airbnb_apartments and airbnb_hosts tables on the host_id. This allows us to combine the apartment details (such as the number of beds) with the host's nationality information.
2. Grouping and Aggregating: Next, the data is grouped by the host's nationality, so that the total number of beds available for each nationality can be calculated. The SUM() function is used to add up the beds (n_beds) for all apartments hosted by individuals of the same nationality.
3. Sorting the Results: Finally, the results are ordered in descending order based on the total number of available beds. This ensures that nationalities with the highest number of available beds appear at the top of the list.