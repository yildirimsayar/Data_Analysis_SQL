CREATE TABLE layoffs_work
LIKE layoffs;

INSERT  layoffs_work
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_work
LIMIT 5;

SELECT*,
ROW_NUMBER() OVER(
                  PARTITION BY company,industry,total_laid_off,
                  `date`,stage,country,location,
                  funds_raised_millions,percentage_laid_off)
                  AS Duplicates
FROM layoffs_work;

WITH duplicates_CTE AS(
SELECT*,
ROW_NUMBER() OVER(
                  PARTITION BY company,industry,total_laid_off,`date`,
                  stage,country,location,
                  funds_raised_millions,percentage_laid_off)
                  AS Duplicates
FROM layoffs_work
)
SELECT *
FROM duplicates_CTE
WHERE Duplicates>1;                 

CREATE TABLE `layoffs_work_dup` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `Duplicates` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
FROM layoffs_work_dup;

INSERT INTO layoffs_work_dup
SELECT*,
ROW_NUMBER() OVER(
                  PARTITION BY company,industry,total_laid_off,
                  `date`,stage,country,location,funds_raised_millions,
                  percentage_laid_off)
                  AS Duplicates
FROM layoffs_work;

SET SQL_SAFE_UPDATES = 0;

SELECT*
FROM layoffs_work_dup
WHERE Duplicates>1;

DELETE
FROM layoffs_work_dup
WHERE Duplicates>1;

SELECT*
FROM layoffs_work_dup
WHERE Duplicates>1;

UPDATE layoffs_work_dup
SET company=TRIM(company);

SELECT *
FROM layoffs_work_dup
ORDER BY industry ASC;

SELECT DISTINCT(industry)
FROM layoffs_work_dup
ORDER BY 1;

UPDATE layoffs_work_dup
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT(country)
FROM layoffs_work_dup
ORDER BY country ASC;

UPDATE layoffs_work_dup
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_work_dup;

UPDATE layoffs_work_dup
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_work_dup
MODIFY COLUMN `date` DATE;

SELECT `date`
FROM layoffs_work_dup
WHERE `date` is null;

SELECT *
FROM layoffs_work_dup
LIMIT 5;

SELECT *
FROM layoffs_work_dup
WHERE total_laid_off is null AND percentage_laid_off is null
ORDER BY company ASC;

SELECT *
FROM layoffs_work_dup
WHERE industry is null
OR industry = '';

SELECT*
FROM layoffs_work_dup
WHERE company = 'Airbnb';

UPDATE layoffs_work_dup
SET industry ='Travel'
WHERE company = 'Airbnb';

UPDATE layoffs_work_dup
SET industry = NULL
WHERE industry  ='';

SELECT p1.industry,p2.industry
FROM layoffs_work_dup p1
JOIN layoffs_work_dup p2
   ON p1.company = p2.company
WHERE (p1.industry is null)
AND (p2.industry is not null);   

UPDATE layoffs_work_dup p1
JOIN layoffs_work_dup p2
   ON p1.company = p2.company
SET p1.industry = p2.industry
WHERE p1.industry is null
AND p2.industry is not null;   

SELECT*
FROM layoffs_work_dup
WHERE company = 'Bally''s Interactive';

UPDATE layoffs_work_dup
SET industry = 'Gambling'
WHERE company = 'Bally''s Interactive';

DELETE
FROM layoffs_work_dup
WHERE total_laid_off is null
AND  percentage_laid_off is null;

ALTER TABLE layoffs_work_dup
DROP column Duplicates;

SELECT *
FROM layoffs_work_dup;