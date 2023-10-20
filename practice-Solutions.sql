CREATE TABLE Superheroes (
    SuperheroID INT PRIMARY KEY,
    RealName NVARCHAR(50),
    SuperheroName NVARCHAR(50),
    IsAvenger BIT,
    IsMutant BIT,
    Strength INT,
    Intelligence INT,
    Agility INT,
    Durability INT,
    Height FLOAT,
    Weight FLOAT,
    DateOfBirth DATETIME,
    DateOfFirstAppearance DATETIME
);

INSERT INTO Superheroes (SuperheroID, RealName, SuperheroName, IsAvenger, IsMutant, Strength, Intelligence, Agility, Durability, Height, Weight, DateOfBirth, DateOfFirstAppearance)
VALUES
    (1, 'Bruce Wayne', 'Batman', 1, 0, 85, 160, 75, 80, 6.2, 210, '1970-02-19', '1939-05-01'),
    (2, 'Clark Kent', 'Superman', 1, 1, 100, 170, 85, 100, 6.4, 235, '1965-07-12', '1938-06-01'),
    (3, 'Diana Prince', 'Wonder Woman', 1, 0, 90, 150, 80, 90, 6.0, 165, '1980-03-22', '1941-12-01'),
    (4, 'Peter Parker', 'Spider-Man', 0, 1, 60, 140, 95, 70, 5.10, 160, '1995-09-13', '1962-08-01'),
    (5, 'Tony Stark', 'Iron Man', 1, 0, 70, 180, 60, 75, 6.1, 190, '1968-12-30', '1963-03-01'), -- Added comma here
    (6, 'Barry Allen', 'The Flash', 0, 0, 70, 160, 90, 70, 6.0, 175, '1985-08-14', '1956-10-01'),
    (7, 'Hal Jordan', 'Green Lantern', 1, 0, 75, 150, 80, 80, 6.2, 200, '1978-05-02', '1959-09-01'),
    (8, 'Steve Rogers', 'Captain America', 1, 0, 80, 140, 75, 85, 6.0, 190, '1920-07-04', '1941-03-01'),
    (9, 'Natasha Romanoff', 'Black Widow', 0, 0, 60, 160, 90, 65, 5.7, 130, '1983-11-22', '1964-04-01'),
    (10, 'Arthur Curry', 'Aquaman', 0, 0, 85, 140, 70, 90, 6.3, 220, '1987-12-02', '1941-11-01');

SELECT * FROM Superheroes;

CREATE TABLE SuperheroAffiliations (
    AffiliationID INT PRIMARY KEY,
    SuperheroID INT,
    AffiliationName NVARCHAR(50)
);

INSERT INTO SuperheroAffiliations (AffiliationID, SuperheroID, AffiliationName)
VALUES
    (1, 1, 'Justice League'),
    (2, 1, 'The Bat Family'),
    (3, 2, 'Justice League'),
    (4, 2, 'Daily Planet'),
    (5, 3, 'Justice League'),
    (6, 3, 'Themyscira'),
    (7, 4, 'The Avengers'),
    (8, 5, 'The Avengers'),
    (9, 6, 'Justice League'),
    (10, 6, 'Flash Family');

--Question 1: Retrieve the total number of superheroes in the database.
SELECT COUNT(*) AS TotalSuperheroes FROM Superheroes;
--Question 2: List the real names and superhero names of all superheroes who are members of the "Justice League."
SELECT RealName, SuperheroName
FROM Superheroes
WHERE SuperheroID IN (SELECT SuperheroID FROM SuperheroAffiliations WHERE AffiliationName = 'Justice League');
--Question 3: Delete all superheroes whose agility is less than 70.
DELETE FROM Superheroes
WHERE Agility < 70;
--Question 4: Rename the SuperheroAffiliations table to HeroAffiliations.
EXEC sp_rename 'SuperheroAffiliations', 'HeroAffiliations';
--Question 5: Update the superhero "Batman" (Bruce Wayne) to have a new superhero name "Dark Knight."
UPDATE Superheroes
SET SuperheroName = 'Dark Knight'
WHERE RealName = 'Bruce Wayne';
--Question 6: Add a new column named "AliasIntroducedYear" of type INT to the Superheroes table.
ALTER TABLE Superheroes
ADD AliasIntroducedYear INT;
--Question 7: Calculate the total strength of superheroes for each affiliation, and list the affiliations with their total strength.
SELECT A.AffiliationName, SUM(S.Strength) AS TotalStrength
FROM HeroAffiliations A
INNER JOIN Superheroes S ON A.SuperheroID = S.SuperheroID
GROUP BY A.AffiliationName;
--Question 8: Find the superhero with the highest and lowest intelligence.
SELECT TOP 1 WITH TIES RealName, SuperheroName, Intelligence
FROM Superheroes
ORDER BY Intelligence DESC;

SELECT TOP 1 WITH TIES RealName, SuperheroName, Intelligence
FROM Superheroes
ORDER BY Intelligence;
--Question 9: List affiliations with an average durability greater than 80.
SELECT A.AffiliationName
FROM HeroAffiliations A
INNER JOIN Superheroes S ON A.SuperheroID = S.SuperheroID
GROUP BY A.AffiliationName
HAVING AVG(S.Durability) > 80;
--Question 10: List the real names and superhero names of superheroes who are members of any affiliation. Include the affiliation name if available.
SELECT S.RealName, S.SuperheroName, A.AffiliationName
FROM Superheroes S
LEFT JOIN HeroAffiliations A ON S.SuperheroID = A.SuperheroID;
--Question 11: List all affiliations and the superheroes who belong to them. Include affiliations even if they have no superheroes.
SELECT A.AffiliationName, S.RealName, S.SuperheroName
FROM HeroAffiliations A
LEFT JOIN Superheroes S ON A.SuperheroID = S.SuperheroID;
--Question 12: List all superheroes and their affiliations. Include superheroes even if they are not affiliated with any group.
SELECT S.RealName, S.SuperheroName, A.AffiliationName
FROM Superheroes S
LEFT JOIN HeroAffiliations A ON S.SuperheroID = A.SuperheroID;
--Question 13: List all affiliations and the superheroes who belong to them. Include all superheroes and affiliations, showing NULL if there's no match.
SELECT A.AffiliationName, S.RealName, S.SuperheroName
FROM HeroAffiliations A
RIGHT JOIN Superheroes S ON A.SuperheroID = S.SuperheroID;
--Question 14: You have a new superhero, "Captain Marvel," with RealName 'Carol Danvers.' If 'Carol Danvers' does not exist in the Superheroes table, add her as a new record.
IF NOT EXISTS (SELECT * FROM Superheroes WHERE RealName = 'Carol Danvers')
BEGIN
    INSERT INTO Superheroes (SuperheroID, RealName, SuperheroName)
    VALUES (11, 'Carol Danvers', 'Captain Marvel');
END
--Question 15: If there is a superhero with RealName 'Bruce Wayne,' change his superhero name to 'The Dark Knight.'
UPDATE Superheroes
SET SuperheroName = 'The Dark Knight'
WHERE RealName = 'Bruce Wayne';
--Question 16: If there is a superhero with RealName 'Peter Parker,' remove him from the Superheroes table.
DELETE FROM Superheroes
WHERE RealName = 'Peter Parker';
--Question 17: Remove all data from the HeroAffiliations table.
DELETE FROM HeroAffiliations;
--Question 18: Drop the HeroAffiliations table from the database.
DROP TABLE HeroAffiliations;















