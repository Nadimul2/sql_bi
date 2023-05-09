select * from covid 

-- Number of Deaths per cases
select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percent_case
From Projects..covid;

-- Cases, deaths and percentage of infected in Bangladesh
select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as case_percent_pop
From Projects..covid
where location = 'Bangladesh';

--Hospital cases
select date, sum(cast(icu_patients as int)) as current_icu_cases, sum(cast(hosp_patients as int)) as current_patients
from Projects..covid
group by date
order by date

-- Total cases and percentage of population infected for each country
create view covid_location as
select location, continent, population, max(total_cases) as total_case, max((total_cases/population)*100) as case_percent_pop
From covid
group by location, population, continent

select *
from covid_location

select * from Projects..vaccines
select * from Projects..covid


-- Perform Join on covid cases and vaccinations table and create a view
create view case_vaccines as
select covid.location,covid.date, vaccines.continent ,covid.population, covid.new_cases, covid.new_deaths, covid.total_cases, covid.total_deaths,
vaccines.new_tests, vaccines.total_tests, vaccines.total_vaccinations, vaccines.new_vaccinations
from covid
inner join vaccines on
covid.location = vaccines.location
and covid.date = vaccines.date

-- Situation of a country after vaccinations started
select * from Projects..case_vaccines
where new_vaccinations is not null
and location = 'Canada'
order by location, date

use Projects
go
-- Aggregate case_vaccines view
create view agg_case_vaccines as
select location, continent, date,max(total_cases) as total_cases, max(total_deaths) as total_deaths,
max(total_tests) as total_tests, max(total_vaccinations) as total_vaccinations
from Projects..case_vaccines
WHERE total_vaccinations IS NOT NULL
group by location, continent, date

-- New cases and vaccines daily
create view daily as
select date, sum(cast(new_cases as int)) as daily_cases, sum(cast(new_deaths as int)) as daily_deaths,
sum(cast(new_vaccinations as int)) as vaccinations, sum(cast(new_tests as int)) as tests
from Projects..case_vaccines
group by date

select *
from daily
order by date

select * from agg_case_vaccines
order by location, date


