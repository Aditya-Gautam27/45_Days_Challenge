# 📅 Day 01 – Python Decorators & SQL Window Functions

## 🎯 Goal

Build a strong understanding of Python decorators and SQL window functions, two concepts that are commonly asked in Python, ETL, and Data Engineering interviews.

---

# 📚 Topics Covered

## 🐍 Python

### Decorators

- What is a decorator?
- Higher-order functions
- Function wrappers
- `*args` and `**kwargs`
- `functools.wraps`
- Parameterized decorators
- Stacking decorators
- Retry decorators
- Timing decorators

### Logging

- `logging.getLogger(__name__)`
- Why logging is preferred over `print()`

---

## 🗄️ SQL

### Window Functions

- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `PARTITION BY`
- `ORDER BY`
- CTEs
- Latest record per entity
- Top N records
- Duplicate removal using `ROW_NUMBER()`

---

# 💻 Coding Exercises

## Python

- ✅ Built a `timeit` decorator
- ✅ Understood execution flow of decorators
- ✅ Learned why `return wrapper` is required
- ✅ Learned why `@wraps` is important
- ✅ Understood decorators with arguments
- ✅ Learned how multiple decorators execute

---

## SQL

Solved and practiced:

- Nth Highest Salary
- Rank Scores
- Department Top Three Salaries
- Latest Record Per Entity
- Difference between `RANK()` and `DENSE_RANK()`

---

# 🧠 Key Learnings

## Decorator vs Higher-Order Function

- Every decorator is a higher-order function.
- Not every higher-order function is a decorator.

---

## Why use `@wraps`

Without `@wraps`

- Function name becomes `wrapper`
- Docstring is lost
- Debugging becomes harder

With `@wraps`

- Preserves function metadata
- Improves debugging
- Compatible with frameworks like Flask and FastAPI

---

## Decorator Execution

```python
@decorator1
@decorator2
def hello():
    pass
```

Python interprets it as:

```python
hello = decorator1(decorator2(hello))
```

Execution order:

1. decorator1
2. decorator2
3. Original function

---

## SQL Ranking Functions

### ROW_NUMBER()

- Always generates unique numbers.

Example

```
100 → 1
90  → 2
90  → 3
80  → 4
```

---

### RANK()

Duplicate values share the same rank.

```
100 → 1
90  → 2
90  → 2
80  → 4
```

Notice the skipped rank.

---

### DENSE_RANK()

Duplicate values share the same rank without gaps.

```
100 → 1
90  → 2
90  → 2
80  → 3
```

---

# ⭐ Interview Questions Practiced

### Python

- What is a decorator?
- Difference between a decorator and a higher-order function?
- Why use `functools.wraps`?
- Can decorators accept arguments?
- What happens when multiple decorators are stacked?
- Explain a retry decorator.

### SQL

- Difference between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.
- How do you find the latest record for each customer?
- Why can't window functions be used in a `WHERE` clause?
- Why use `ROW_NUMBER()` instead of `GROUP BY`?
- Window functions vs correlated subqueries.

---

# 📝 LeetCode Problems

- ✅ 177. Nth Highest Salary
- ✅ 178. Rank Scores
- ⏳ 185. Department Top Three Salaries
- ⏳ 1890. Latest Login in 2020

---

# 💡 Key Takeaways

- Decorators help write reusable and clean code.
- `@wraps` should always be used inside decorators.
- Window functions are essential for ranking, deduplication, and ETL workflows.
- `ROW_NUMBER()` is commonly used for removing duplicates and selecting the latest records.
- Choosing between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` depends on the business requirement.

---

# 🚀 Resources

## Python

- Python Decorators Documentation
- functools Documentation
- Real Python – Decorators

## SQL

- LeetCode SQL 50
- DataLemur SQL
- StrataScratch SQL
- SQLBolt

---

# 📌 Progress

- [x] Studied Python Decorators
- [x] Learned `functools.wraps`
- [x] Built a Timing Decorator
- [x] Practiced SQL Window Functions
- [x] Solved LeetCode SQL Problems
- [x] Reviewed Interview Questions

---

## 🎯 Tomorrow's Goal (Day 02)

- Python Generators
- Iterators
- Context Managers
- Advanced SQL Joins
- CTE Practice
- Mini ETL Project
