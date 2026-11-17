# SQL Data Engineering Practice

A practice repository for SQL / data-engineering style problems (interview- and
exercise-style). Every problem lives in its own numbered folder and is completely
self-contained: it creates its tables, seeds sample data, and answers the question
in a single runnable script.

Each problem folder follows the same convention:

| File | Purpose |
|------|---------|
| `qN.sql` | Schema (`CREATE TABLE`), seed data (`INSERT`), and the solution query |
| `readme.md` | The original question plus a step-by-step explanation of the approach |

---

## Repository Structure

```
sql_de_practice/
├── README.md          <- you are here (index + explanations)
├── q1/
│   ├── q1.sql         <- famous percentage per user
│   └── readme.md      <- question + explanation
├── q2/
│   ├── q2.sql         <- month-over-month revenue change
│   └── readme.md      <- question + explanation
├── q3/
│   ├── q3.sql         <- mutual friends between two users
│   └── readme.md      <- question + explanation
├── q4/
│   ├── q4.sql         <- naïve forecast RMSE for distance per dollar
│   └── readme.md      <- question + explanation
├── q5/
│   ├── q5.sql         <- project budget per employee
│   └── readme.md      <- question + explanation
├── q6/
│   ├── q6.sql         <- available beds by host nationality
│   └── readme.md      <- question + explanation
└── q7/
    ├── q7.sql         <- average spend on first-quarter Fridays
    └── readme.md      <- question + explanation
├── q8/
│   ├── q8.sql         <- net difference in product launches (2020 vs 2019)
│   └── readme.md      <- question + explanation
├── q9/
│   ├── q9.sql         <- genre of the most Oscar-winning person
│   └── readme.md      <- question + explanation
├── q10/
│   ├── q10.sql        <- returning active users (2nd purchase within 7 days)
│   └── readme.md      <- question + explanation
├── q11/
│   ├── q11.sql        <- transaction count per product
│   └── readme.md      <- question + explanation
├── q12/
│   ├── q12.sql        <- salary difference between marketing and engineering
│   └── readme.md      <- question + explanation
├── q13/
│   ├── q13.sql        <- review score counts for Hotel Arena
│   └── readme.md      <- question + explanation
├── q14/
│   ├── q14.sql        <- total sales revenue of Samantha and Lisa
│   └── readme.md      <- question + explanation
└── q15/
    ├── q15.sql        <- days with more distinct email receivers than senders
    └── readme.md      <- question + explanation
```

---

## Problem Index

