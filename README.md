# World-Layoffs-Data-Analysis-SQL-Data-Cleaning-EDA-Project
Overview:

SQL data cleaning and exploratory data analysis on global layoffs dataset. Includes duplicate handling, data standardization, null treatment, and business-driven insights using MySQL (CTEs, Window Functions, Aggregations).
Global Layoffs Data Analysis (SQL Project):


Key Insights:

1: Certain industries (e.g., Tech, Crypto) were most affected by layoffs.
2: Several companies experienced 100% workforce reductions, showing complete shutdowns.
3: Layoffs often correlate with funding stages, highlighting risk patterns in early-stage vs. post-IPO companies.
4: Monthly and yearly trends revealed spikes during economic downturns.
5: Rolling cumulative layoffs help visualize momentum and severity over time.

Workflow:

1: Data Cleaning

-Removing duplicates:  Used ROW_NUMBER() over partitions, staged data for safe deduplication.
-Standardization:  Trimmed company names, normalized industry categories (e.g., Crypto), cleaned country names, converted   dates to proper DATE format.
-Null/Blank Handling:  Replaced empty strings with NULL, filled missing industry data via self-joins, removed irrelevant rows.
-Structural Cleanup:  Dropped helper columns; finalized dataset layoffs_staging2.

2: Exploratory Data Analysis (EDA):

-Analyzed layoffs by company, industry, country, and funding stage.
-Tracked yearly and monthly trends, including rolling totals with window functions.
-Identified top 5 most affected companies per year using DENSE_RANK().

Tools & Techniques:

SQL & MySQL
-Window Functions: ROW_NUMBER(), DENSE_RANK(), rolling SUM()
-CTEs (Common Table Expressions)
-Aggregate Functions
-Data Cleaning & Standardization
-Exploratory Data Analysis (EDA)


Author:
Maryam Najeeb – Aspiring Business Intelligence Analyst | Business & E-commerce Focus
Passionate about turning raw data into actionable insights.
