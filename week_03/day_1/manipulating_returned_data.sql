--/*
-- * Manipulating Returned Data
-- * 
-- * specifying column aliases using AS
-- * use the DISTINCT() functions
-- * use some aggregate functions
-- * sort records
-- * limit the number of records returned
-- */



-- we can manipulate the data that is returned by a query by altering the select STATEMENT 


SELECT 
	id,
	first_name,
	last_name 
FROM employees 
WHERE department = 'Accounting';

-- Column aliases

-- can we get a list of all employees with their first name and last name combined into one field (columns)
-- called 'full_name'

SELECT
	first_name,
	last_name,
	concat(first_name, ' ',last_name) AS full_name
FROM employees;

--Add a WHERE clause to the query above to filter out any rows that don’t have both a first and second name.

SELECT
	first_name,
	last_name,
	concat(first_name, ' ',last_name) AS full_name
FROM employees
WHERE first_name IS NOT NULL AND last_name IS NOT NULL;

-- aliases are good because they're more informative than the default

/*
 * Distinct()
 */

-- The company's problem

-- Our database might be out of date! There's been restructuring, we should now have six departments in
-- the corp. how many departments do employees belong to at present in the database?

SELECT DISTINCT(department )
FROM employees;

-- all the different values within the department column (field)

/*
 * Aggregate functions
 */

-- How many employees started work for omni corp in 2001?

SELECT
	count(*) AS started_in_2001
FROM employees 
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';

/*
 * Other aggregates:
 * 
 * Count() -- count items in a column
 * SUM() ---- sum of a column
 * AVG() ---- mean of a columns
 * MIN() ---- min value of a column
 * MAX() ---- max value of a column
 * 
 */

/*
 * 
 */

-- What are the maximum and minimum salaries of all employees?
SELECT 
	min(salary) AS min_salary,
	max(salary) AS max_salary
FROM employees;

-- What is the average salary of employees in the Human Resources department?
SELECT 
	avg(salary) AS avg_salary
FROM employees
WHERE department = 'Human Resources';

-- How much does the corporation spend on the salaries of employees hired in 2018?
SELECT 
	sum(salary) AS total_salary_2018
FROM employees
WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';

/*
 * Sorting the results
 */

-- ORDER BY

-- sorts the return of a query - DESC, or ASC
-- thing to note ORDER BY comes after WHERE

-- Get me a table of all the employee's details for the employee who earns the minimum salary across
-- Omni Copr.

SELECT *
FROM employees 
WHERE salary IS NOT NULL
ORDER BY salary ASC
LIMIT 1;

-- LIMIT the query result with LIMIT

-- if we want to put NULLS at the end of the sorted list
-- use NULLS LAST

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 1;

/*
 * We can perform multi-level sorts (sorts on multiple columns)
 */

-- Get me a table with employee details, ordered by full time equivalent hours (highest first) and THEN
-- alphabetically by last name.

SELECT *
FROM employees 
ORDER BY
	fte_hours DESC NULLS LAST,
	last_name ASC NULLS LAST;


/*
 * Write queries to answer the following questions using the operators introduced in this section.
 * 1. “Get the details of the longest-serving employee of the corporation.”
 * 2. “Get the details of the highest paid employee of the corporation in Libya.”
 */

SELECT *
FROM employees 
ORDER BY start_date ASC 
LIMIT 1;

SELECT *
FROM employees 
WHERE country = 'Libya'
ORDER BY salary DESC 
LIMIT 1;

-- A note on TIES 

-- ties can happen when ordering (e.g. two employees started on the same date)
-- LIMIT 1 (would just return 1 row)

-- write a first query to find the max value in a COLUMN 
-- use this result in the where clause of a second query to find all rows with that VALUES 

-- Get me a table of all employees who work in the alphabetically first country

SELECT
	country
FROM employees 
ORDER BY country
LIMIT 1;

SELECT *
FROM employees 
WHERE country = 'Afghanistan';

-- #The SQL gotcha
-- Order of definition != order of execution (SELECT happens later than it looks like)

SELECT
	id,
	first_name,
	last_name,
	concat(first_name, ' ', last_name) AS full_name 
FROM employees 
WHERE concat(first_name, ' ', last_name) LIKE 'A%';

 -- Scratchpad

SELECT (EXTRACT(YEAR FROM Now()))







