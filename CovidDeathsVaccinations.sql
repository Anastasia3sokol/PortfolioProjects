SELECT * FROM AlexProject..CovidDeaths
order by 3,4;

SELECT * FROM CovidVacinations
order by 3,4;

--Select Data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM AlexProject..CovidDeaths
order by 1,2;

--Looking at Total Cases vs Total Deaths
--Likeligood of dying if you get covid in you country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
FROM CovidDeaths
Where location like '%states%'
order by 1,2;

--Likeligood at total Cases vs Population
SELECT Location, date, Population, total_cases, (total_cases/population)* 100 as PercentPopulationInfected
FROM CovidDeaths
Where location like '%states%'
order by 1,2;

--Looking at Countries with Highest Ingection Rate compared to Population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))* 100 as PercentPopulationInfected
FROM CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;

--Showing Countries with Highest Death Count per Population
SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
WHERE continent is not null
Group by Location
order by TotalDeathCount desc;


--LET'S BREAK THINGS DOWN BY CONTINENT

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
WHERE continent is not null
Group by location
order by TotalDeathCount desc;

--GLOBAL NUMBERS 

SELECT 
	--date, 
	SUM(new_cases) as total_cases, 
	SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM CovidDeaths
--Where location like '%states%'
WHERE continent is not null
--Group by date
order by 1,2;
 
-- Vaccinations
-- Looking at Total Population vs Vaccinations
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated --SUM(CONVERT(int, vac.new_vaccinations))
From CovidDeaths dea
Join CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3;

Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated,
	(RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3;


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--	(RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--	(RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3;

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated;

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--	(RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

-- Make some more views!!