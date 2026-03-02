
🌍 World Layoffs Data Analysis – SQL Cleaning & EDA

Turning messy global layoffs data into structured business insights using SQL.

 Project Summary

📈 Analyzed layoffs globally (2020–2023)
Explored workforce reduction trends across multiple years to understand the scale and timing of global layoffs.

📊 Identified industry & geographic patterns
Detected which industries and countries were most affected and how layoffs varied across funding stages.

🧠 Used SQL to clean messy real-world data
Handled duplicates using window functions, standardized inconsistent values, treated nulls, and transformed raw text dates into structured formats.

🏆 Ranked top impacted companies yearly
Applied ranking logic (DENSE_RANK) to identify the most affected companies each year and built rolling monthly trends to track layoff momentum.

🔍 Key Insights

Certain industries were consistently more vulnerable to layoffs.

Multiple companies experienced 100% workforce reductions (complete shutdowns).

Layoff waves aligned with broader economic slowdowns.

Funding stage influenced layoff behavior patterns.

Rolling monthly totals revealed compounding momentum rather than isolated events.

---------------------------------------------------------------------------------

Yearly company layoffs Ordered by highest layoffs to find worst-hit company-year combinations:

<img width="1920" height="973" alt="World_layoff_project4" src="https://github.com/user-attachments/assets/094cf502-3699-4d3e-94bb-e7c7ca6b4119" />

-- Aggregate total layoffs per company per year
-- Rank companies within each year based on total layoffs
-- Select Top 5 most affected companies per year

<img width="1920" height="973" alt="World_layoff_project3" src="https://github.com/user-attachments/assets/7928a764-0ce6-4d83-8bd7-268c33ebc6a9" />

Create CTE to calculate monthly layoffs, Then compute rolling (cumulative) layoffs over time

<img width="1920" height="973" alt="World_layoff_project2" src="https://github.com/user-attachments/assets/ba6447d6-a075-4154-b3ad-34a3cb041a5d" />

-----------------------------------------------------------------------------------------------------------------

🛠 Technical Skills Demonstrated:

SQL | MySQL | Data Cleaning | Window Functions
ROW_NUMBER() | DENSE_RANK() | Rolling SUM()
CTEs | Aggregations | Business-Focused EDA

📂 Repository Contents

world_layoff_project.sql – Full data cleaning & analysis workflow

README.md – Project documentation

👩‍💻 About Me:

Maryam Najeeb – Aspiring Business Intelligence Analyst | Business & E-commerce Focus
Passionate about turning raw data into actionable insights.
