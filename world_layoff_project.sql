-- DATA CLEANING


-- 1. Remove Duplicates.
-- 2. Standardize the data.
-- 3. Null values or blaank values.
-- 4. Remove any columns and rows.

-- -----------------------------

-- 1. Remove Duplicates-- 

-- creating a staging table to work on

SELECT * 
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * FROM
layoffs;

-- to identify duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte
WHERE row_num >1;


SELECT * 
FROM layoffs_staging
WHERE company= 'Cazoo';

SELECT * 
FROM layoffs_staging;

-- creating a second staging table to delete duplicates

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)AS row_num
FROM layoffs_staging;


SELECT * 
FROM layoffs_staging2
WHERE row_num >1;


SELECT * 
FROM layoffs_staging2
WHERE row_num >1;


DELETE
FROM layoffs_staging2
WHERE row_num >1;


SELECT * 
FROM layoffs_staging2;

-- -----------------------------------------------------------
-- 2. Standardizing data

SELECT company, (Trim(company))
FROM layoffs_staging2;

SELECT (Trim(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company= (Trim(company));

-- now for industry

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry= 'Crypto' 
WHERE industry LIKE 'Crypto%';

-- ---------------------------------------------------------------
-- now for the country

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- here we used a bit advanced 'trailing' which means at the end

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country= TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
order by 1;

-- ---------------------------------------------------
-- now for the date


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y'); --

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- -----------------------------------------------

-- 3. Null values or blank values: 

SELECT *
FROM layoffs_staging2;



SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT DISTINCT industry, company
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';


SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry ='';

SELECT *
FROM layoffs_staging2
WHERE company= 'Airbnb';


SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- ------------------------------------------------------

-- 4. Remove any columns and rows:

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- --------------------------------------------------------------

-- Data Cleaning Completed..

-- ---------------------------------------------------------------
-- --(Exploritary Data Analyis): 

-- View the complete dataset to understand structure and columns

SELECT * 
FROM layoffs_staging2;

-- Find the earliest and latest layoff dates to understand the time range of the dataset

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Identify the maximum layoffs in a single event (absolute and percentage)

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Show companies that laid off 100% of employees (company shutdown cases)
-- Ordered by highest number of employees laid off

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off= 1
ORDER BY total_laid_off DESC;

-- Show companies that shut down (100% layoffs)
-- Ordered by funding raised to see how well-funded failed companies were

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off= 1
ORDER BY funds_raised_millions DESC;

-- Total layoffs by company to identify most impacted companies overall

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Total layoffs by industry to see which sectors were hit hardest

SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs by country to analyze geographic impact

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Year-wise total layoffs to identify trends over time

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1;

-- Total layoffs by company funding stage (Seed, Series A, Post-IPO, etc.)
-- Helps understand which maturity level was most affected

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Recheck full dataset (used after transformations or validations)

SELECT *
FROM layoffs_staging2;

-- Monthly total layoffs to analyze monthly trends
-- Extracting Year-Month from date for grouping

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY`Month`
ORDER BY 1;


-- Create CTE to calculate monthly layoffs
-- Then compute rolling (cumulative) layoffs over time

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY`Month`
ORDER BY 1
)
SELECT `Month`, total_off
 ,SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
 FROM Rolling_Total;
 
-- Total layoffs per company per year
-- Helps analyze yearly impact at company level

SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 1 ASC;

-- Same yearly company layoffs
-- Ordered by highest layoffs to find worst-hit company-year combinations

SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Step 1: Aggregate total layoffs per company per year
-- Step 2: Rank companies within each year based on total layoffs
-- Step 3: Select Top 5 most affected companies per year

WITH company_year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_year_rank AS
(SELECT *, DENSE_RANK() OVER( PARTITION BY `Year` ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE `Year` IS NOT NULL)
SELECT * 
FROM Company_year_rank
WHERE Ranking <=5;


SELECT *
FROM layoffs_staging2;



-- Project Completed..