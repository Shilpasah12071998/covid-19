  select * from PortfolioProject2..CovidDeaths
where continent is not null
order by 3,4

--select * from PortfolioProject2..CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject2..CovidDeat s
order by 1,2

--looking at total cases vs total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject2..CovidDeaths
where location like '%state%'
order by 1,2

--looking at total cases vs population
--shows what % of population got covid
select location,date,population,total_cases,(total_cases/population)*100 as DeathPercentage
from PortfolioProject2..CovidDeaths
where location like '%state%'
order by 1,2

--looking at countries with highest infection rate compared to population
select location,population,max(total_cases)as highestinfetioncount,max(total_cases/population)*100 
as percentpopulationinfected
from PortfolioProject2..CovidDeaths
--where location like '%state%'
--where continent is not null
group by location,population
order by percentpopulationinfected desc

select location,population,Date,max(total_cases)as highestinfetioncount,max(total_cases/population)*100 
as percentpopulationinfected
from PortfolioProject2..CovidDeaths
--where location like '%state%'
--where continent is not null
group by location,population,date
order by percentpopulationinfected desc

--showing countries with highest death count per population
select location,max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject2..CovidDeaths
--where location like '%state%'
where continent is not null
group by location
order by totaldeathcount desc

--We take these out as they are included in the above queries and want to stay conistent
--European union is a part of Europe
Select location,SUM(cast(new_deaths as int)) as totaldeathcount
from PortfolioProject2..CovidDeaths
--where location like '%state%'
where continent is null
and location not in ('World','European Union','international')
group by location
order by totaldeathcount desc

--Lets break things down by location
select location,max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject2..CovidDeaths
--where location like '%state%'
where continent is null
group by location
order by totaldeathcount desc

--Lets break things down by continent
select continent,max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject2..CovidDeaths
--where location like '%state%'
where continent is not null
group by continent
order by totaldeathcount desc

--Global Numbers
select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_death,
sum(cast(new_deaths as int))/sum(new_cases)*100 Deathspercentage
from PortfolioProject2..CovidDeaths
--where location like '%state%'
where continent is not null
--group by date 
order by 1,2

select * from PortfolioProject2..CovidVaccinations

--total population vs vaccinations

select dea.continent,dea.location,dea.Date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.Date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from PortfolioProject2..CovidDeaths dea
Join PortfolioProject2..CovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
order by 2,3

--Use CTE
with PopvsVac(continent,location,Date,population,New_Vaccinations,Rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.Date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.Date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from PortfolioProject2..CovidDeaths dea
Join PortfolioProject2..CovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
select *,(Rollingpeoplevaccinated/population)*100
from popvsvac

--Temp Table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_vaccination numeric,
Rollingpeoplevaccinated numeric
)
insert into #percentpopulationvaccinated 
select dea.continent,dea.location,dea.Date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.Date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from PortfolioProject2..CovidDeaths dea
Join PortfolioProject2..CovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null 
--order by 2,3
select *,(Rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated

--creating view to store data for later visualizations
create view percentpopulationvaccinated as
select dea.continent,dea.location,dea.Date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.Date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from PortfolioProject2..CovidDeaths dea
Join PortfolioProject2..CovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3









































