# Sobha Realty Delayed Transaction & Revenue Exposure Analysis

# Project Summary
This project analyses over 46,000 real estate transactions from Sobha Realty, Dubai, between 2018 and 2023 to identify patterns in delayed transactions and quantify the associated revenue exposure using SQL. The analysis explores how delays vary across projects, property types, transaction years, and buyer nationalities, with the aim of identifying areas that may require greater management attention.

# Problem Statement
Real estate transaction delays can affect revenue collection, cash flow, and operational planning. This project investigates where delayed transactions are concentrated, how delay rates have changed over time, and which property segments are associated with the highest revenue exposure.
The analysis focuses on the following questions:
How many total buyer-level transactions are there? 
What percentage of all transactions are delayed? 
How many delayed transactions happened in each year from 2018 to 2023? 
Which projects have the highest number of delayed transactions? 
Which property type is delayed the most? 
Is the average price of a delayed transaction higher or lower than a normal one? 
Which projects lose the biggest share of their revenue to delayed transactions? 
Which project + property type combination has the highest number of delayed transactions?
Which project has both high sales volume and a low delay rate (the best-performing project)?
Which projects have delays in every single year, not just once?
Do smaller properties get delayed more than bigger ones?
Which nationality's buyers are most affected by delayed transactions?
How has the delay percentage changed year by year?
Which property type has grown the fastest in transaction volume over the years?
What are the 10 most expensive delayed transactions?

# Dataset
* **Source:** Confidential business dataset
* **Original size:** 105,283 rows and 23 columns
* **Final analysis dataset:** Approximately 46,763 buyer-level transactions
* **Time period:** 2018–2023
* **Data preparation:** Cleaned and prepared in Microsoft Excel
* **Privacy:** Personal buyer and seller information was removed before analysis
> **Note:** The dataset is confidential and is not included in this repository. The analysis is based on the cleaned dataset used during the project.

# Tools Used
* SQL: DataCamp DataLab using DuckDB
* Microsoft Excel: Data cleaning and preparation
* GitHub: Project documentation and version control

## Repository Structure
sobha-realty-delay-analysis/
├── Data/
│   └── README_data_source.md
├── Docs/
│   ├── Sobha_MP2_Final_Report.pdf
│   └── Sobha_mp1_capstone_project.pdf
├── sql/
│   ├── 01_milestone1_queries.sql
│   └── 02_milestone2_queries.sql
├── visuals/
│   ├── Chart 1.png
│   ├── Chart 2.png
│   ├── Chart 3.png
│   ├── Chart 4.png
│   ├── Chart 5.png
│   ├── Chart 6.png
│   └── Chart 7.png
└── README.md

# Key Findings
1. Approximately **27% of transactions were delayed**.
2. The delay rate increased from **11% in 2018 to 33% in 2023**.
3. **Sobha Hartland – The Crest** had the highest transaction volume among the analyzed projects, with an observed delay rate of **0%**.
4. Medium-sized properties between **800 and 1,500 sqft** had the highest observed delay rate at **53%**.
5. **Four projects experienced delays in every year from 2018 to 2023**.
6. Transactions involving buyers from **China** had an observed delay rate of **54%** across **2,769 transactions**.
7. *Flats accounted for the highest number of delayed transactions*, while **Villas and Land** had the highest individual revenue exposure, reaching approximately **AED 95.6 million**.

# SQL Analysis
The SQL analysis is organized into two milestones.
# Milestone 1
Explores the overall transaction data, delay patterns, and revenue exposure across projects, property types, and years.
# Milestone 2
Builds on the initial analysis by examining recurring delays, buyer nationality patterns, and additional comparisons across property segments. Each query includes the analytical question it answers and an explanation of why the query was used.

# Visualizations
The project includes seven charts showing key findings from the SQL analysis. These visuals highlight delay trends, project-level comparisons, property-type patterns, and revenue exposure.

# Recommendations
Based on the observed patterns, management may benefit from:
* Prioritizing projects with consistently high delay rates.
* Investigating the reasons behind increasing delay rates over time.
* Reviewing medium-sized property segments, which show the highest observed delay rate.
* Monitoring revenue exposure in Villas and Land transactions.
* Conducting further investigation into buyer segments with higher observed delay rates.
These recommendations are based on patterns in the available dataset and do not establish the actual causes of delays.

# Limitations
This analysis is based only on the transaction status field in the dataset. It does not include expected or actual handover dates, payment schedules, or operational reasons for delays. Therefore, the analysis cannot confirm the real-world cause of a delay or establish whether a transaction was delayed because of a specific operational issue. The findings describe observed patterns in the available data and should not be interpreted as causal conclusions.

# What I Learned
Through this project, I practicined:
* Writing SQL queries to answer business questions.
* Cleaning and preparing data for analysis.
* Analyzing delay rates and revenue exposure.
* Comparing trends across projects, property types, and years.
* Organizing analytical work into milestones.
* Documenting SQL queries and explaining the reasoning behind them.
* Presenting findings through visualizations.
* Communicating data-driven recommendations and limitations.
