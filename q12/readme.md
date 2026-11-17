Ques : 
Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. 
Output just the absolute difference in salaries.

EXPLAINATION :
1. Joining Tables:
Left joins db_dept and db_employee on department_id to attach each employee's salary to its department.

2. Conditional Aggregation:
Uses MAX(CASE WHEN department = 'marketing' THEN salary END) and
MAX(CASE WHEN department = 'engineering' THEN salary END) to extract the highest salary
in each department.

3. Final SELECT:
Subtracts the two maximum salaries to get the difference.