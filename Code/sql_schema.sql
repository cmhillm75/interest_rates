-- Add Columns to 30_rate table 
ALTER TABLE public."30_rate"
ADD COLUMN Date DATE,
ADD COLUMN Fixed_30_Rate NUMERIC(10,2);

-- Add Columns to debt table 
ALTER TABLE public."debt"
ADD COLUMN Date DATE,
ADD COLUMN Total_Public_Debt BIGINT;

-- Add Columns to fed_rate table
ALTER TABLE public."fed_rate"
ADD COLUMN Date DATE,
ADD COLUMN Fed_Funds_Rate NUMERIC(10,2);

-- Add Columns to hpi table
ALTER TABLE public."hpi"
ADD COLUMN Date DATE,
ADD COLUMN House_Price_Index NUMERIC(10,2);


-- Correct Capitalization on column names
ALTER TABLE public."30_rate" 
RENAME COLUMN date TO "Date";

ALTER TABLE public."30_rate" 
RENAME COLUMN fixed_30_rate TO "Fixed_30_Rate";

ALTER TABLE public."debt" 
RENAME COLUMN date TO "Date";

ALTER TABLE public."debt" 
RENAME COLUMN total_public_debt TO "Total_Public_Debt";

ALTER TABLE public."fed_rate" 
RENAME COLUMN date TO "Date";

ALTER TABLE public."fed_rate" 
RENAME COLUMN fed_funds_rate TO "Fed_Funds_Rate";

ALTER TABLE public."hpi" 
RENAME COLUMN date TO "Date";

ALTER TABLE public."hpi" 
RENAME COLUMN house_price_index TO "House_Price_Index";


-- Check data types
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name IN ('30_rate', 'debt', 'fed_rate', 'hpi');


-- Join all the tables into 1 for output to Tableau
SELECT 
    d."Date",
    d."Total_Public_Debt",
    f."Fed_Funds_Rate",
    r."Fixed_30_Rate",
    h."House_Price_Index"
FROM public."debt" d
JOIN public."fed_rate" f ON d."Date" = f."Date"
JOIN public."30_rate" r ON d."Date" = r."Date"
JOIN public."hpi" h ON d."Date" = h."Date";

CREATE TABLE public."combined_table" AS
SELECT  
    d."Date",
    d."Total_Public_Debt",
    f."Fed_Funds_Rate",
    r."Fixed_30_Rate",
    h."House_Price_Index"
FROM public."debt" d
JOIN public."fed_rate" f ON d."Date" = f."Date"
JOIN public."30_rate" r ON d."Date" = r."Date"
JOIN public."hpi" h ON d."Date" = h."Date";


-- Select all the data in combined_table
SELECT * FROM public."combined_table";


-- When adding new data to tables
TRUNCATE TABLE public."combined_table";  -- Clears existing data
INSERT INTO public."combined_table"
SELECT  
    d."Date",
    d."Total_Public_Debt",
    f."Fed_Funds_Rate",
    r."Fixed_30_Rate",
    h."House_Price_Index"
FROM public."debt" d
JOIN public."fed_rate" f ON d."Date" = f."Date"
JOIN public."30_rate" r ON d."Date" = r."Date"
JOIN public."hpi" h ON d."Date" = h."Date";



-- Check for the Min and Max rate categories
WITH MaxMinRates AS (
    SELECT 
        MAX("Fed_Funds_Rate") AS max_fed_rate,
        MIN("Fed_Funds_Rate") AS min_fed_rate,
        MAX("Fixed_30_Rate") AS max_fixed_rate,
        MIN("Fixed_30_Rate") AS min_fixed_rate
    FROM public."combined_table"
)
SELECT 
    c."Date",
    c."Total_Public_Debt",
    c."House_Price_Index",
    c."Fed_Funds_Rate",
    c."Fixed_30_Rate"
FROM public."combined_table" c
JOIN MaxMinRates mm ON 
    c."Fed_Funds_Rate" IN (mm.max_fed_rate, mm.min_fed_rate)
    OR c."Fixed_30_Rate" IN (mm.max_fixed_rate, mm.min_fixed_rate);


-- Query for Fed_Runds Rate
SELECT 
    "Date", 
    "Total_Public_Debt", 
    "House_Price_Index", 
    "Fed_Funds_Rate" 
FROM public."combined_table" 
WHERE "Fed_Funds_Rate" = (SELECT MAX("Fed_Funds_Rate") FROM public."combined_table") 
   OR "Fed_Funds_Rate" = (SELECT MIN("Fed_Funds_Rate") FROM public."combined_table");

-- Query for Fixed_30_Rate
SELECT 
    "Date", 
    "Total_Public_Debt", 
    "House_Price_Index", 
    "Fixed_30_Rate" 
FROM public."combined_table" 
WHERE "Fixed_30_Rate" = (SELECT MAX("Fixed_30_Rate") FROM public."combined_table") 
   OR "Fixed_30_Rate" = (SELECT MIN("Fixed_30_Rate") FROM public."combined_table");


-- Create table for income
CREATE TABLE income (
    "Date" DATE,
    "Median_Household_Income" BIGINT
);


-- Drop table 
DROP TABLE IF EXISTS income;

-- View data in the income table
SELECT * FROM income;


-- add income data to combined table
ALTER TABLE public."combined_table"
ADD COLUMN "Median_Household_Income" BIGINT;

UPDATE public."combined_table" c
SET "Median_Household_Income" = i."Median_Household_Income"
FROM public."income" i
WHERE c."Date" = i."Date";

-- query the updated table data
SELECT * FROM public."combined_table"
ORDER BY "Date" ASC;
-- LIMIT 10;