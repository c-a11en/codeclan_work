/*
 * Filtering with WHERE
 */


-- Find the info for the employee with id = 3
SELECT *
FROM employees
WHERE id = 3;

/*
* Comparision operators
*
* != NOT equal TO
* = equal TO
* < less than
* <= less than OR equal TO 
*
*/

-- Find all employess who work 0.5 full-time equivalent hours or MORE 

SELECT *
FROM employees
WHERE fte_hours >= 0.5;

/*
 * Task - find all the employees not based in Brazil
 */

SELECT *
FROM employees
WHERE country != 'Brazil';

 /*
  * AND or OR
  * Combination operators
  */

-- Find all employees in China who started working for omni corp in 2019

SELECT *
FROM employees 
WHERE country = 'China' AND start_date >= '2019-01-01' AND start_date <= '2019-12-31';

-- Be wary of the order of evaluation

-- Find all the employees in China who either started working for omni from 2019 onwards OR are enrolled in the pension scheme

SELECT *
FROM employees
WHERE country = 'China' AND (start_date >= '2019-01-01' OR pension_enrol = TRUE);

 /*
  * BETWEEN, NOT and IN
  * 
  * let you specify a range of values
  */

-- Find all employees who work between 0.25 and 0.5 fte hours (inclusive)

SELECT *
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5;

-- Find all employees who started working for Omni in years other than 2017

SELECT *
FROM employees 
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-12-31';

-- Things to note: BETWEEN is inclusive, so FTE hours could be 0.25 or 0.5 in our example

-- IN 

-- Find all employees based in Spain, South Africa, Ireland or Germany

SELECT *
FROM employees 
WHERE country IN ('Spain', 'South Africa', 'Ireland', 'Germany');

-- note: can negate with NOT

/* 
  * Task - 5 mins
  * See if you can work out the query syntax to answer this problem:
  * "Find all employees who started work at OmniCorp in 2016 who work 0.5 full time equivalent hours or greater."
  * 
  * Hint
  * You need an AND combination of two conditions, one of which involves BETWEEN
  */

SELECT *
FROM employees 
WHERE start_date BETWEEN '2016-01-01' AND '2016-12-31' AND fte_hours >= 0.5;

 /* 
  * LIKE, wildcards and regex
  */

-- Your manager comes to you and says:

/*
 * I was talking with a colleague from Greece last month. I can't remember their last name exactly.
 * I think it began with "Mc..." something or other. Can you find them?
 */

SELECT *
FROM employees 
WHERE country = 'Greece' AND last_name LIKE 'Mc%';

/*
 * Wildcards
 * _ matches a single character
 * % matches zero or more characters
 */

-- can pop wildcards anywhere inside the pattern

-- Find all employees with last names containing the phrase 'ere'

SELECT *
FROM employees 
WHERE last_name LIKE '%ere%';

/*
 * LIKE is case sensitive (distinguishes between lowercase and uppercase) 
 */

SELECT *
FROM employees 
WHERE last_name LIKE 'D%';

-- can use ILIKE to be insensitive to upper/lowercase letters

SELECT *
FROM employees 
WHERE last_name ILIKE 'D%';

-- ~ to find a regex pattern match

-- Find all employees for whom the second letter of their last name is 'r' or 's' and the third letter
-- is 'a' or 'o'

SELECT *
FROM employees 
WHERE last_name ~ '^.[rs][ao]';

-- regex tweaks

/*
 * ~ ---- define a regex
 * ~*---- define a case-insensitive regex
 * !~---- define a negative regex (case sensitive does not match)
 * !~* -- case insensitive does not match
 */

SELECT *
FROM employees 
WHERE last_name !~ '^.[rs][ao]';

/*
 * IS NULL
 */

-- Q: We need to ensure our employee records are up-to-date. Find all employees who do not have a listed
-- email address?

SELECT *
FROM employees 
WHERE email IS NULL;

-- little gotcha column IS NULL, not column = NULL, similar to is.na() in R





