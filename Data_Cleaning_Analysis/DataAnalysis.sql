SELECT *
FROM layoffs_work_dup;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_work_dup;

SELECT*
FROM layoffs_work_dup
WHERE percentage_laid_off = 1 AND country = 'United States'
ORDER BY total_laid_off DESC;

SELECT company,SUM(total_laid_off)
FROM layoffs_work_dup
GROUP BY company
ORDER BY  2 DESC;

SELECT industry,SUM(total_laid_off)
FROM layoffs_work_dup
GROUP BY industry
ORDER BY  2 DESC;

SELECT stage,SUM(total_laid_off) AS 'Sum_Total'
FROM layoffs_work_dup
GROUP BY stage
ORDER BY 2 DESC;

SELECT YEAR(`date`) 'Year',SUM(total_laid_off) 'Sum_Total'
FROM layoffs_work_dup
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

CREATE TEMPORARY TABLE Month_total_layoff
(SELECT substring(`date`,1,7) AS `Month`,SUM(total_laid_off)
FROM layoffs_work_dup
WHERE  substring(`date`,1,7) IS NOT NULL
GROUP BY substring(`date`,1,7)
ORDER BY 1 ASC);

SELECT *
FROM Month_total_layoff
WHERE `SUM(total_laid_off)`>1500;

SELECT substring(`date`,1,7) AS 'Date',SUM(total_laid_off) AS total_laid_off
FROM layoffs_work_dup
WHERE total_laid_off is not null AND Date is not null
GROUP BY substring(`date`,1,7)
ORDER BY Date ASC;

WITH Dates_CTE AS(
SELECT substring(`date`,1,7) AS dates,SUM(total_laid_off) AS total_laid_off
FROM layoffs_work_dup
WHERE total_laid_off is not null AND Date is not null
GROUP BY substring(`date`,1,7)
ORDER BY dates ASC
)
SELECT dates,total_laid_off 'Monhtly_layy_off',SUM(total_laid_off) OVER(ORDER BY dates ASC) AS Total_Layy_off
FROM Dates_CTE
ORDER BY dates ASC;

WITH Company_Years AS
(
SELECT company,YEAR(date) 'Years',SUM(total_laid_off) 'total_layy_off'
FROM layoffs_work_dup
GROUP BY company,YEAR(date)
),
Company_Years_Ranking AS
(
SELECT company,Years,total_layy_off,DENSE_RANK() OVER(PARTITION BY Years
													ORDER BY total_layy_off DESC) AS Ranking
FROM Company_Years                                                    
)
SELECT company,Years,total_layy_off,Ranking
FROM Company_Years_Ranking
WHERE Ranking<=3
AND Years IS NOT NULL
ORDER BY Years ASC,total_layy_off DESC;

WITH CTE_Max_Comp AS(
SELECT company,MAX(total_laid_off) AS max_laid_off
FROM layoffs_work_dup
GROUP BY company
)
SELECT company,max_laid_off
FROM CTE_Max_Comp
ORDER BY max_laid_off DESC
LIMIT 5;

WITH CTE_total_laid AS(
SELECT company,MAX(total_laid_off)
FROM layoffs_work_dup
GROUP BY company
)
SELECT company,`MAX(total_laid_off)`
FROM CTE_total_laid
WHERE `MAX(total_laid_off)` is not null
ORDER BY `MAX(total_laid_off)` ASC;

WITH CTE_Max_Loc AS(
SELECT location,MAX(total_laid_off) AS max_laid_off
FROM layoffs_work_dup
GROUP BY location
)
SELECT location,max_laid_off
FROM CTE_Max_Loc
ORDER BY max_laid_off DESC
LIMIT 5;

SELECT company, total_laid_off
FROM layoffs_work_dup
ORDER BY 2 DESC
LIMIT 5;

SELECT location,SUM(total_laid_off) 'total_layy_off'
FROM layoffs_work_dup
GROUP BY location
HAVING SUM(total_laid_off) IS NOT NULL
ORDER BY total_layy_off;

SELECT AVG(total_laid_off)
FROM layoffs_work_dup
GROUP BY location
HAVING location = 'SF Bay Area';


SELECT 
    location,
    AVG(total_laid_off) AS average_laid_off_rate
FROM layoffs_work_dup
WHERE location = 'SF Bay Area'
GROUP BY location;

SELECT  industry,ROUND(SUM(percentage_laid_off)) AS Total_Percentage
FROM layoffs_work_dup
GROUP BY industry
ORDER BY SUM(percentage_laid_off) DESC;

SELECT stage,SUM(funds_raised_millions)
FROM layoffs_work_dup
GROUP BY stage
HAVING SUM(funds_raised_millions) IS NOT NULL AND stage IS NOT NULL
ORDER BY SUM(funds_raised_millions) DESC;

SELECT*
FROM layoffs_work_dup
WHERE stage = 'Post-IPO' AND funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC;

SELECT company,SUM(funds_raised_millions),SUM(total_laid_off)
FROM layoffs_work_dup
GROUP BY company
HAVING SUM(funds_raised_millions) IS NOT NULL AND company IS NOT NULL
ORDER BY SUM(funds_raised_millions) DESC;

SELECT country,SUM(total_laid_off)
FROM layoffs_work_dup
GROUP BY country 
ORDER BY SUM(total_laid_off) DESC
LIMIT 5;

