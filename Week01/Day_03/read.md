# Day 03 – Notes
## Topic: Context Managers (Python) & SQL Subqueries

---

# 📌 Python

## Context Managers

A **Context Manager** is an object that automatically manages resources by performing setup before use and cleanup afterward.

It guarantees that resources are released even if an exception occurs.

---

## Why Use Context Managers?

Without a context manager:

```python
file = open("data.txt")

try:
    data = file.read()
finally:
    file.close()
```

With a context manager:

```python
with open("data.txt") as file:
    data = file.read()
```

Advantages:

- Cleaner code
- Automatic cleanup
- Prevents resource leaks
- Exception-safe
- Reusable

---

## The `with` Statement

General syntax:

```python
with resource as variable:
    # work with resource
```

Example:

```python
with open("notes.txt") as file:
    print(file.read())
```

Python automatically closes the file after leaving the block.

---

## How `with` Works Internally

```python
with BrowserSession() as browser:
    browser.goto(url)
```

is approximately equivalent to:

```python
session = BrowserSession()

browser = session.__enter__()

try:
    browser.goto(url)
finally:
    session.__exit__()
```

---

## `__enter__()`

Called when entering the `with` block.

Responsibilities:

- Acquire the resource
- Initialize objects
- Return the object after `as`

Example:

```python
def __enter__(self):
    self.browser = Browser()
    return self.browser
```

---

## `__exit__()`

Called when leaving the `with` block.

Responsibilities:

- Cleanup resources
- Close files
- Close database connections
- Quit browser
- Handle exceptions (optional)

Example:

```python
def __exit__(self, exc_type, exc_val, exc_tb):
    self.browser.close()
```

---

## Execution Flow

```
Create Context Manager
        ↓
__enter__()
        ↓
Execute with block
        ↓
__exit__()
```

---

## `contextlib.contextmanager`

Python provides a simpler way to create context managers.

```python
from contextlib import contextmanager

@contextmanager
def browser():
    print("Opening Browser")

    yield "Browser"

    print("Closing Browser")
```

Usage:

```python
with browser() as b:
    print(b)
```

Everything before `yield` behaves like `__enter__()`.

Everything after `yield` behaves like `__exit__()`.

---

## Exception Handling

Even if an exception occurs:

```python
with BrowserSession() as browser:
    browser.goto(url)
    raise Exception("Scraping Failed")
```

Python still executes

```python
__exit__()
```

before propagating the exception.

---

## Suppressing Exceptions

Returning `True` from `__exit__()` suppresses the exception.

```python
def __exit__(self, exc_type, exc_val, exc_tb):
    return True
```

Returning `False` (or `None`) allows the exception to propagate.

---

## Real-World Use Cases

- File handling
- Database connections
- Network sockets
- Thread locks
- Temporary files
- Selenium sessions
- Playwright browser sessions
- API sessions

---

## Playwright Example

```python
with BrowserSession() as page:
    page.goto(url)
    scrape(page)
```

Even if scraping fails, the browser is always closed.

---

## Key Takeaways

- `with` automatically manages resources.
- `__enter__()` initializes and returns the resource.
- `__exit__()` always performs cleanup.
- `@contextmanager` provides a concise alternative using `yield`.
- Context managers make code cleaner, reusable, and exception-safe.

---

# 📌 SQL

## Subqueries

A **subquery** is a query nested inside another SQL query.

Example:

```sql
SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
);
```

---

## Types of Subqueries

### 1. Single-row Subquery

Returns one value.

Example:

```sql
SELECT *
FROM Employee
WHERE salary >
(
    SELECT AVG(salary)
    FROM Employee
);
```

---

### 2. Multi-row Subquery

Returns multiple values.

Example:

```sql
SELECT *
FROM Customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM Orders
);
```

---

### 3. Correlated Subquery

Depends on the outer query.

Example:

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

Runs once for every row of the outer query.

---

## JOIN vs Subquery

Subquery:

```sql
SELECT *
FROM Customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM Orders
);
```

JOIN:

```sql
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id;
```

JOINs are generally easier to read and often more efficient.

---

## EXISTS

Checks whether at least one matching row exists.

```sql
SELECT *
FROM Customers c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

Stops searching after the first match.

---

## NOT EXISTS

Returns rows with no matching records.

```sql
SELECT *
FROM Customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

Commonly used for **anti-joins**.

---

## NOT IN vs NOT EXISTS

### NOT IN

```sql
WHERE customer_id NOT IN (...)
```

Fails if the subquery contains `NULL`.

---

### NOT EXISTS

```sql
WHERE NOT EXISTS (...)
```

Safely handles `NULL` values.

Preferred in interviews.

---

## Correlated Subquery

Example:

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

The inner query references the outer query.

---

## Aggregate Subquery

Uses aggregate functions like:

- AVG()
- SUM()
- MAX()
- MIN()

inside subqueries.

Example:

```sql
SELECT *
FROM Sales
WHERE amount =
(
    SELECT MAX(amount)
    FROM Sales
);
```

---

## Performance Tips

- Prefer JOIN over unnecessary subqueries.
- Use EXISTS for existence checks.
- Prefer NOT EXISTS over NOT IN.
- Correlated subqueries can be slower on large datasets.
- Proper indexing significantly improves performance.

---

# Interview Questions Practiced

## Python

- What problem do context managers solve?
- Difference between try/finally and context managers.
- Explain `__enter__()` and `__exit__()`.
- How does `@contextmanager` work?
- What does `yield` do?
- Can a context manager suppress exceptions?
- How would you manage a Playwright browser session?

---

## SQL

- Difference between JOIN and subquery.
- EXISTS vs IN.
- NOT EXISTS vs NOT IN.
- Explain the NULL trap.
- What is a correlated subquery?
- How do aggregate subqueries work?
- When would you prefer JOIN over a subquery?

---

# Problems Solved

## SQL

- Combine Two Tables
- Customers Who Never Order
- Department Highest Salary
- Department Top Three Salaries
- Highest Grossing Items (Top Spender per Category)

---

# Resources

## Python

- Corey Schafer – Context Managers
- Python `contextlib` Documentation

## SQL

- LeetCode SQL 50
- DataLemur SQL
- PostgreSQL Documentation

---

# Day 03 Summary

### Python
- ✅ Context Managers
- ✅ `with` Statement
- ✅ `__enter__()` & `__exit__()`
- ✅ `@contextmanager`
- ✅ `yield`
- ✅ Exception Handling
- ✅ Browser Session Management

### SQL
- ✅ Subqueries
- ✅ JOIN vs Subquery
- ✅ EXISTS
- ✅ NOT EXISTS
- ✅ NOT IN NULL Trap
- ✅ Correlated Subqueries
- ✅ Aggregate Subqueries

---

## Progress

**Python Topics Covered:** 6

**SQL Topics Covered:** 12

**LeetCode/DataLemur Problems:** 5

**Interview Questions Practiced:** 14
