
/* 
 * Advanced SQL topics
 */

/* 
 * Create your own function
 * can help when performing the same / similar tasks often. (An answer to tediousness)
 *
 * you may not be allowed to create funcitons (depends on your DB permissions)
 *
 * omni user cannot create functions
 * 
 * functions are attached to databases
 *
 */

-- 1. use the keyword CREATE (OR REPLACE) to start defining your FUNCTION
-- 2. give your function a name = percent_change
-- 3. specify the arguments of your functions and their datatypes
-- 4. specify the data type of the RESULT
-- 5. write the code for the FUNCTION
-- 6. additional things - specify the language (SQL) PLSQL
-- 7. immutable means cannot be changed

CREATE OR REPLACE FUNCTION 
percent_change(new_value NUMERIC, old_value NUMERIC, decimals INT DEFAULT 2)
RETURNS NUMERIC AS 
    'SELECT ROUND(100 * (new_value - old_value) / old_value, decimals);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- 8. call your function, just as you would any other built in function
SELECT
	percent_change(50, 40),
	percent_change(100,99, 4);

/*
 * Legal salaries are increasing by $1000 next year
 * Show the percent change for each employee's salary in legal
 */
	
SELECT
	id,
	first_name,
	last_name,
	salary,
	salary + 1000 AS new_salary,
	percent_change(salary + 1000, salary, 2)
FROM employees 
WHERE department = 'Legal'
ORDER BY percent_change DESC NULLS last;

SELECT
	make_badge(first_name, last_name, department)
FROM employees;

-- kind of need to know how the functions work ahead of time
 

 /*
  * Investigating Query Performance
  * 
  * maybe a query is taking a surprisingly long amount of time to run
  * 
  * Interview questions (How would I speed up a slow running query?)
  */

-- Get me a table of department average salaries for employees working in
-- Germany, France, Italy or Spain

EXPLAIN ANALYZE 
SELECT department, avg(salary)
FROM employees 
WHERE country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY department
ORDER BY avg(salary);

-- How could we speed up this query?

-- index column(s)!

-- What index column(s) do is behind-the-scenes they provide a quick (lookup-y) way of
-- finding rows using the index column

-- Searching a phone book for "David Currie"

-- 1. start at the start and go through each page until we find "David Currie"
-- look at all the A's , all the B's, and a good chunk of the C's until we found David C
-- (sequential scan)
-- default behaviour

-- 2. use an index. notice that the surname starts with a C
-- go directly to C and look there
-- (index scan)

-- let's use employees indexed

-- this was created with employees and indexes by country (again, you need the 
-- appropriate db permissions to create indexes and cannot create indexes with the same
-- name)

CREATE INDEX employees_indexed_country ON employees_indexed(country ASC NULLS LAST);

EXPLAIN ANALYZE
SELECT department, avg(salary)
FROM employees_indexed
WHERE country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY department
ORDER BY avg(salary); 

-- drawbacks
-- storage (less of an issue these days)
-- slows down other CRUD operations (insert, update, delete) since indexes need to be
-- updated

/*
 * Common Table Expressions
 * 
 * We can create temporary tables before the start of our query
 * and access them like tables in the database
 * 
 */

/*
 * Find all the employees in the legal department
 * who earn less than the mean salary of people in that same department
 */

SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
	SELECT avg(salary)
	FROM employees
	WHERE department = 'Legal');

/*
 * Common tables allow you to specify this temporary table
 * created in our subquery as table in the database
 */

WITH dep_average AS (
	SELECT avg(salary) AS avg_salary
	FROM employees
	WHERE department = 'Legal'
	)
SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
SELECT avg_salary
FROM dep_average);

/*
 * Find all employees in Legal who earn less than the mean salary and work fewer than the
 * mean fTE hours 
 */

-- subquery solution

SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
	SELECT avg(salary)
	FROM employees
	WHERE department = 'Legal'
	)
AND fte_hours < (
	SELECT avg(fte_hours)
	FROM employees 
	WHERE department = 'Legal'
	);

-- using common tables instead

WITH dep_averages AS (
	SELECT avg(salary) AS avg_salary,
	avg(fte_hours) AS avg_fte
	FROM employees
	WHERE department = 'Legal'
	)
	SELECT *
	FROM employees 
	WHERE department = 'Legal' AND salary < (
		SELECT avg_salary
		FROM dep_averages)
	AND fte_hours < (
		SELECT avg_fte
		FROM dep_averages
	);

/*
 * get a table with each employee's
 * - first name
 * - last name
 * - department
 * - country
 * - salary
 * - and a comparison of their salary vs that of the country they work in and the 
 * department they work in
 */

-- 1. get the average salary for each department
-- 2. get the average salary for each country
-- 3. 2 joining operation
-- 4. using these average values calculate each employees ratio (SELECT)

WITH dep_avgs AS(
	SELECT
		department,
		avg(salary) AS avg_salary_dept
	FROM employees 
	GROUP BY department
	),
	country_avgs AS (
	SELECT
		country,
		avg(salary) AS avg_salary_country
	FROM employees 
	GROUP BY country
	)
SELECT 
	e.first_name,
	e.last_name,
	e.department,
	e.country,
	e.salary,
	ROUND(e.salary / dep_a.avg_salary_dept, 2) AS dep_ratio,
	ROUND(e.salary / c_a.avg_salary_country, 2) AS country_ratio
FROM employees AS e 
INNER JOIN dep_avgs AS dep_a ON e.department = dep_a.department
INNER JOIN country_avgs AS c_a ON e.country = c_a.country; 

/*
 * Window Functions
 * 
 */

/*
 * Show for each employee their salary together with the minimum and maximum salaries in
 * their department.
 */

-- Window functions: OVER

SELECT
	first_name,
	last_name,
	salary,
	department,
	min(salary) OVER (PARTITION by department), -- leaving OVER () blank THEN SHOW RESULT FOR whole table
	max(salary) OVER (PARTITION BY department)
FROM employees;

-- Common Tables

WITH dep_avgs AS (
	SELECT
		department,
		min(salary) AS min_salary,
		max(salary) AS max_salary
	FROM employees 
	GROUP BY department
	)
SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	e.department,
	d_a.min_salary,
	d_a.max_salary
FROM employees AS e
INNER JOIN dep_avgs AS d_a ON e.department = d_a.department;











