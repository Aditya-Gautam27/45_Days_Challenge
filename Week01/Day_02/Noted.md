# Day 02: Generators & Consecutive Rows in SQL

## 📅 Date

Day 02 of the 45 Days Data Engineering Interview Challenge

---

# 📚 Topics Covered

## Python

### 1. Generators

A generator is a special type of function that produces values one at a time using the `yield` keyword instead of returning all values at once.

### Why use Generators?

* Memory efficient
* Lazy evaluation
* Suitable for large datasets
* Ideal for ETL pipelines and data streaming
* Can generate infinite sequences

---

### `yield` vs `return`

| return                                      | yield                              |
| ------------------------------------------- | ---------------------------------- |
| Ends the function                           | Pauses the function                |
| Returns one value                           | Produces multiple values over time |
| Doesn't remember state                      | Preserves execution state          |
| Stores complete result (if building a list) | Generates values on demand         |

---

### Generator Example

```python
def fibonacci():
    a, b = 0, 1

    while True:
        yield a
        a, b = b, a + b
```

Usage:

```python
fib = fibonacci()

for _ in range(10):
    print(next(fib))
```

Output:

```
0
1
1
2
3
5
8
13
21
34
```

---

### How `yield` Works

When execution reaches a `yield` statement:

* The function pauses.
* Local variables are preserved.
* Execution resumes from the next line when `next()` is called again.

---

### Generator Expressions

List Comprehension

```python
squares = [x*x for x in range(10)]
```

Generator Expression

```python
squares = (x*x for x in range(10))
```

To print the values:

```python
for num in squares:
    print(num)
```

or

```python
print(list(squares))
```

> **Note:** Once a generator is consumed, it cannot be reused.

Example:

```python
gen = (x*x for x in range(5))

print(list(gen))
print(list(gen))
```

Output

```
[0, 1, 4, 9, 16]
[]
```

---

### Memory Comparison

| List                                       | Generator                               |
| ------------------------------------------ | --------------------------------------- |
| O(n) Memory                                | O(1) Memory                             |
| Stores all elements                        | Produces one element at a time          |
| Faster if all values are needed repeatedly | Better for streaming and large datasets |

---

### Common Use Cases

* Reading large CSV files
* Processing log files
* Streaming API responses
* Web scraping
* ETL pipelines
* Infinite sequences

---

# SQL

## Human Traffic of Stadium (LeetCode 601)

### Problem

Find rows that belong to at least **three consecutive IDs** where:

```
people >= 100
```

---

### Approach 1 — LAG & LEAD

Steps:

1. Filter rows where `people >= 100`
2. Use `LAG()` and `LEAD()` to inspect neighboring IDs.
3. Check whether the current row is:

   * Start of a sequence
   * Middle of a sequence
   * End of a sequence

Useful window functions:

* `LAG()`
* `LEAD()`

---

### Approach 2 — ROW_NUMBER() Grouping Trick ⭐

A cleaner solution uses:

```sql
id - ROW_NUMBER() OVER (ORDER BY id)
```

Example

| id | ROW_NUMBER | Group |
| -- | ---------: | ----: |
| 2  |          1 |     1 |
| 3  |          2 |     1 |
| 4  |          3 |     1 |
| 6  |          4 |     2 |
| 7  |          5 |     2 |

Consecutive IDs share the same group value.

Then:

```sql
GROUP BY grp
HAVING COUNT(*) >= 3
```

This technique is commonly used to solve "consecutive rows" problems.

---

# Interview Questions

### Python

1. What is a generator?
2. Difference between `yield` and `return`?
3. How does `yield` preserve state?
4. Generator vs List?
5. Generator Expression vs List Comprehension?
6. Can a generator be iterated twice?
7. What happens after a generator is exhausted?
8. What exception is raised when a generator finishes?
9. Can a generator have multiple `yield` statements?
10. When would you use generators in ETL?

---

### SQL

1. Difference between `LAG()` and `LEAD()`?
2. How do you detect consecutive rows?
3. Why does `id - ROW_NUMBER()` work?
4. Explain the Human Traffic of Stadium solution.
5. How would you find sequences of five consecutive rows instead of three?

---

# LeetCode Progress

| Problem                  | Difficulty | Status   |
| ------------------------ | ---------- | -------- |
| Human Traffic of Stadium | Hard       | ✅ Solved |

---

# Key Takeaways

* Generators are lazy iterators that improve memory efficiency.
* `yield` pauses execution and preserves the function's state.
* Generator expressions are more memory-efficient than list comprehensions.
* Generators are consumed after iteration and cannot be reused.
* `LAG()` and `LEAD()` help compare neighboring rows in SQL.
* The `ROW_NUMBER()` grouping trick is a powerful technique for solving consecutive-row problems.

---

# Resources

## Python

* Python Generators Documentation
* Python `itertools` Module
* Real Python – Generators

## SQL

* LeetCode 601 – Human Traffic of Stadium
* Window Functions Documentation

---

# Progress Checklist

* ✅ Learned Generators
* ✅ Learned `yield`
* ✅ Practiced Generator Expressions
* ✅ Solved Infinite Fibonacci Generator
* ✅ Compared Generator vs List
* ✅ Solved Human Traffic of Stadium
* ✅ Learned `LAG()` and `LEAD()`
* ✅ Learned Consecutive Rows Pattern
* ✅ Learned `ROW_NUMBER()` Grouping Trick
