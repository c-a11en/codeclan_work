-- Find the number of employees within each department of the corporation

SELECT department, count(id) AS num_employees
FROM employees
GROUP BY department
ORDER BY count(*) DESC;

-- Anything IN the GROUP BY can be IN the select.

-- How many employees are in each country?

SELECT country , count(id) AS num_employees
FROM employees
GROUP BY country
ORDER BY count(*) DESC;

-- How many employees are in each country AND department?

SELECT country , department, count(id) AS num_employees
FROM employees
GROUP BY country, department
ORDER BY count(*) DESC;

-- How many employees in each department work either 0.25 or 0.5 FTE hours?

SELECT department, fte_hours, count(id)
FROM employees
--WHERE fte_hours BETWEEN 0.25 AND 0.5
WHERE fte_hours IN(0.25,0.5)
GROUP BY department, fte_hours;

-- See how NULL affects counts
-- Gotcha COUNTS can exist without a GROUP BY if no other column is present

SELECT count(id), --IF IN doubt, use PRIMARY key
count(first_name), -- COUNT does NOT INCLUDE NULLS
count(*) -- BIG gotcha
FROM employees; 

-- Find the longest serving employee in each department
-- NOW() gives todays date and time (for the server)

SELECT
	department,
	first_name,
	last_name,
	round(extract(DAY FROM NOW() - MIN(start_date)) / 365) AS years_served
FROM employees
GROUP BY department, first_name, last_name
ORDER BY department, years_served DESC NULLS LAST;

--1. "How many employees in each department are enrolled in the pension scheme?"

SELECT
	department,
	count(id) AS staff_enrolled_in_pension
FROM employees
WHERE pension_enrol IS TRUE 
GROUP BY department;

--2. "Perform a breakdown by country of the number of employees that do not have a stored
-- first name."

SELECT
	country,
	count(id) AS no_first_name
FROM employees 
WHERE first_name IS NULL
GROUP BY country;

-- Show those departments in which at least 40 employees work either 0.25 or 0.5 FTE hours.
-- "WHERE" clause for group by is called "HAVING"

SELECT
	department, 
	count(id)
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department
HAVING count(id) >= 40; -- ONLY works WITH aggregates

-- Show any countries in which the minimum salary amongst pension enrolled employees is less
-- than 21,000 dollars.

SELECT country, min(salary), department
FROM employees 
WHERE pension_enrol IS TRUE
GROUP BY country, department -- ONLY need TO be COLUMNS that ARE NOT aggregates
HAVING min(salary) < 21000
ORDER BY min(salary), country, department;

-- NOTE: order by is usually similar to the group by.


-- Show any departments in which the earliest start date amongst grade 1 employees is prior
-- to 1991

SELECT 
	department,
	min(start_date) AS earliest_start_date
FROM employees
WHERE grade = 1
GROUP BY department
HAVING min(start_date) <= '1990-12-31';

-- Find all the employees in Japan who earn over the company-wide average salary.

SELECT *
FROM employees
WHERE country = 'Japan'
AND salary > (SELECT avg(salary) -- sub-query TO calculate average salary FROM entire dataset
			  FROM employees)
;

-- Find all the employees in legal who earn less than the average salary in that same department.

SELECT *
FROM employees
WHERE salary < (SELECT avg(salary)
				FROM employees
				WHERE department = 'Legal')
AND department = 'Legal';
















