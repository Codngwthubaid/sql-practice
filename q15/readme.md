Ques : 
Find all records from days when the number of distinct users receiving emails was greater than the number of distinct users sending emails.

EXPLAINATION :
1. distinct_data CTE:
Groups google_gmail_emails by day and counts the distinct from_user (senders) and
distinct to_user (receivers) for each day.

2. Final SELECT:
Joins the emails back to the per-day aggregates and keeps only the rows whose day
has more distinct receivers than senders.