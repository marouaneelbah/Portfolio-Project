/*
Queries used for Tableau Project
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [Portfolio Project]..coviddeath
--Where location like '%morocco%'
where continent is not null 
--Group By date
order by 1,2


-- or

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project]..coviddeath
--Where location like '%morocco%'
where location = 'World'
--Group By date
order by 1,2


-- 2. 


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project]..coviddeath
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..coviddeath
--Where location like '%morocco%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..coviddeath
--Where location like '%morocco%'
Group by  Location,Population, date
order by PercentPopulationInfected desc


-- 5.



Select dea.continent, dea.location, dea.date, dea.population, dea.new_cases
, SUM(cast(vac.total_vaccinations as int )) as RollingPeopleVaccinated
, ((SUM(cast(vac.total_vaccinations as int))/dea.population)*100)/2 as percentage
	From [Portfolio Project]..coviddeath dea
	Join [Portfolio Project]..covidvac vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
Where dea.location like '%morocco%'
group by dea.continent, dea.location, dea.date, dea.population, dea.new_cases
order by 1,2,3

--or

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	From [Portfolio Project]..coviddeath dea
	Join [Portfolio Project]..covidvac vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.location like '%morocco%'
--where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


--6

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..coviddeath
--Where location like '%morocco%'
where continent is not null 
order by 1,2


