-- Confirm in the correct database
SELECT DB_NAME() AS current_database;

-- Check actual table names
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

--Create an empty table using the first quarter
SELECT *
INTO dbo.fact_qtax_revenue
FROM dbo.qtax_2015_q1_clean
WHERE 1 = 0;

--Automatically insert all 44 tables
DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = @SQL +
'
INSERT INTO dbo.fact_qtax_revenue
SELECT *
FROM ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ';
'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'qtax[_]20%[_]q[1-4][_]clean'
ORDER BY TABLE_NAME;

EXEC sp_executesql @SQL;

-- Verify the results
SELECT COUNT(*) AS TotalRows
FROM dbo.fact_qtax_revenue;

--Preview the data
SELECT TOP (1000) *
FROM dbo.fact_qtax_revenue;

-- 
EXEC master..xp_cmdshell '
bcp "SELECT * FROM salt_50state_db.dbo.fact_qtax_revenue"
queryout "C:\Users\Hong Nhien Nguyen\Downloads\fact_qtax_revenue.csv"
-c -t, -T';

