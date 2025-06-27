-- Data Cleaning


-- 1. Remove Duplicates
-- 2. standardize the Data
-- 3. Null values or blank values
-- 4. Remove any columns or rows

select *
from layoffs
;


CREATE TABLE `layoffs_staging` (
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

select *
from layoffs_staging
;

commit;

Insert into layoffs_staging
select *,
Row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs;

select *
from layoffs_staging
where row_num > 1
;

delete
from layoffs_staging
where row_num > 1
;

select company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions, count(*) as count
from layoffs_staging
group by company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions
Having count(*) > 1;


-- 2. Standardizing Data

select *
from layoffs_staging
;

select distinct company
from layoffs_staging
;

-- trim 

select company, trim(company)
from layoffs_staging
;

update layoffs_staging
set company = trim(company)
;

-- grouping industries based on industry name

select distinct industry
from layoffs_staging
;

select distinct industry
from layoffs_staging
order by 1
;

select *
from layoffs_staging
where industry like 'crypto%'
;

update layoffs_staging
set industry = 'Crypto'
where industry like 'Crypto%'
;

-- now just look at the location

select *
from layoffs_staging
;

select distinct country 
from layoffs_staging
order by 1
;

select *
from layoffs_staging
where country like 'United States%'
order by 1
;

select distinct country, trim(trailing '.' from country)
from layoffs_staging
order by 1
;

update layoffs_staging
set country = trim(trailing '.' from country)
where country like 'United States%'
;

-- Time series Update date column

select *
from layoffs_staging;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging;

update layoffs_staging
set `date` = str_to_date(`date`, '%m/%d/%Y')
;

select `date`
from layoffs_staging;

alter table layoffs_staging
modify column `date` DATE;

-- 3. Null values or blank values

select *
from layoffs_staging
where total_laid_off is null
;

-- namba entha entha column lam null and blank ah irukunu search panrom using below details

select *
from layoffs_staging
where funds_raised_millions is null
or funds_raised_millions = '';

-- industry, total_laid_off, percentage_laid_off, date, stage, 



select *
from layoffs_staging
where total_laid_off is null
and percentage_laid_off is null
;

-- first we check all compnay, location, country only not null/blank in it 
-- so we try rest of all to change or modify there values


update layoffs_staging
set industry = null
where industry = '';

select *
from layoffs_staging
where industry is null
or industry = '';

-- four data are null/blank so we try to search it separately to identify there industries..

select *
from layoffs_staging
where company = "airbnb";

select * 
from layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null  or t1.industry = '')
and t2.industry is not null;


select t1.industry, t2.industry
from layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
    and t1.location = t2.location
where t1.industry is null 
and t2.industry is not null
;

update layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null
;

select *
from layoffs_staging
where company = "Bally's Interactive";

select *
from layoffs_staging
;

select *
from layoffs_staging
where total_laid_off is null
and percentage_laid_off is null
;

delete
from layoffs_staging
where total_laid_off is null
and percentage_laid_off is null
;

-- 4. Remove any columns or rows 

alter table layoffs_staging
drop column row_num
;


