Select *
From CovidDeaths
where continent is not null


Select*
From CovidVaccinations

Select location, date, total_cases, new_cases, total_deaths,population
From CovidDeaths
order by 1,2

---Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid
Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where Location Like '%Rica%'
order by 1,2

--UPDATE CovidDeaths
--SET total_deaths = NULLIF(total_deaths, '0')

Select total_cases
From CovidDeaths

--Looking the Total cases vs Population
--Shows what percentage of population got covid

Select location,date,population,total_cases,(total_cases/population)*100 as CasesPercentage
From CovidDeaths
--Where Location Like '%Rica%'
order by 1,2

--UPDATE CovidDeaths
--SET total_cases = NULLIF(total_cases, '0')

--Looking at Countries with Highest Infection Rate compared to population

Select location,population,MAX (total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where Location Like '%Rica%'
Group by location, Population
order by PercentPopulationInfected desc

--UPDATE CovidDeaths
--SET population = NULLIF(population, '0')


--showing countries with highest death count per population

Select location,MAX (total_deaths) as TotalDeathCount
From CovidDeaths
--Where Location Like '%Rica%'
Group by location, Population
order by TotalDeathCount desc

--Showing countries with highest death count per population

Select location,MAX (total_deaths) as TotalDeathCount
From CovidDeaths
--Where Location Like '%Rica%'
where continent is not null
Group by location
order by TotalDeathCount desc

--Let's break things down by continent

Select continent,MAX (total_deaths) as TotalDeathCount
From CovidDeaths
--Where Location Like '%Rica%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--Showing continents with the highest death count per population

Select continent,MAX (total_deaths) as TotalDeathCount
From CovidDeaths
--Where Location Like '%Rica%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global numbers

Select date, Sum (new_cases) as total_cases, Sum (new_deaths) as total_deaths, Sum (new_deaths)/ Sum(new_cases)*100 as Percentage
From CovidDeaths
--Where Location Like '%Rica%'
where continent is not null
group by date
order by 1,2

--UPDATE CovidDeaths
--SET new_cases = NULLIF(new_cases, '0')

--UPDATE CovidDeaths
--SET new_deaths = NULLIF(new_deaths, '0')


Select  Sum (new_cases) as total_cases, Sum (new_deaths) as total_deaths, Sum (new_deaths)/ Sum(new_cases)*100 as Percentage
From CovidDeaths
--Where Location Like '%Rica%'
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select *
From CovidDeaths dea join
CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated

 --(RollingPopleVaccinated/population)*100


From CovidDeaths dea join
CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3



--Use CTE

With PopvsVac (Continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as

(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated

 --(RollingPopleVaccinated/population)*100


From CovidDeaths dea join
CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)



Insert Into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated

 --(RollingPopleVaccinated/population)*100


From CovidDeaths dea join
CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3


Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualization


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPopleVaccinated/population)*100
From CovidDeaths dea join
CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
