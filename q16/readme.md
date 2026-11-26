Ques : 
Bank of Ireland has requested that you detect invalid transactions in December 2022. 
An invalid transaction is one that occurs outside of the bank's normal business hours. The following are the hours of operation for all branches:
Monday - Friday 09:00 - 16:00
Saturday & Sunday Closed
Irish Public Holidays 25th and 26th December
Determine the transaction ids of all invalid transactions.

EXPLAINATION :
1. Date Filtering:
Restricts boi_transactions to December 2022 using EXTRACT(MONTH ...) = 12 and EXTRACT(YEAR ...) = 2022.

2. Weekend Check:
Uses DAYOFWEEK(time_stamp) IN (1, 7) to match Sunday and Saturday, when all branches are closed.

3. Business Hours Check:
Casts time_stamp to TIME and compares it with the 09:00-16:00 window. Anything before 09:00 or after 16:00 is outside normal business hours.

4. Public Holidays:
The 25th and 26th of December are also non-working days, so transactions on those dates are invalid regardless of the time. This rule is not implemented in the current script.

5. Current Script:
The query as written applies the date and weekend checks only to the "before 09:00" branch. Because AND has higher precedence than OR, transactions after 16:00 are returned even on weekdays, while weekend transactions during 09:00-16:00 and the public holidays are missed. The main README lists the full expected result and the corrected WHERE clause.
