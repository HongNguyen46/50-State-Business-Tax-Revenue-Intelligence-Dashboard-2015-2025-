-- Create the population_2015_2025 file and combine the datasets

SELECT TOP (1000) [State]
      ,[Year]
      ,[Population]
  FROM [salt_50state_db].[dbo].[population_2015_2025]

  ;WITH DuplicateRows AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY State, Year
               ORDER BY State
           ) AS rn
    FROM population_2015_2025
)
DELETE FROM DuplicateRows
WHERE rn > 1;

SELECT COUNT(*) AS TotalRows
FROM population_2015_2025;

SELECT
    State,
    Year,
    COUNT(*) AS NumRows
FROM population_2015_2025
GROUP BY State, Year
HAVING COUNT(*) > 1;

SELECT
    State,
    COUNT(*) AS Years
FROM population_2015_2025
GROUP BY State
ORDER BY State;

EXEC sp_help 'population_2015_2025';

SELECT *
FROM population_2015_2025
ORDER BY State, Year;

