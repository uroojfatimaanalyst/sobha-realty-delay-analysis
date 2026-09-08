-- ============================================
-- MILESTONE 1 - SQL QUERIES
-- Sobha Realty Delayed Transaction Analysis
-- ============================================

--Question 1: How many total buyer-level transactions are there?
--Why this query: establishes the overall transaction volume used as the base for every other calculation.
SELECT COUNT(*) AS total_transactions
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer';

--Question 2: What percentage of all transactions are delayed? 
--Why this query: calculates how many of the total transactions are delayed, and what share of the total that represents.
SELECT 
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
WHERE ProcedurePartyTypeNameEn = 'Buyer';

--Question 3: How many delayed transactions happened in each year from 2018 to 2023? 
--Why this query: groups transactions by year to see whether delays are getting better or worse over time, not just what the 
--current overall rate is. The Regis column contained two different date formats in the raw file, so TRY_STRPTIME with two 
--format patterns was used to read it correctly.
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
        THEN 1 ELSE 0 END) AS delayed_transactions
FROM 'sobha_cleaned.csv'
WHERE ProcedurePartyTypeNameEn = 'Buyer'
GROUP BY 1
ORDER BY 1;

-- Question 4: Which projects have the highest number of delayed transactions? 
--Why this query: ranks projects by raw delayed-transaction count to identify where management attention is most urgently 
--needed in absolute terms.
SELECT 
    Project, 
    COUNT(*) AS delayed_count 
FROM 'sobha_cleaned.csv' 
WHERE ProcedurePartyTypeNameEn = 'Buyer' 
  AND ProcedureNameEn IN 
      ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage', 
       'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration') 
GROUP BY Project 
ORDER BY delayed_count DESC 
LIMIT 10; 

--Question 5: Which property type is delayed the most?
--Why this query: breaks delays down by property type, and calculates delay_percentage (not just raw count) so that small but 
--high-risk categories are not hidden behind larger ones
SELECT 
    PropertyTypeEn, 
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
GROUP BY PropertyTypeEn 
ORDER BY delayed_transactions DESC; 

--Question 6: Is the average price of a delayed transaction higher or lower than a normal one?
--Why this query: compares average transaction value for delayed vs. normal transactions to see whether higher-value deals 
--are more or less likely to be delayed. ProcedureValue is stored as text in the file, so TRY_CAST is used to safely convert 
--it to a number.
SELECT 
    CASE WHEN ProcedureNameEn IN 
        ('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage', 
         'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration') 
        THEN 'Delayed' ELSE 'Normal' END AS transaction_status, 
    ROUND(AVG(TRY_CAST(ProcedureValue AS DOUBLE)), 2) AS avg_price, 
    COUNT(*) AS total_count 
FROM 'sobha_cleaned.csv' 
WHERE ProcedurePartyTypeNameEn = 'Buyer' 
  AND TRY_CAST(ProcedureValue AS DOUBLE) > 0 
GROUP BY transaction_status; 

--Question 7: Which projects lose the biggest share of their revenue to delayed transactions? 
--Why this query: looks at revenue exposure rather than transaction count, and filters out very low-volume projects 
--(fewer than 30 transactions) so a single delayed sale in a tiny project doesn't distort the ranking. 
SELECT 
Project, 
SUM(TRY_CAST(ProcedureValue AS DOUBLE)) AS total_project_value, 
SUM(CASE WHEN ProcedureNameEn IN 
('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage', 
'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration') 
THEN TRY_CAST(ProcedureValue AS DOUBLE) ELSE 0 END) AS delayed_value, 
ROUND( 
SUM(CASE WHEN ProcedureNameEn IN 
('Complete Delayed Sell', 'Delayed Sell', 'Delayed Mortgage', 
'Grant on Delayed Sell', 'Delayed Sell Lease to Own Registration') 
THEN TRY_CAST(ProcedureValue AS DOUBLE) ELSE 0 END) * 100.0 
/ SUM(TRY_CAST(ProcedureValue AS DOUBLE)), 2 
) AS pct_value_delayed 
FROM 'sobha_cleaned.csv' 
WHERE ProcedurePartyTypeNameEn = 'Buyer' AND TRY_CAST(ProcedureValue AS DOUBLE) > 0 
GROUP BY Project 
HAVING COUNT(*) >= 30 
ORDER BY pct_value_delayed DESC 
LIMIT 10; 
