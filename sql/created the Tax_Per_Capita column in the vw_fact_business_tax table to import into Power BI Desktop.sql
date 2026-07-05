-- Confirm in the correct database
SELECT DB_NAME() AS current_database;

-- Check actual table names
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

USE salt_50state_db;
GO

SELECT TOP 10 *
FROM vw_fact_business_tax;

-- Add a critical KPI
SELECT
    *,
    (property_tax + sales_tax + corporate_income_tax) AS Total_Tax,
    (property_tax + sales_tax + corporate_income_tax) * 1.0 / Population AS Tax_Per_Capita
FROM vw_fact_business_tax;
