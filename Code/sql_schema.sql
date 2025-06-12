-- Drop tables 
DROP TABLE IF EXISTS 
	"30_rate", 
	combined_table, 
	debt, 
	fed_rate, 
	hpi, 
	income;


-- 1. 30-Year Fixed Mortgage Rates
CREATE TABLE public."30_rate" (
    "Date" DATE,
    "Fixed_30_Rate" NUMERIC(10,2)
);

-- 2. Public Debt
CREATE TABLE public."debt" (
    "Date" DATE,
    "Total_Public_Debt" BIGINT
);

-- 3. Federal Funds Rate
CREATE TABLE public."fed_rate" (
    "Date" DATE,
    "Fed_Funds_Rate" NUMERIC(10,2)
);

-- 4. House Price Index
CREATE TABLE public."hpi" (
    "Date" DATE,
    "House_Price_Index" NUMERIC(10,2)
);

-- 5. Median Household Income
CREATE TABLE public."income" (
    "Date" DATE,
    "Median_Household_Income" INT
);

-- 6. Median Sales Price
CREATE TABLE public."median_sales" (
    "Date" DATE,
    "Median_Sales_Price" INT
);

SELECT * FROM "30_rate";

SELECT * FROM debt;

SELECT * FROM fed_rate;

SELECT * FROM hpi;

SELECT * FROM income;

SELECT * FROM median_sales

CREATE TABLE public."combined" AS
SELECT  
    d."Date",
    d."Total_Public_Debt",
    f."Fed_Funds_Rate",
    r."Fixed_30_Rate",
    h."House_Price_Index",
    i."Median_Household_Income",
    m."Median_Sales_Price"
FROM public."debt" d
LEFT JOIN public."fed_rate" f ON d."Date" = f."Date"
LEFT JOIN public."30_rate" r ON d."Date" = r."Date"
LEFT JOIN public."hpi" h ON d."Date" = h."Date"
LEFT JOIN public."income" i ON d."Date" = i."Date"
LEFT JOIN public."median_sales" m ON d."Date" = m."Date";

SELECT * FROM combined;
