-- ONE TO ONE - 1 person has 1 NI number
-- ONE TO MANY - 1 diet can have many animals
-- MANY TO MANY - 1 animal could have MANY keepers, 1 keeper could have MANY animals

-- IF YOU SEE more than 1 FK in a table, it's generally a join table

-- INNER Join implies at least 1-1 or a 1-Many
SELECT
	A.name, A.species, A.age,
	D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id
WHERE A.age > 4;

-- Get the animals in the zoo group by diet type

SELECT
	D.diet_type,
	count(A.id)	
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type;

-- Modify the above to return all herbivores only
-- Count the animals in the zoo group by diet type

-- default inner join
SELECT
	D.diet_type,
	count(A.id)
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id
WHERE D.diet_type = 'herbivore'
GROUP BY D.diet_type;

--left join returns all records on the left table and any matching records on the RIGHT 

SELECT
A.name, A.species, A.age,  D.diet_type
FROM animals AS A
LEFT JOIN diets AS D ON A.diet_id = D.id;

-- right join returns all records on the right table and any matching records on the LEFT 

SELECT
A.name, A.species, A.age,  D.diet_type
FROM animals AS A
RIGHT JOIN diets AS D ON A.diet_id = D.id;

-- RIGHT join is the inverse of the left join, switching the order returns the outputs of
-- the left join

SELECT
A.name, A.species, A.age,  D.diet_type
FROM diets AS D 
RIGHT JOIN animals AS A ON A.diet_id = D.id;

-- Return how many animals follow each diet type, including any diets which no animal
-- follows

SELECT diets.diet_type, 
	count(animals.id)
FROM animals
LEFT JOIN diets ON diets.id = animals.diet_id
GROUP BY diets.diet_type;

-- FULL JOIN brings back all records in both tables

SELECT A.name, A.species, A.age,
		D.diet_type
FROM animals AS A
FULL JOIN diets AS D ON A.diet_id = D.id;

-- get a rota for the keepers and the animals they look after,
-- ordered first by animal name, and then by DAY 

SELECT A."name" AS animal_name,
A.species,
CS."day",
K.name AS keeper_name
FROM animals AS A
INNER JOIN	care_schedule AS CS ON A.id = CS.animal_id
INNER JOIN keepers AS K ON K.id = CS.keeper_id
ORDER BY CS.DAY, A.name;

-- For the above, change to show me the keeper for Ernest the Snake

SELECT A."name" AS animal_name,
A.species,
CS."day",
K.name AS keeper_name
FROM animals AS A
INNER JOIN	care_schedule AS CS ON A.id = CS.animal_id
INNER JOIN keepers AS K ON K.id = CS.keeper_id
WHERE A.species = 'Snake' AND A."name" = 'Ernest'
ORDER BY CS.DAY, A.name;

Various animals feature on various tours around the zoo (this is another example of a many-to-many relationship).

--Identify the join table linking the animals and tours table and reacquaint yourself
--with its contents. Obtain a table showing animal name and species, the tour name on
--which they feature(d), along with the start date and end date (if stored) of their
--involvement. Order the table by tour name, and then by animal name.
--[Harder] - can you limit the table to just those animals currently featuring on tours. Perhaps the NOW() function might help? Assume an animal with a start date in the past and either no stored end date or an end date in the future is currently active on a tour.

SELECT
	animals."name",
	animals.species,
	tours."name",
	animals_tours.start_date,
	animals_tours.end_date
FROM animals 
JOIN animals_tours ON animals.id = animals_tours.animal_id
INNER JOIN tours ON animals_tours.tour_id = tours.id
WHERE end_date IS NULL 
ORDER BY tours."name", animals."name";

-- SELF JOIN 

SELECT
	keepers.name AS keeper_name,
	managers.name AS manager_name
FROM keepers
INNER JOIN keepers AS managers ON keepers.manager_id = managers.id;

-- UNIONS

SELECT * FROM animals 
UNION ALL -- eliminates duplicates
SELECT * FROM animals




