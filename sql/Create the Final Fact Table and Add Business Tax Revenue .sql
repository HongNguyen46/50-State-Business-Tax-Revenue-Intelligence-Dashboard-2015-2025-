-- Confirm in the correct database
SELECT DB_NAME() AS current_database;

-- Check actual table names
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

-- Identify REAL column names
-- Check fact table
SELECT TOP 10 * FROM fact_tax_revenue;

-- Check population table
SELECT TOP 10 * FROM population_2015_2025;

-- Check sales tax rate
SELECT TOP 10 * FROM sales_tax_rate_2025_cleaned;

-- Check corporate tax rate
SELECT TOP 10 * FROM corporate_tax_rate_2026_cleaned;

--- REAL column mapping
SELECT
    f.state AS State,
    f.year AS Year,
    f.property_tax,
    f.sales_tax,
    f.corporate_income_tax,
    p.Population,
    st.State_Tax_Rate AS Sales_Tax_Rate,
    ct.Rates AS Corporate_Tax_Rate
INTO fact_business_tax
FROM fact_tax_revenue f

LEFT JOIN population_2015_2025 p
    ON f.state = p.State
   AND f.year = p.Year

LEFT JOIN sales_tax_rate_2025_cleaned st
    ON f.state = st.State

LEFT JOIN corporate_tax_rate_2026_cleaned ct
    ON f.state = ct.State;

    -- Keep as VIEW: This avoids duplicate storage and is cleaner for Power BI.
    CREATE VIEW vw_fact_business_tax AS
SELECT
    f.state AS State,
    f.year AS Year,
    f.property_tax,
    f.sales_tax,
    f.corporate_income_tax,
    p.Population,
    st.State_Tax_Rate AS Sales_Tax_Rate,
    ct.Rates AS Corporate_Tax_Rate
FROM fact_tax_revenue f
LEFT JOIN population_2015_2025 p
    ON f.state = p.State
   AND f.year = p.Year
LEFT JOIN sales_tax_rate_2025_cleaned st
    ON f.state = st.State
LEFT JOIN corporate_tax_rate_2026_cleaned ct
    ON f.state = ct.State;
GO

    -- Test the view
    SELECT TOP 100 * 
FROM vw_fact_business_tax;

CREATE VIEW vw_fact_business_tax AS
SELECT
    f.state AS State,
    f.year AS Year,
    f.property_tax,
    f.sales_tax,
    f.corporate_income_tax,
    p.Population,
    st.State_Tax_Rate AS Sales_Tax_Rate,
    ct.Rates AS Corporate_Tax_Rate
FROM fact_tax_revenue f
LEFT JOIN population_2015_2025 p
    ON f.state = p.State
   AND f.year = p.Year
LEFT JOIN sales_tax_rate_2025_cleaned st
    ON f.state = st.State
LEFT JOIN corporate_tax_rate_2026_cleaned ct
    ON f.state = ct.State;
GO

-- Add a critical KPI
SELECT
    *,
    (property_tax + sales_tax + corporate_income_tax) AS Total_Tax,
    (property_tax + sales_tax + corporate_income_tax) * 1.0 / Population AS Tax_Per_Capita
FROM vw_fact_business_tax;