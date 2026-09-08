-- ============================================
-- MILESTONE 2 - SQL QUERIES
-- Sobha Realty Delayed Transaction Analysis
-- ============================================

--Question 1: Which project + property type combination has the highest number of delayed transactions?
--Why this query: goes one level deeper than Milestone 1 - instead of looking at project or property type separately, 
--it looks at specific combinations, which is more actionable for management.
SELECT
    Project,
    PropertyTypeEn,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN ProcedureNameEn IN
        ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
         'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
        THEN 1 ELSE 0 END) AS delayed_transactions
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer'
GROUP BY Project, PropertyTypeEn
HAVING COUNT(*) >= 30
ORDER BY delayed_transactions DESC
LIMIT 10;

--Question 2: Which project has both high sales volume and a low delay rate (the best-performing project)?
--Why this query: instead of only ranking projects by how bad their delays are, this looks for a positive benchmark 
--a project that sells a lot and still keeps delays low.
SELECT
    Project,
    COUNT(*) AS total_transactions,
    ROUND(
        SUM(CASE WHEN ProcedureNameEn IN
            ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
             'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS delay_percentage
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer'
GROUP BY Project
HAVING COUNT(*) >= 100
ORDER BY total_transactions DESC, delay_percentage ASC
LIMIT 10;

--Question 3: Which projects have delays in every single year, not just once?
--Why this query: uses a CTE to first calculate delayed transactions per project per year, then counts how many distinct years
--each project shows up with at least one delay, to separate a one-time issue from an ongoing pattern.
WITH yearly_delays AS (
    SELECT
        Project,
        YEAR(
            COALESCE(
                TRY_STRPTIME(Regis, '%d/%m/%Y'),
                TRY_STRPTIME(Regis, '%d-%b-%y')
            )
        ) AS transaction_year,
        SUM(CASE WHEN ProcedureNameEn IN
            ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
             'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
            THEN 1 ELSE 0 END) AS delayed_count
    FROM 'sobha_cleaned.csv'
    WHERE ProcedurePartyTypeNameEn = 'Buyer'
    GROUP BY Project, transaction_year
)
SELECT
    Project,
    COUNT(DISTINCT transaction_year) AS years_with_delays
FROM yearly_delays
WHERE delayed_count > 0
GROUP BY Project
HAVING COUNT(DISTINCT transaction_year) >= 5
ORDER BY years_with_delays DESC
LIMIT 10;

--Question 4: Do smaller properties get delayed more than bigger ones?
--Why this query: uses CASE WHEN to group properties into Small, Medium, and Large size categories (a new business category, 
--not just a delayed/not-delayed flag), then compares delay rates across the three groups.
SELECT
    CASE
        WHEN Size < 800 THEN 'Small (under 800 sqft)'
        WHEN Size >= 800 AND Size < 1500 THEN 'Medium (800-1500 sqft)'
        WHEN Size >= 1500 THEN 'Large (1500+ sqft)'
        ELSE 'Unknown'
    END AS size_category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN ProcedureNameEn IN
        ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
         'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
        THEN 1 ELSE 0 END) AS delayed_transactions,
    ROUND(
        SUM(CASE WHEN ProcedureNameEn IN
            ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
             'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS delay_percentage
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer' AND Size IS NOT NULL
GROUP BY size_category
ORDER BY delay_percentage DESC;

--Question 5: Which nationality's buyers are most affected by delayed transactions?
--Why this query: calculates delay percentage by buyer nationality, filtered to nationalities with at least 50 transactions,
--so a country with only 1-2 buyers doesn't distort the ranking.
SELECT
    CountryNameEn,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN ProcedureNameEn IN
        ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
         'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
        THEN 1 ELSE 0 END) AS delayed_transactions,
    ROUND(
        SUM(CASE WHEN ProcedureNameEn IN
            ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
             'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS delay_percentage
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer' AND CountryNameEn IS NOT NULL
GROUP BY CountryNameEn
HAVING COUNT(*) >= 50
ORDER BY delay_percentage DESC
LIMIT 10;

--Question 6: How has the delay percentage changed year by year?
--Why this query: extends the Milestone 1 year-wise count into a year-wise percentage, to see the trend more precisely rather 
--than just raw numbers.
SELECT
    YEAR(
        COALESCE(
            TRY_STRPTIME(Regis, '%d/%m/%Y'),
            TRY_STRPTIME(Regis, '%d-%b-%y')
        )
    ) AS transaction_year,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN ProcedureNameEn IN
        ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
         'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
        THEN 1 ELSE 0 END) AS delayed_transactions,
    ROUND(
        SUM(CASE WHEN ProcedureNameEn IN
            ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
             'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS delay_percentage
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer'
GROUP BY 1
ORDER BY 1;

--Question 7: Which property type has grown the fastest in transaction volume over the years?
--Why this query: compares year-over-year transaction volume for the main property types, to see which one is driving Sobha's
--overall growth.
SELECT
    PropertyTypeEn,
    YEAR(
        COALESCE(
            TRY_STRPTIME(Regis, '%d/%m/%Y'),
            TRY_STRPTIME(Regis, '%d-%b-%y')
        )
    ) AS transaction_year,
    COUNT(*) AS total_transactions
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer' AND PropertyTypeEn IN ('Flat', 'Unit', 'Villa')
GROUP BY PropertyTypeEn, transaction_year
ORDER BY PropertyTypeEn, transaction_year;

--Question 8: What are the 10 most expensive delayed transactions?
--Why this query: identifies the specific highest-value transactions sitting in delayed status, to see where the largest single
--amounts of money are tied up.
SELECT
    Project,
    PropertyTypeEn,
    TRY_CAST(ProcedureValue AS DOUBLE) AS price,
    ProcedureNameEn
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer'
  AND ProcedureNameEn IN
      ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage',
       'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration')
ORDER BY price DESC
LIMIT 10;

