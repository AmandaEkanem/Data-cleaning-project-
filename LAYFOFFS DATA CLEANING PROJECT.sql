SELECT * 
FROM world_layoffs.layoffs;


-- STEP1. REMOVE DUPLICATES

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

SELECT *, ROW_NUMBER () OVER(PARTITION BY company, location, industry, total_laid_off,
							percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *, ROW_NUMBER () OVER(PARTITION BY company, location, industry, total_laid_off,
							percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

-- To delete the duplicate, I will create another table including the row_num column
-- I right click on layoffs_staging, copy to clipboard the create statement and added row_num column

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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT layoffs_staging2
SELECT *, ROW_NUMBER () OVER(PARTITION BY company, location, industry, total_laid_off,
							percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

DELETE 
FROM layoffs_staging2
WHERE row_num >1;

-- STEP2. STANDARDIZING DATA
-- I'll be finding issues with the data, and fixing it

SELECT DISTINCT company
FROM layoffs_staging2;

-- I noticed space in company column
SELECT company, trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT DISTINCT company
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2;

-- I noticed that crypto and crptocurrency are the same industry
-- i'll give them one unique name 'crypto'

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crpto%';

-- looking at the location column

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- I noticed on of the location "malma" has a space sign to it

SELECT *
FROM layoffs_staging2
WHERE location LIKE 'malm%';

UPDATE layoffs_staging2
SET location = 'Malmo'
WHERE location LIKE 'malm%';

-- LOOKING AT THE COUNTRY COLUMN

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- I found 'united states' are two with one containing a (.)

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE country LIKE 'united states%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%' 
;


-- LOOKING AT THE DATE COLOUMN
-- I will be changing date column from `date` timeseries to date format

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

select `date`
from layoffs_staging2;

-- I'll now change the `date` to date 

ALTER TABLE layoffs_staging2
MODIFY column `date` Date;


-- STEP3. HANDLING NULL VALUES OR BLANCK VALUES
-- To find null values we use the (IS NULL) statement

-- Since this project is a layoff project if total_laid_off and percentage_laid_off are blank, then they didn't take part in the layoff
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- To look at blancks or null in Industry

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

-- i'll populate its industry from the other Airbnb since they are in the same location, and country, which mean they are in the same industry
-- to populate, i need to set everything to Null
UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs_staging2
where company ='airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 T1 JOIN layoffs_staging2 T2
	ON T1.company = T2.company
    AND T1.location = T2.location
WHERE T1.industry IS NULL 
	AND T2.industry IS NOT NULL;
    
    
UPDATE layoffs_staging2 T1 JOIN layoffs_staging2 T2
	ON T1.company = T2.company
    AND T1.location = T2.location
SET T1.industry=t2.industry
WHERE T1.industry IS NULL 
	AND T2.industry IS NOT NULL;
    
    SELECT *
FROM layoffs_staging2
where company ='airbnb';


-- STEP4. REMOVING ANY UNWANTED COLUMN AND ROWS

-- Using the Delete statement, i have remove the unwanted column that i identified earlier
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;


-- i will now remove the ROW_NUM column because i no longer need it
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;

-- THIS IS THE END OF THE DATA CLEANING PROJECT
-- I Have made the data useful and reliable to be used for future analysis
    
    
    
    





 