| # | Problem | Key SQL concepts | Solution |
|---|---------|------------------|----------|
| [Q1](#q1--famous-percentage-per-user) | Famous percentage of each user in a social graph | CTE, `UNION`, `GROUP BY`, scalar subquery, `ROUND` | [q1/q1.sql](q1/q1.sql) |
| [Q2](#q2--month-over-month-revenue-change) | Month-over-month % change in revenue | CTE, `LAG()` window function, `DATE_FORMAT`, `CASE` for NULLs | [q2/q2.sql](q2/q2.sql) |
| [Q3](#q3--mutual-friends-between-two-users) | Mutual friends of Karl and Hans | CTE, correlated scalar subquery, self-join, `INNER JOIN` | [q3/q3.sql](q3/q3.sql) |
| [Q4](#q4--naive-forecast-rmse) | Naïve forecast RMSE for distance per dollar | CTE, monthly aggregation, `LAG()`, `POWER`, `SQRT`, `AVG` | [q4/q4.sql](q4/q4.sql) |
| [Q5](#q5--project-budget-per-employee) | Project budget allocated per employee | `LEFT JOIN`, `COUNT`, `GROUP BY`, `ROUND`, `ORDER BY` | [q5/q5.sql](q5/q5.sql) |
| [Q6](#q6--available-beds-by-host-nationality) | Total available beds per host nationality | `LEFT JOIN`, `SUM`, `GROUP BY`, descending sort | [q6/q6.sql](q6/q6.sql) |
| [Q7](#q7--average-spend-on-q1-fridays) | Average spend per order on first-quarter Fridays | CTE, date filtering, `EXTRACT`, `AVG`, `GROUP BY` | [q7/q7.sql](q7/q7.sql) |
| [Q8](#q8--net-difference-in-product-launches-2020-vs-2019) | Net difference in products launched in 2020 vs 2019 by company | Conditional aggregation (`CASE`), `GROUP BY`, `ORDER BY` | [q8/q8.sql](q8/q8.sql) |
| [Q9](#q9--genre-of-the-most-oscar-winning-person) | Genre of the person with the most Oscar wins | `INNER JOIN`, `GROUP BY`, aggregate subquery (`MAX`), `ORDER BY` | [q9/q9.sql](q9/q9.sql) |
| [Q10](#q10--returning-active-users) | Users with a second purchase within 7 days | Window functions (`LEAD`, `ROW_NUMBER`), `PARTITION BY`, `DATEDIFF` | [q10/q10.sql](q10/q10.sql) |
| [Q11](#q11--transaction-count-per-product) | Number of transactions per product | `INNER JOIN`, `COUNT`, `GROUP BY`, `ORDER BY` | [q11/q11.sql](q11/q11.sql) |
| [Q12](#q12--salary-difference-between-marketing-and-engineering) | Difference between highest marketing and engineering salaries | Conditional aggregation (`MAX(CASE)`), `LEFT JOIN`, `ABS` | [q12/q12.sql](q12/q12.sql) |
| [Q13](#q13--review-score-counts-for-hotel-arena) | Review score counts for Hotel Arena | `WHERE`, `GROUP BY`, `COUNT`, `ORDER BY` | [q13/q13.sql](q13/q13.sql) |
| [Q14](#q14--total-sales-revenue-of-samantha-and-lisa) | Total sales revenue of Samantha and Lisa | `SUM`, `WHERE ... IN` | [q14/q14.sql](q14/q14.sql) |
| [Q15](#q15--days-with-more-distinct-email-receivers-than-senders) | Days where distinct email receivers exceed distinct senders | `COUNT(DISTINCT)`, `GROUP BY`, `JOIN`, comparison | [q15/q15.sql](q15/q15.sql) |

---

## Setup

The scripts target **MySQL** (MySQL 8.x / MariaDB 10.x) and all of them start with
`USE sql_de_practice;`, so the database must exist before running them.

```sql
CREATE DATABASE IF NOT EXISTS sql_de_practice;
```

Run any problem with:

```bash
mysql -u <user> -p < q1/q1.sql
```

Or from inside the MySQL client:

```sql
SOURCE q1/q1.sql;
```

Every script is idempotent for the table definitions (`CREATE TABLE IF NOT EXISTS`)
and re-runnable for the queries, so you can experiment freely.

---

## Q1 — Famous Percentage per User

> A table named `famous` has two columns, `user_id` and `follower_id`. It represents
> each user ID having a particular follower ID. These follower IDs are also users of
> the platform. Find the famous percentage of each user.
>
> **Famous Percentage = number of followers a user has / total number of users on the platform.**

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `distinct_users` | `UNION`s `user_id` and `follower_id` to get every unique person on the platform, giving the **total user count** (13 in the sample data) |
| 2 | `follower_count` | `GROUP BY user_id` + `COUNT(follower_id)` to get the **follower count** per user |
| 3 | Final `SELECT` | Joins the two: `follower_count * 100 / total_users`, rounded to 2 decimals |

### Solution

```sql
WITH follower_count AS (
	SELECT user_id, COUNT(follower_id) AS follower_count
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
	ROUND((fc.follower_count * 100.0) / (SELECT COUNT(*) FROM distinct_users), 2) AS follower_percentage
FROM follower_count AS fc;
```

### Expected output

| user_id | follower_percentage |
|---------|---------------------|
| 1 | 15.38 |
| 2 | 7.69 |
| 5 | 15.38 |
| 11 | 7.69 |
| 12 | 7.69 |
| 13 | 15.38 |
| 14 | 15.38 |
| 15 | 15.38 |

> **Note:** only users who *have* at least one follower appear. Users that exist in
> the platform but are never followed (e.g. `3`, `4`, `7`, `8`, `10` in the sample
> data) are counted in the denominator but have no row in the result. Add a
> `LEFT JOIN` against `distinct_users` if they should be listed with `0.00`.

---

## Q2 — Month-over-Month Revenue Change

> Given a table `sf_transactions` of purchases by date, calculate the month-over-month
> percentage change in revenue. The output should include the year-month date
> (`YYYY-MM`) and percentage change rounded to 2 decimal points, sorted from the
> beginning of the year to the end of the year. The percentage change column is
> populated from the 2nd month forward:
>
> `((this month's revenue - last month's revenue) / last month's revenue) * 100`

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `monthly_revenue` | `SUM(value)` grouped by `DATE_FORMAT(created_at, '%Y-%m')` to get one revenue figure per month |
| 2 | `revenue_change` | `LAG(total_revenue) OVER (ORDER BY date_by_year_month)` pulls the previous month's revenue alongside each row |
| 3 | Final `SELECT` | Computes the % change, guarding the first month with a `CASE` so it stays `NULL` instead of erroring on division by zero |

### Solution

```sql
WITH monthly_revenue AS (
	SELECT
		SUM(value) AS total_revenue,
		DATE_FORMAT(created_at, '%Y-%m') AS date_by_year_month
	FROM sf_transactions
	GROUP BY DATE_FORMAT(created_at, '%Y-%m')
),
revenue_change AS (
	SELECT
		date_by_year_month,
		total_revenue,
		LAG(total_revenue) OVER (ORDER BY date_by_year_month) AS previous_revenue
	FROM monthly_revenue
)
SELECT
	rc.date_by_year_month,
	rc.total_revenue,
	ROUND(
		CASE
			WHEN rc.previous_revenue IS NULL THEN NULL
			ELSE ((rc.total_revenue - rc.previous_revenue) * 100.0) / rc.previous_revenue
		END, 2
	) AS revenue_changing_percentage
FROM revenue_change AS rc
ORDER BY rc.date_by_year_month;
```

### Expected output

| date_by_year_month | total_revenue | revenue_changing_percentage |
|--------------------|---------------|-----------------------------|
| 2019-01 | 1332636 | *(null — first month)* |
| 2019-02 | 952031 | -28.56 |
| 2019-03 | 1174373 | 23.35 |

---

## Q3 — Mutual Friends Between Two Users

> You are analyzing a social network dataset. Find the mutual friends between two
> users, **Karl** and **Hans**. There is only one user named Karl and one named Hans.
> The output should contain `user_id` and `user_name` columns.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `karl_friend` | Resolves `user_name = 'Karl'` to a `user_id` via a scalar subquery, then lists that user's `friend_id`s |
| 2 | `hans_friend` | Same for Hans |
| 3 | Final `SELECT` | `INNER JOIN`s both CTEs to `users` on `user_id` — a user survives only if they are in **both** friend lists, i.e. a mutual friend |

### Solution

```sql
WITH karl_friend AS (
	SELECT friend_id
	FROM friends
	WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Karl')
),
hans_friend AS (
	SELECT friend_id
	FROM friends
	WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Hans')
)
SELECT
	u.user_id,
	u.user_name
FROM users AS u
INNER JOIN karl_friend AS kf ON u.user_id = kf.friend_id
INNER JOIN hans_friend AS hf ON u.user_id = hf.friend_id;
```

### Expected output

| user_id | user_name |
|---------|-----------|
| 3 | Emma |

---

## Q4 — Naive Forecast RMSE

> Some forecasting methods are extremely simple and surprisingly effective.
> Naïve forecast is one of them. To create a naïve forecast for "distance per
> dollar" (defined as `distance_to_travel / monetary_cost`), first sum the
> "distance to travel" and "monetary cost" values monthly. This gives the actual
> value for the current month. For the forecasted value, use the previous month's
> value. After obtaining both actual and forecasted values, calculate the root
> mean squared error (RMSE) using the formula
> `RMSE = sqrt(mean(square(actual - forecast)))`. Report the RMSE rounded to two
> decimal places.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `monthly_aggregates` | `SUM`s distance and cost per month and rounds each total to 2 decimals |
| 2 | `distance_per_dollar` | Divides the monthly distance by the monthly cost to get the actual value |
| 3 | `naive_forecast` | `LAG(distance_per_dollar) OVER (ORDER BY mentioned_month)` supplies the previous month's value as the forecast |
| 4 | Final `SELECT` | Drops the first month (no forecast), squares each `actual - forecast`, takes the `AVG`, then applies `SQRT` and `ROUND(..., 2)` |

### Solution

```sql
WITH monthly_aggregates AS (
	SELECT
		EXTRACT(MONTH FROM request_date) AS mentioned_month,
		ROUND(SUM(distance_to_travel), 2) AS total_distance,
		ROUND(SUM(monetary_cost), 2) AS total_cost
	FROM
		uber_request_logs
	GROUP BY
		EXTRACT(MONTH FROM request_date)
),
distance_per_dollar AS (
	SELECT
		mentioned_month,
		ROUND((total_distance / total_cost), 2) AS distance_per_dollar
	FROM
		monthly_aggregates
),
naive_forecast AS (
	SELECT
		mentioned_month,
        distance_per_dollar,
        LAG(distance_per_dollar, 1)
			OVER(
				ORDER BY
					mentioned_month
            ) AS forecast_value
	FROM
		distance_per_dollar
)
SELECT
	ROUND(SQRT(AVG(POWER((distance_per_dollar - forecast_value), 2))), 2) AS RMSE
FROM
	naive_forecast
WHERE
	forecast_value IS NOT NULL;
```

### Expected output

| RMSE |
|------|
| 2.34 |

> **Note:** January has no previous month, so it is excluded from the RMSE. The
> query groups by month number only, which is fine for the single-year sample
> data; a multi-year dataset should group and order by year-month instead (for
> example, `DATE_FORMAT(request_date, '%Y-%m')`).

---

## Q5 — Project Budget per Employee

> Given a list of projects and employees mapped to each project, calculate the
> amount of project budget allocated to each employee. The output should include
> the project title and the project budget rounded to the closest integer. Order
> your list by projects with the highest budget per employee first.

### Approach

| Step | Clause | What it does |
|------|--------|--------------|
| 1 | `LEFT JOIN` | Joins each project to its employee assignments on `project_id`, keeping projects even when they have no employees |
| 2 | `GROUP BY` | Groups by project ID, title, and budget so each project produces one row |
| 3 | `COUNT` | Counts the employees assigned to the project |
| 4 | Final `SELECT` | Divides the project budget by the employee count, rounds to the nearest integer, and sorts highest first |

### Solution

```sql
SELECT
	msp.id AS project_id,
	msp.title AS project_title,
    ROUND(msp.budget / COUNT(msempp.emp_id), 0) AS project_per_budget
FROM
	ms_projects AS msp
LEFT JOIN ms_emp_projects AS msempp
	ON msp.id = msempp.project_id
GROUP BY
	msp.id,
    msp.title,
    msp.budget
ORDER BY
	project_per_budget DESC;
```

### Expected output

| project_id | project_title | project_per_budget |
|------------|---------------|--------------------|
| 8 | Project8 | 49284 |
| 15 | Project15 | 48116 |
| 10 | Project10 | 47587 |
| 19 | Project19 | 44986 |
| 3 | Project3 | 43909 |
| 13 | Project13 | 43238 |
| 6 | Project6 | 41611 |
| 5 | Project5 | 36268 |
| 7 | Project7 | 34003 |
| 2 | Project2 | 32487 |
| 9 | Project9 | 32341 |
| 14 | Project14 | 30014 |
| 1 | Project1 | 29498 |
| 16 | Project16 | 19922 |
| 20 | Project20 | 19497 |
| 17 | Project17 | 19061 |
| 4 | Project4 | 15776 |
| 11 | Project11 | 11705 |
| 12 | Project12 | 10468 |
| 18 | Project18 | 10302 |

> **Note:** every project in the sample data has exactly one assigned employee,
> so the budget per employee equals the project budget. With multiple employees
> the division changes the ranking accordingly.

---

## Q6 — Available Beds by Host Nationality

> Find the total number of available beds per hosts' nationality. Output the
> nationality along with the corresponding total number of available beds. Sort
> records by the total available beds in descending order.

### Approach

| Step | Clause | What it does |
|------|--------|--------------|
| 1 | `LEFT JOIN` | Joins `airbnb_apartments` to `airbnb_hosts` on `host_id` to attach each listing to its host's nationality |
| 2 | `GROUP BY` | Groups all apartments by host nationality |
| 3 | `SUM` | Adds up `n_beds` across the apartments for each nationality |
| 4 | `ORDER BY` | Sorts by total available beds, highest first |

### Solution

```sql
SELECT
	SUM(aa.n_beds) AS available_beds,
    ah.nationality AS host_nationality
FROM
	airbnb_apartments AS aa
LEFT JOIN airbnb_hosts AS ah
	ON aa.host_id = ah.host_id
GROUP BY
	ah.nationality
ORDER BY
	available_beds DESC;
```

### Expected output

| available_beds | host_nationality |
|----------------|------------------|
| 8 | China |
| 7 | USA |
| 5 | Mali |

> **Note:** the `LEFT JOIN` is driven by the apartments table, so hosts with no
> listings (such as host `2` in the sample data) do not appear in the result.

---

## Q7 — Average Spend on Q1 Fridays

> IBM is working on a new feature to analyze user purchasing behavior for all
> Fridays in the first quarter of the year. For each Friday separately, calculate
> the average amount users have spent per order. The output should contain the
> week number of that Friday and average amount spent.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `q1_fridays` | Keeps only purchases in January–March (`EXTRACT(MONTH ...) IN (1, 2, 3)`) whose `day_name` is `'Friday'`, and labels each row with a `week_number` |
| 2 | Final `SELECT` | Groups by `week_number`, averages the spend per order, rounds to 2 decimals, and sorts by week |

### Solution

```sql
WITH q1_fridays AS (
	SELECT
		user_id,
        date,
        amount_spent,
		EXTRACT(MONTH FROM date) AS week_number
	FROM
		user_purchases
	WHERE
		EXTRACT(MONTH FROM date) IN (1,2,3)
		AND day_name = 'Friday'
)
SELECT
	week_number,
    ROUND(AVG(amount_spent), 2) AS avg_amount_spend
FROM
	q1_fridays
GROUP BY
	week_number
ORDER BY
	week_number;
```

### Expected output

| week_number | avg_amount_spend |
|-------------|------------------|
| 1 | 636.33 |
| 2 | 479.67 |

> **Note:** in the current script, `week_number` is actually
> `EXTRACT(MONTH FROM date)`, so the query groups all Fridays in a month together
> and returns month numbers rather than ISO week numbers. The output above
> reflects the script as written. To group by the literal week of each Friday,
> use `WEEK(date, 3)` (or `WEEKOFYEAR(date)`) as the grouping key.

## Q8 — Net Difference in Product Launches (2020 vs 2019)

> You are given a table of product launches by company by year. Write a query to count
> the net difference between the number of products companies launched in 2020 with
> the number of products companies launched in the previous year. Output the name of
> the companies and a net difference of net products released for 2020 compared to
> the previous year.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `product_counts` | Conditional `SUM(CASE WHEN year = ...)` counts each company's launches in 2019 and 2020 |
| 2 | Final `SELECT` | Subtracts the 2019 count from the 2020 count and sorts the net difference descending |

### Solution

```sql
WITH product_counts AS (
	SELECT
		company_name,
		SUM(CASE WHEN year = 2019 THEN 1 ELSE 0 END) AS product_2019,
		SUM(CASE WHEN year = 2020 THEN 1 ELSE 0 END) AS product_2020
	FROM
		car_launches
	WHERE
		year IN (2019, 2020)
	GROUP BY
		company_name
)
SELECT
	company_name,
	(product_2020 - product_2019) AS net_difference
FROM
	product_counts
ORDER BY
	net_difference DESC;
```

### Expected output

| company_name | net_difference |
|--------------|----------------|
| Chevrolet | 2 |
| Jeep | 1 |
| Toyota | -1 |
| Ford | -1 |
| Honda | -3 |

---

## Q9 — Genre of the Most Oscar-Winning Person

> Find the genre of the person with the most number of oscar winnings. If there are
> more than one person with the same number of oscar wins, return the first one in
> alphabetic order based on their name. Use the names as keys when joining the
> tables.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `winner_details` | Joins `nominee_information` to `oscar_nominees` on `name`, groups by nominee and genre, and `SUM`s `winner` |
| 2 | Final `SELECT` | Keeps only rows whose `win_count` equals the overall `MAX(win_count)` |

### Solution

```sql
WITH winner_details AS (
	SELECT
		ni.top_genre AS genre,
		ons.nominee AS nominee_names,
		SUM(ons.winner) AS win_count
	FROM
		nominee_information AS ni
	INNER JOIN oscar_nominees AS ons
		ON ni.name = ons.nominee
	GROUP BY
		ons.nominee,
		ni.top_genre
)
SELECT
	genre
FROM
	winner_details
WHERE
	win_count = (
		SELECT
			MAX(win_count)
		FROM
			winner_details
	);
```

### Expected output

| genre |
|-------|
| Drama |

---

## Q10 — Returning Active Users

> Write a query that'll identify returning active users. A returning active user is
> a user that has made a second purchase within 7 days of any other of their
> purchases. Output a list of user_ids of these returning active users.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `transactions_record` | `LEAD(created_at)` per user gives the next purchase date; `ROW_NUMBER()` orders each user's purchases |
| 2 | Final `SELECT` | Keeps the first purchase of each user where the gap to the second purchase is at most 7 days |

### Solution

```sql
WITH transactions_record AS (
	SELECT
		user_id,
		created_at AS first_purchased,
		LEAD(created_at) OVER (
			PARTITION BY user_id
			ORDER BY created_at
		) AS second_purchased,
		ROW_NUMBER() OVER (
			PARTITION BY user_id
			ORDER BY created_at
		) AS purchased_num
	FROM
		amazon_transactions
)
SELECT
	user_id,
	first_purchased,
	second_purchased,
	DATEDIFF(second_purchased, first_purchased) AS days_between
FROM
	transactions_record
WHERE
	purchased_num = 1
	AND
	DATEDIFF(second_purchased, first_purchased) <= 7;
```

### Expected output

| user_id | first_purchased | second_purchased | days_between |
|---------|-----------------|------------------|--------------|
| 122 | 2020-03-06 00:00:00 | 2020-03-07 00:00:00 | 1 |

---

## Q11 — Transaction Count per Product

> Find the number of transactions that occurred for each product. Output the product
> name along with the corresponding number of transactions and order records by the
> product id in ascending order. You can ignore products without transactions.

### Approach

| Step | Clause | What it does |
|------|--------|--------------|
| 1 | `INNER JOIN` | Joins inventory to transactions on `product_id` |
| 2 | `GROUP BY` | Groups by product id and name |
| 3 | `COUNT` | Counts transactions per product |
| 4 | `ORDER BY` | Sorts by product id ascending |

### Solution

```sql
SELECT
	id.product_name AS product_name,
	COUNT(td.transaction_id) AS transcations_count
FROM
	excel_sql_inventory_data AS id
INNER JOIN excel_sql_transaction_data AS td
	ON id.product_id = td.product_id
GROUP BY
	id.product_id,
	id.product_name
ORDER BY
	id.product_id;
```

### Expected output

| product_name | transcations_count |
|--------------|--------------------|
| strawberry | 3 |
| apple_fuji | 1 |
| orange | 3 |
| clementines | 1 |
| blood_orange | 2 |

---

## Q12 — Salary Difference Between Marketing and Engineering

> Write a query that calculates the difference between the highest salaries found
> in the marketing and engineering departments. Output just the absolute difference
> in salaries.

### Approach

| Step | Clause | What it does |
|------|--------|--------------|
| 1 | `LEFT JOIN` | Joins `db_dept` to `db_employee` on department id |
| 2 | Conditional aggregation | `MAX(CASE WHEN department = 'marketing' ...)` and `MAX(CASE WHEN department = 'engineering' ...)` extract each department's top salary |
| 3 | Final `SELECT` | Subtracts the two maxima |

### Solution

```sql
SELECT
	(MAX(CASE WHEN d.department = "marketing" THEN e.salary END) -
	 MAX(CASE WHEN d.department = "engineering" THEN e.salary END)) AS salary_difference
FROM
	db_dept AS d
LEFT JOIN db_employee AS e
	ON d.id = e.department_id;
```

### Expected output

| salary_difference |
|-------------------|
| 13285 |

---

## Q13 — Review Score Counts for Hotel Arena

> Find the number of rows for each review score earned by 'Hotel Arena'. Output the
> hotel name (which should be 'Hotel Arena'), review score along with the
> corresponding number of rows with that score for the specified hotel.

### Approach

| Step | Clause | What it does |
|------|--------|--------------|
| 1 | `WHERE` | Filters rows where `hotel_name = 'Hotel Arena'` |
| 2 | `GROUP BY` | Groups by hotel name and reviewer score |
| 3 | `COUNT(*)` | Counts rows per score |
| 4 | `ORDER BY` | Sorts by reviewer score |

### Solution

```sql
SELECT
	hotel_name,
	reviewer_score,
	COUNT(*) AS score_count
FROM
	hotel_reviews
WHERE
	hotel_name = "Hotel Arena"
GROUP BY
	hotel_name,
	reviewer_score
ORDER BY
	reviewer_score;
```

### Expected output

| hotel_name | reviewer_score | score_count |
|------------|----------------|-------------|
| Hotel Arena | 6 | 1 |
| Hotel Arena | 8 | 1 |
| Hotel Arena | 9 | 1 |

---

## Q14 — Total Sales Revenue of Samantha and Lisa

> What is the total sales revenue of Samantha and Lisa?

### Approach

| Step | Clause | What it does |
|------|--------|--------------|
| 1 | `WHERE ... IN` | Filters rows for Samantha and Lisa |
| 2 | `SUM` | Adds their `sales_revenue` |

### Solution

```sql
SELECT
	SUM(sales_revenue) AS total_sales_revenue
FROM
	sales_performance
WHERE
	salesperson IN ('Samantha', 'Lisa');
```

### Expected output

| total_sales_revenue |
|---------------------|
| 112650 |

---

## Q15 — Days With More Distinct Email Receivers Than Senders

> Find all records from days when the number of distinct users receiving emails
> was greater than the number of distinct users sending emails.

### Approach

| Step | CTE | What it does |
|------|-----|--------------|
| 1 | `distinct_data` | `COUNT(DISTINCT from_user)` and `COUNT(DISTINCT to_user)` per day |
| 2 | Final `SELECT` | Joins emails back to the per-day aggregates and keeps rows whose day has more distinct receivers than senders |

### Solution

```sql
WITH distinct_data AS (
	SELECT
		day,
		COUNT(DISTINCT from_user) AS distinct_senders,
		COUNT(DISTINCT to_user) AS distinct_receivers
	FROM
		google_gmail_emails
	GROUP BY
		day
)
SELECT
	gge.id,
	gge.from_user,
	gge.to_user,
	gge.day
FROM
	google_gmail_emails AS gge
LEFT JOIN distinct_data AS dd
	ON gge.day = dd.day
WHERE
	dd.distinct_receivers > dd.distinct_senders;
```

### Expected output

16 email records from days where distinct receivers exceed distinct senders (days 1, 2, 6, 8 and 10 in the sample data), e.g.

| id | from_user | to_user | day |
|----|-----------|---------|-----|
| 4 | 6edf0be4b2267df1fa | 47be2887786891367e | 1 |
| 10 | 6edf0be4b2267df1fa | 5b8754928306a18b68 | 2 |
| 14 | 6edf0be4b2267df1fa | 157e3e9278e32aba3e | 2 |

---

## SQL Concepts Covered

| Concept | Where |
|---------|-------|
| Common Table Expressions (`WITH`) | Q1, Q2, Q3, Q4, Q7 |
| Window functions (`LAG`, `OVER`) | Q2, Q4 |
| Set operations (`UNION`) | Q1 |
| Aggregations (`COUNT`, `SUM`, `AVG`, `GROUP BY`) | Q1, Q2, Q4, Q5, Q6, Q7, Q8, Q9, Q11, Q13, Q14, Q15 |
| Date formatting and extraction (`DATE_FORMAT`, `EXTRACT`) | Q2, Q4, Q7 |
| NULL-safe conditional logic (`CASE`) | Q2 |
| Joins (`INNER JOIN`, `LEFT JOIN`, self-join) | Q3, Q5, Q6, Q9, Q11, Q12, Q15 |
| Scalar / correlated subqueries | Q1, Q3 |
| Numeric precision and rounding (`ROUND`, decimal division) | Q1, Q2, Q4, Q5, Q7 |
| Error metrics (`POWER`, `SQRT`) | Q4 |
| Conditional aggregation (`CASE` inside `SUM`/`MAX`) | Q8, Q12 |
| Window functions (`LEAD`, `ROW_NUMBER`) | Q10 |
| Distinct counts (`COUNT(DISTINCT ...)`) | Q15 |
| Filtering and sorting (`WHERE`, `ORDER BY ... DESC`) | Q4, Q5, Q6, Q7, Q8, Q11, Q13 |

---

## MySQL Gotchas in These Scripts

MySQL differs from most other engines in ways that affect the scripts in this repo.
The three issues below were present in the original solutions and have since been
fixed — they are kept here because they are easy to reintroduce and worth knowing:

1. **Integer division truncates percentages.** *(fixed in Q1 and Q2)*
   In MySQL, `200 / 13` evaluates to `15`, not `15.38`, because both operands are
   integers. The original Q1 (`follower_count * 100 / total_users`) and Q2
   (`(total - previous) / previous`) expressions were silently flattening the
   percentages to whole numbers. Fixed by promoting one operand to a decimal:
   `follower_count * 100.0 / total_users` and
   `((total - previous) * 100.0) / previous`.

2. **`%M` vs `%m` in `DATE_FORMAT`.** *(fixed in Q2)*
   `%M` expands to the full month name (`2019-January`); `%m` is the zero-padded
   month number (`2019-01`). The question asks for `YYYY-MM`, so the format string
   must be `'%Y-%m'`. Using `%M` also breaks the chronological `ORDER BY`, since
   `2019-February` sorts before `2019-January`.

3. **Double quotes are string literals in MySQL, but not by contract.** *(fixed in Q3)*
   `WHERE user_name = "karl"` happened to work because MySQL's default collation is
   case-insensitive and `ANSI_QUOTES` is off. Under `ANSI_QUOTES` the double quotes
   are parsed as an identifier and the query errors. Now uses single quotes with the
   exact casing (`'Karl'`).

---

## Adding a New Problem

1. Create the folder `qN/`.
2. Add `qN.sql` with the `CREATE TABLE` + `INSERT` seed data + the solution query,
   starting with `USE sql_de_practice;`.
3. Add `qN/readme.md` with the question and a step-by-step explanation.
4. Add a row to the [Problem Index](#problem-index) table above.
