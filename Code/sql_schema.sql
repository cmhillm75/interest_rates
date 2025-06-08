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