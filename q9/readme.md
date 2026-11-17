Ques : 
Find the genre of the person with the most number of oscar winnings.
If there are more than one person with the same number of oscar wins, return the first one in alphabetic order based on their name. 
Use the names as keys when joining the tables.

EXPLAINATION :
1. winner_details CTE:
Joins nominee_information and oscar_nominees on name, groups by nominee and top_genre,
and sums the winner column to get each person's Oscar win count.

2. Final SELECT:
Filters the rows whose win_count equals the maximum win_count (found via a subquery),
returning the genre of the most-winning person.