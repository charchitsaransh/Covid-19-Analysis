--select * from covid_deaths;
--a.Datewise Likelihood of dying due to covid-Totalcases vs TotalDeath- in India
select date, location,total_cases,total_deaths,(cast(total_deaths as double precision)/cast(total_cases as double precision)*100) as death_percentage from covid_deaths where location like '%India%' order by death_percentage asc;
--b.Total % of deaths out of entire population- in India
select location, max(total_deaths)/avg(cast(population as bigint)*100) as percentage from covid_deaths group by location order by location desc; 
--c. Verify b
select location, date,total_deaths,population from covid_deaths where location like '%India%';
--d. Country with highest death as a % of population
select location, max(cast(total_deaths as double precision))/avg(cast(population as double precision)*100) as death_percentage from covid_deaths group by location order by death_percentage desc;
--e. Total % of covid +ve cases- in India
select location, max(total_cases)/avg(cast(population as double precision)*100) as positive_percentage from covid_deaths where location like '%India%' group by location;
--f.Total % of covid +ve cases- in world
select location, max(total_cases)/avg(cast(population as double precision)*100) as positive_percentage from covid_deaths group by location;
--g.Continentwise +ve cases
select location, max(total_cases)/avg(cast(population as double precision)*100) as cases_percentage from covid_deaths where continent is null group by location;
--h.Continentwise deaths
select location, max(total_deaths)/avg(cast(population as double precision)*100) as deaths_percentage from covid_deaths where continent is null group by location;
--i.Daily newcases vs hospitalizations vs icu_patients- India
select date, new_cases, icu_patients, hosp_patients from covid_deaths where location like '%India%' order by location desc;
--j.countrywise age>65
select location, aged_65_older from covid_vaccinations;
--k. Countrywise total vaccinated persons
select location as country,max(people_fully_vaccinated) as Fully_vaccinated from covid_vaccinations where continent is not null group by country order by country desc;
