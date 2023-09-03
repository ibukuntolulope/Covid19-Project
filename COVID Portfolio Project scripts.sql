SELECT * 
FROM PortfolioProject.coviddeaths
Where continent is not null
ORDER BY 3,4;

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.coviddeaths
where location like '%states%'
Order by 1,2;


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

;Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulation
FROM PortfolioProject.coviddeaths
#where location like '%states%'
Order by 1,2;


-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Group by location, Population
Order by PercentPopulationInfected desc;

-- Showing the Countries with the Highest Death Count per Population

Select location, Max(Cast(total_deaths as unsigned)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount desc;


-- Breaking Analysis Down by Continent

Select Continent, Max(Cast(total_deaths as unsigned)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is not null
Group by Continent
Order by TotalDeathCount desc;


-- Where Continent is null

Select Continent, Max(Cast(total_deaths as unsigned)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is null
Group by Continent
Order by TotalDeathCount desc;


-- Showing Continent with the highest death count per population

Select Location, Max(Cast(total_deaths as unsigned)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is null
Group by Location
Order by TotalDeathCount desc;


-- Global Numbrers

Select date, Sum(new_cases) as total_cases, Sum(Cast(new_deaths as unsigned)) as total_deaths, Sum(Cast(new_deaths as unsigned))/Sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is not null
Group by date
Order by 1,2;


-- Global Numbers without Date 

Select Sum(new_cases) as total_cases, Sum(Cast(new_deaths as unsigned)) as total_deaths, Sum(Cast(new_deaths as unsigned))/Sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is not null
-- Group by date
Order by 1,2;

-- Romoves Unsigned
Select Sum(new_cases) as total_cases, Sum(new_deaths) as total_deaths, Sum(new_deaths)/Sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject.coviddeaths
-- where location like '%states%'
Where continent is not null
-- Group by date
Order by 1,2;


-- Call the CovidVaccinations Table

SELECT * 
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date;


-- Looking at Total Population vs Vaccinations

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date
Where d.continent is not null
Order by 2,3;


-- Using the Windows Functions
-- Partition by: Calculations starts all over when it gets to a new country in the course of the analysis
-- RollingPeopleVaccinated= Cummulative of people already vaccinated

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date
Where d.continent is not null
Order by 2,3;


-- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated) 
AS
-- CTE Above
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date
Where d.continent is not null
-- Order by 2,3
)
Select *
From PopvsVac;


-- Further Calculations
 
WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated) 
AS
-- CTE Above
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date
Where d.continent is not null
-- Order by 2,3
)
Select *,  (RollingPeopleVaccinated/population)*100
From PopvsVac;


/*-- TEMP TABLE

Create Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO PercentPopulationVaccinated

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date
Where d.continent is not null
-- Order by 2,3

Select *,  (RollingPeopleVaccinated/population)*100
From PercentPopulationVaccinated;*/


CREATE TABLE PercentPopulationVaccinated
(
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- INSERT DATA INTO TEMP TABLE
INSERT INTO PercentPopulationVaccinated
SELECT
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
    FROM
    PortfolioProject.coviddeaths AS d
JOIN
    PortfolioProject.covidvaccinations AS v
ON
    d.location = v.location
    AND d.date = v.date
WHERE
    d.continent IS NOT NULL
ORDER BY
    d.location,
    d.date;

-- CALCULATE PERCENTAGE OF POPULATION VACCINATED
-- UPDATE PercentPopulationVaccinated
-- SET RollingPeopleVaccinated = RollingPeopleVaccinated / Population * 100;

-- SELECT DATA FROM TEMP TABLE
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;


-- Further Analysis

Drop table if exists PercentPopulationVaccinated;

CREATE TABLE PercentPopulationVaccinated
(
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- INSERT DATA INTO TEMP TABLE
INSERT INTO PercentPopulationVaccinated
SELECT
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
    FROM
    PortfolioProject.coviddeaths AS d
JOIN
    PortfolioProject.covidvaccinations AS v
ON
    d.location = v.location
    AND d.date = v.date
-- WHERE
   --  d.continent IS NOT NULL
ORDER BY
    d.location,
    d.date;

-- CALCULATE PERCENTAGE OF POPULATION VACCINATED
-- UPDATE PercentPopulationVaccinated
-- SET RollingPeopleVaccinated = RollingPeopleVaccinated / Population * 100;

-- SELECT DATA FROM TEMP TABLE
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;


-- CREATING VIEW TO STORE DATA FORN LATER VISUALIZATIONS

Create View PercentPopulationVaccinated as
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) Over (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From PortfolioProject.coviddeaths as d
Join PortfolioProject.covidvaccinations as v
     On d.location = v.location
     and d.date = v.date
Where d.continent is not null;
-- Order by 2,3


-- From View Table

Select *
From PercentPopulationVaccinated


