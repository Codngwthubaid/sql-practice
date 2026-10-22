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
└── q3/
    ├── q3.sql         <- mutual friends between two users
    └── readme.md      <- question + explanation
```

---

## Problem Index

| # | Problem | Key SQL concepts | Solution |
|---|---------|------------------|----------|
| [Q1](#q1--famous-percentage-per-user) | Famous percentage of each user in a social graph | CTE, `UNION`, `GROUP BY`, scalar subquery, `ROUND` | [q1/q1.sql](q1/q1.sql) |
| [Q2](#q2--month-over-month-revenue-change) | Month-over-month % change in revenue | CTE, `LAG()` window function, `DATE_FORMAT`, `CASE` for NULLs | [q2/q2.sql](q2/q2.sql) |
| [Q3](#q3--mutual-friends-between-two-users) | Mutual friends of Karl and Hans | CTE, correlated scalar subquery, self-join, `INNER JOIN` | [q3/q3.sql](q3/q3.sql) |

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

## SQL Concepts Covered

| Concept | Where |
|---------|-------|
| Common Table Expressions (`WITH`) | Q1, Q2, Q3 |
| Window functions (`LAG`, `OVER`) | Q2 |
| Set operations (`UNION`) | Q1 |
| Aggregations (`COUNT`, `SUM`, `GROUP BY`) | Q1, Q2 |
| Date formatting (`DATE_FORMAT`) | Q2 |
| NULL-safe conditional logic (`CASE`) | Q2 |
| Joins (`INNER JOIN`, self-join) | Q3 |
| Scalar / correlated subqueries | Q1, Q3 |
| Numeric precision (`ROUND`, decimal division) | Q1, Q2 |

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
