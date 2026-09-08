# Sobha Realty Delayed Transaction & Revenue Exposure Analysis
## Project Summary
This project analyzes over 46,000 real estate transactions from Sobha Realty (Dubai) 
between 2018-2023 to identify patterns in delayed transactions, using SQL.
## Problem Statement
Sobha Realty has a large portfolio of property transactions across multiple projects 
and property types. A significant number of transactions in the available 2018-2023 
dataset are classified as delayed. This project analyzes where these delayed 
transactions are concentrated across projects, property types, and years, quantifies 
the revenue associated with them, and compares delay rates across projects to identify 
areas that may warrant greater management attention.
## Dataset
- Source: Obtained from an actual client business (confidential)
- Original size: 105,283 rows, 23 columns
- After cleaning: ~46,763 buyer-level transactions
- Personal buyer/seller information was removed before publishing
## Tools Used
- SQL (DataCamp DataLab, using DuckDB)
- Microsoft Excel (data cleaning)
## Repository Structure
sobha-realty-delay-analysis/
├── README.md
├── data/
│ └── sobha_cleaned.csv
├── sql/
│ ├── 01_milestone1_queries.sql
│ └── 02_milestone2_queries.sql
└── visuals/
├── chart1.png (through chart7.png)
## Key Findings
1. Close to 1 in 4 transactions (27%) are delayed
2. Delay rate nearly tripled from 2018 (11%) to 2023 (33%)
3. Sobha Hartland - The Crest has the highest volume with 0% delays (best performer)
4. Medium-sized properties (800-1500 sqft) have the highest delay rate (53%)
5. Four projects have been delayed every year for 6 consecutive years
6. Buyers from China show a high delay rate (54%) across a large sample (2,769 transactions)
7. While Flats drive the highest number of delayed transactions, the largest 
   individual amounts of money at risk (up to AED 95.6 million) are in Villas and Land
## Limitations
This analysis is based only on the transaction status field in the dataset. It does 
not include expected/actual handover dates, so it cannot confirm the real-world 
reason for a delay.
