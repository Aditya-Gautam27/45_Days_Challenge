```sql
/*
============================================================
Day 02 - SQL Solutions
45 Days Data Engineering Interview Challenge

Topics:
1. Human Traffic of Stadium (LeetCode 601)
2. LAG() & LEAD()
3. Consecutive Rows
4. ROW_NUMBER() Grouping Trick
============================================================
*/

------------------------------------------------------------
-- Problem 1: Human Traffic of Stadium
-- LeetCode 601
------------------------------------------------------------

/*
Question:
Return all rows that belong to one or more groups of
three or more consecutive ids where people >= 100.
*/

------------------------------------------------------------
-- Solution 1 : Using LAG() and LEAD()
------------------------------------------------------------

WITH cte AS
(
    SELECT
        id,
        visit_date,
        people,

        LAG(id,1) OVER(ORDER BY id) AS prev1,
        LAG(id,2) OVER(ORDER BY id) AS prev2,

        LEAD(id,1) OVER(ORDER BY id) AS next1,
        LEAD(id,2) OVER(ORDER BY id) AS next2

    FROM Stadium
    WHERE people >= 100
)

SELECT
    id,
    visit_date,
    people
FROM cte
WHERE

    -- Current row is the first row
    (next1 = id + 1
     AND next2 = id + 2)

OR

    -- Current row is the middle row
    (prev1 = id - 1
     AND next1 = id + 1)

OR

    -- Current row is the last row
    (prev2 = id - 2
     AND prev1 = id - 1)

ORDER BY visit_date;

------------------------------------------------------------
-- Solution 2 : ROW_NUMBER() Grouping Trick (Recommended)
------------------------------------------------------------

WITH grouped_rows AS
(
    SELECT
        *,
        id - ROW_NUMBER() OVER(ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
)

SELECT
    id,
    visit_date,
    people
FROM grouped_rows
WHERE grp IN
(
    SELECT grp
    FROM grouped_rows
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
ORDER BY visit_date;

------------------------------------------------------------
-- Understanding the ROW_NUMBER() Trick
------------------------------------------------------------

/*
Example

id     ROW_NUMBER      grp
----------------------------
2          1            1
3          2            1
4          3            1
6          4            2
7          5            2

Consecutive IDs produce the same value for:

id - ROW_NUMBER()

That value becomes the group identifier.

Any group having COUNT(*) >= 3
contains at least three consecutive rows.
*/

------------------------------------------------------------
-- LAG() Example
------------------------------------------------------------

SELECT
    id,
    people,
    LAG(people) OVER(ORDER BY id) AS previous_people
FROM Stadium;

------------------------------------------------------------
-- LEAD() Example
------------------------------------------------------------

SELECT
    id,
    people,
    LEAD(people) OVER(ORDER BY id) AS next_people
FROM Stadium;

------------------------------------------------------------
-- Consecutive Rows Pattern
------------------------------------------------------------

/*
Typical interview questions:

1. Three consecutive login days
2. Consecutive orders
3. Consecutive transactions
4. Consecutive attendance
5. Consecutive events

Useful window functions:

ROW_NUMBER()
LAG()
LEAD()
RANK()
DENSE_RANK()
*/

------------------------------------------------------------
-- Interview Notes
------------------------------------------------------------

/*
When should you use LAG()?

- Compare with previous row
- Detect trends
- Find previous values

When should you use LEAD()?

- Compare with next row
- Detect future events
- Find next values

When should you use ROW_NUMBER() grouping?

- Consecutive IDs
- Consecutive dates
- Consecutive transactions
- Islands and Gaps problems

This is one of the most frequently asked SQL interview patterns.
*/

------------------------------------------------------------
-- Complexity
------------------------------------------------------------

/*
Time Complexity:
O(n log n)
(Window functions require sorting.)

Space Complexity:
O(n)
*/
```
