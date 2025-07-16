--Q1(No null values and Only for year 2023
SELECT 
    TO_DATE(date, 'DD/MM/YY') AS date_formatted, 
    location, 
    total_cases, 
    total_deaths, 
    (CAST(total_deaths AS DOUBLE PRECISION) / CAST(total_cases AS DOUBLE PRECISION) * 100) AS death_percentage 
FROM 
    covid_deaths 
WHERE 
    location LIKE '%India%' 
    AND TO_DATE(date, 'DD/MM/YY') BETWEEN TO_DATE('01/01/2023', 'DD/MM/YY') AND TO_DATE('31/12/2023', 'DD/MM/YY')
    AND total_deaths IS NOT NULL
ORDER BY 
    date_formatted ASC;
--maximum cases
SELECT
	date_trunc('month', to_date(date, 'dd/mm/yy')) as month_year,
	max(total_cases) as max_cases,
	max(total_deaths) as max_deaths
From
covid_deaths
where
	location like '%India%'
	AND TO_DATE(date, 'DD/MM/YY') BETWEEN TO_DATE('01/01/2022', 'DD/MM/YY') AND TO_DATE('31/12/2023', 'DD/MM/YY')
    AND total_cases IS NOT NULL
    AND total_deaths IS NOT NULL
GROUP BY 
    month_year
ORDER BY 
    month_year ASC;
--monthwise year wise max
WITH monthly_aggregates AS (
    SELECT 
        DATE_TRUNC('month', TO_DATE(date, 'DD/MM/YY')) AS month_year,
        EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) AS year,
        MAX(total_cases) AS max_cases,
        MAX(total_deaths) AS max_deaths
    FROM 
        covid_deaths
    WHERE 
        location LIKE '%India%'
        AND TO_DATE(date, 'DD/MM/YY') BETWEEN TO_DATE('01/01/2020', 'DD/MM/YY') AND TO_DATE('31/12/2023', 'DD/MM/YY')
        AND total_cases IS NOT NULL
        AND total_deaths IS NOT NULL
    GROUP BY 
        month_year, year
)
SELECT 
    year,
    TO_CHAR(month_year, 'Month YYYY') AS month,
    max_cases,
    max_deaths
FROM 
    monthly_aggregates
WHERE 
    max_cases = (SELECT MAX(max_cases) FROM monthly_aggregates)
    OR max_deaths = (SELECT MAX(max_deaths) FROM monthly_aggregates)
ORDER BY 
    year, month_year;
--hence may 2023 showed maximum cases and maximum deaths)

--Q2Total % of deaths out of entire population- in India
select 
	location, 
	max(total_deaths)/avg(cast(population as bigint)*100) as percentage 
from covid_deaths   
group by location 
order by location asc;

--Max of deathPercentage
WITH death_percentage AS (
    SELECT 
        location,
        (MAX(total_deaths) / AVG(CAST(population AS DOUBLE PRECISION)) * 100) AS death_percentage
    FROM 
        covid_deaths
    WHERE 
        total_deaths IS NOT NULL
        AND population IS NOT NULL
    GROUP BY 
        location
)
SELECT 
    location,
    death_percentage
FROM 
    death_percentage
ORDER BY 
    death_percentage DESC
LIMIT 1;
--In India % of death
select 
	location, 
	max(total_deaths)/avg(cast(population as bigint)*100) as percentage 
from covid_deaths
where location like '%India%'
group by location 
order by location asc;

--Q3Country with highest death as a % of population
SELECT 
    location, 
    MAX(CAST(total_deaths AS DOUBLE PRECISION)) / (AVG(CAST(population AS DOUBLE PRECISION)) * 100) AS death_percentage 
FROM 
    covid_deaths
WHERE 
	total_deaths IS NOT NULL
    AND population IS NOT NULL
GROUP BY 
    location 
HAVING 
    MAX(CAST(total_deaths AS DOUBLE PRECISION)) IS NOT NULL
    AND AVG(CAST(population AS DOUBLE PRECISION)) IS NOT NULL
ORDER BY 
    death_percentage DESC;
--Q4total positive cases % india and china
select location, 
	max(total_cases)/avg(cast(population as double precision)*100) as positive_percentage 
from covid_deaths 
where 
	location like '%India%' or location like '%China%'

group by location
	order by positive_percentage desc;
--total positive cases % worldwise
select location, 
	max(total_cases)/avg(cast(population as double precision)*100) as positive_percentage 
from covid_deaths 
group by location
order by positive_percentage desc;
--Q5--continent wise
select location, 
	max(total_cases)/avg(cast(population as double precision)*100) as cases_percentage 
from covid_deaths 
where continent is null 
group by location;

--continetwise death vs cases %
SELECT 
    continent,
    MAX(total_deaths) / (AVG(CAST(population AS DOUBLE PRECISION)) * 100) AS deaths_percentage
FROM 
    covid_deaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    deaths_percentage DESC;
--continent with max case(top3)
SELECT 
    continent, 
    MAX(total_cases) / (AVG(CAST(population AS DOUBLE PRECISION)) * 100) AS cases_percentage 
FROM 
    covid_deaths 
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    cases_percentage DESC
LIMIT 3;











