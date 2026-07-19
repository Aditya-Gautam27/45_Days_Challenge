/*
==========================================================
Day 01 - SQL Window Functions
45 Days Data Engineering & Python Interview Challenge

Topics Covered:
1. ROW_NUMBER()
2. RANK()
3. DENSE_RANK()
4. CTE
5. Latest Record Per Entity

Author: Aditya Gautam
==========================================================
*/


/*=========================================================
1. Nth Highest Salary (LeetCode 177)
=========================================================*/

CREATE FUNCTION getNthHighestSalary(@N INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT Salary
        FROM (
            SELECT Salary,
                   DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
            FROM Employee
        ) AS RankedSalaries
        WHERE SalaryRank = @N
    );
END;
GO


/*=========================================================
2. Rank Scores (LeetCode 178)
=========================================================*/

SELECT
    Score,
    DENSE_RANK() OVER (ORDER BY Score DESC) AS Rank
FROM Scores
ORDER BY Score DESC;


/*=========================================================
3. ROW_NUMBER() Example
Find the highest-paid employee from each department
=========================================================*/

SELECT *
FROM (
    SELECT
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS RowNum
    FROM Employees
) AS RankedEmployees
WHERE RowNum = 1;


/*=========================================================
4. RANK() Example
=========================================================*/

SELECT
    Name,
    Department,
    Salary,
    RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;


/*=========================================================
5. DENSE_RANK() Example
=========================================================*/

SELECT
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;


/*=========================================================
6. Latest Record Per Customer
=========================================================*/

WITH LatestOrders AS
(
    SELECT
        CustomerID,
        OrderID,
        OrderDate,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate DESC
        ) AS rn
    FROM Orders
)

SELECT
    CustomerID,
    OrderID,
    OrderDate
FROM LatestOrders
WHERE rn = 1;


/*=========================================================
7. Top 3 Salaries Per Department
=========================================================*/

WITH SalaryRanks AS
(
    SELECT
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees
)

SELECT *
FROM SalaryRanks
WHERE SalaryRank <= 3;


/*=========================================================
8. Remove Duplicate Records
Keep only the latest record
=========================================================*/

WITH DuplicateRows AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY UpdatedAt DESC
        ) AS rn
    FROM Customers
)

SELECT *
FROM DuplicateRows
WHERE rn = 1;


/*=========================================================
9. Difference Between Ranking Functions
=========================================================*/

SELECT
    Name,
    Salary,

    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,

    RANK() OVER (ORDER BY Salary DESC) AS RankNumber,

    DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRankNumber

FROM Employees;


/*=========================================================
10. Window Function in WHERE Clause
(Incorrect Example)
=========================================================*/

-- This query will FAIL because window functions
-- cannot be used directly in the WHERE clause.

-- SELECT *,
--        ROW_NUMBER() OVER (
--            PARTITION BY CustomerID
--            ORDER BY OrderDate DESC
--        ) AS rn
-- FROM Orders
-- WHERE rn = 1;


/*=========================================================
Correct Solution Using CTE
=========================================================*/

WITH RankedOrders AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID
               ORDER BY OrderDate DESC
           ) AS rn
    FROM Orders
)

SELECT *
FROM RankedOrders
WHERE rn = 1;


/*
==========================================================
Key Learnings

✔ ROW_NUMBER() gives unique sequential numbers.

✔ RANK() skips rank numbers after ties.

✔ DENSE_RANK() does not skip rank numbers.

✔ Window functions execute after the WHERE clause.

✔ Use a CTE or subquery to filter window function results.

✔ ROW_NUMBER() is widely used for:
    - Deduplication
    - Latest record selection
    - Incremental ETL
    - SCD Type 1 processing

==========================================================
*/
