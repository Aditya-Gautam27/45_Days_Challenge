# Day 03 – SQL Solutions
## Topic: Subqueries, EXISTS, NOT EXISTS & Correlated Subqueries

---

# 1. Rewrite a Subquery as a JOIN

## Problem

Retrieve all customers who have placed at least one order.

### Tables

**Customers**

| customer_id | name |
|------------|------|
|1|Alice|
|2|Bob|
|3|Charlie|

**Orders**

| order_id | customer_id |
|----------|-------------|
|101|1|
|102|1|
|103|3|

---

## Solution 1 – Using Subquery

```sql
SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
);
```

### How it works

1. Inner query returns all customer_ids from Orders.
2. Outer query checks if each customer exists in that list.

---

## Solution 2 – Using JOIN

```sql
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id;
```

### Why JOIN?

- Usually easier to read
- Often performs better
- Preferred in interviews unless a subquery is specifically required

---

# 2. EXISTS (Anti Join)

## Problem

Find customers who never placed an order.

---

## Solution

```sql
SELECT *
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

---

### How EXISTS Works

For every customer:

```
Customer 1
    ↓
Does an order exist?
    ↓
Yes
    ↓
NOT EXISTS = False
```

```
Customer 2
    ↓
Does an order exist?
    ↓
No
    ↓
NOT EXISTS = True
```

Customer 2 is returned.

---

### Why SELECT 1?

EXISTS ignores the selected columns.

These are identical:

```sql
SELECT *
```

```sql
SELECT 1
```

```sql
SELECT NULL
```

The database only checks whether at least one row exists.

Using `SELECT 1` is the standard convention.

---

# 3. NOT IN vs NOT EXISTS (NULL Trap)

Suppose Orders contains

| customer_id |
|-------------|
|1|
|NULL|
|3|

Now write

```sql
SELECT *
FROM Customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM Orders
);
```

Result

❌ Returns **no rows**.

Why?

Because SQL compares

```
2 NOT IN (1,NULL,3)
```

Which becomes

```
2 <> 1
AND
2 <> NULL
AND
2 <> 3
```

Anything compared with NULL becomes

```
UNKNOWN
```

So SQL cannot determine whether the condition is TRUE.

---

## Correct Solution

```sql
SELECT *
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

### Interview Rule

✅ Prefer

```
NOT EXISTS
```

over

```
NOT IN
```

when NULL values may exist.

---

# 4. Correlated Subquery

## Problem

Find employees earning more than the average salary of their own department.

### Employee

| id | department | salary |
|----|------------|--------|
|1|HR|5000|
|2|HR|7000|
|3|IT|9000|
|4|IT|11000|

---

## Solution

```sql
SELECT *
FROM Employee e
WHERE salary >
(
    SELECT AVG(salary)
    FROM Employee
    WHERE department = e.department
);
```

---

### Why is it called a Correlated Subquery?

Notice

```sql
e.department
```

belongs to the outer query.

The inner query depends on the current row of the outer query.

So SQL executes it for every employee.

Example

Employee

```
HR
```

↓

Average HR salary

↓

Compare

↓

Next employee

↓

Average IT salary

↓

Compare

---

# 5. Top Spender Per Category

### Sales

| customer | category | amount |
|-----------|----------|--------|
|Alice|Books|200|
|Bob|Books|500|
|John|Electronics|900|
|Mike|Electronics|700|

---

## Step 1

Find total spent by every customer.

```sql
SELECT
customer,
category,
SUM(amount) AS total
FROM Sales
GROUP BY customer, category;
```

---

## Step 2

Use that as a subquery.

```sql
SELECT *
FROM
(
    SELECT
        customer,
        category,
        SUM(amount) total
    FROM Sales
    GROUP BY customer, category
) s
WHERE total =
(
    SELECT MAX(total)
    FROM
    (
        SELECT
            customer,
            category,
            SUM(amount) total
        FROM Sales
        GROUP BY customer, category
    ) t
    WHERE t.category = s.category
);
```

---

### Logic

```
Books
    ↓

Alice -> 200

Bob -> 500

MAX = 500

Return Bob
```

```
Electronics

John -> 900

Mike ->700

MAX =900

Return John
```

---

# Key Concepts Learned Today

## IN

Checks whether a value exists in a list.

---

## EXISTS

Checks whether at least one matching row exists.

Stops searching after the first match.

---

## NOT EXISTS

Best way to perform an Anti Join.

Safely handles NULL values.

---

## Correlated Subquery

Inner query depends on values from the outer query.

Runs once for every outer row.

---

## Aggregate Subquery

Use aggregate functions like

- AVG()
- MAX()
- MIN()
- SUM()

inside subqueries to compare rows against grouped results.

---

# Interview Tips

### Prefer JOIN over IN

Unless a subquery makes the query clearer.

---

### Prefer NOT EXISTS over NOT IN

Avoid NULL-related bugs.

---

### EXISTS vs IN

| EXISTS | IN |
|---------|----|
|Checks row existence|Checks value membership|
|Stops at first match|May scan entire result|
|Better for correlated queries|Good for small lookup lists|

---

### Correlated Subqueries

Recognize them by references to the outer query.

Example

```sql
WHERE department = e.department
```

---

# LeetCode Practice

✅ Combine Two Tables

https://leetcode.com/problems/combine-two-tables/

---

✅ Customers Who Never Order

https://leetcode.com/problems/customers-who-never-order/

---

✅ Department Highest Salary

https://leetcode.com/problems/department-highest-salary/

---

✅ Department Top Three Salaries

https://leetcode.com/problems/department-top-three-salaries/

---

✅ Highest Grossing Items

https://datalemur.com/questions/sql-highest-grossing

---

# Complexity Notes

| Technique | Complexity |
|-----------|------------|
|JOIN|Usually O(n log n) depending on indexes|
|EXISTS|Stops at first match|
|NOT EXISTS|Efficient with indexes|
|Correlated Subquery|Can be expensive if executed for every row|
|Aggregate Subquery|Depends on GROUP BY size|

---

## Today's Interview Takeaways

- Understand when to use **JOIN** instead of a subquery.
- Know why **NOT EXISTS** is safer than **NOT IN**.
- Be comfortable writing **correlated subqueries**.
- Use **aggregate functions inside subqueries** for ranking and comparison problems.
- Always consider readability and performance when choosing between JOINs and subqueries.
