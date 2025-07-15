
USE WesternFinance;
GO


#How many total records (rows) are there in the imported table?

select count(*) As Count_of_Rows from [dbo].['Main data$']

#List all the distinct countries present in the dataset.

select distinct Country from [dbo].['Main data$'];

#What is the range (min and max) of years available in the data?

select min(year) as Min_Year, max(year) as Max_Year from [dbo].['Main data$'];

#Which country had the highest GDP(Estimated) in the most recent year available?

ALTER TABLE [dbo].['Main data$']
ADD [Estimated GDP] FLOAT;

update [dbo].['Main data$']
set [Estimated GDP] = Sales+Profit

select Country, max(year) as MostRecentYear, sum([Estimated GDP]) as Total_Estimated_GDP
from [dbo].['Main data$']
where Year = 2014
group by Country
order by Total_Estimated_GDP Desc

#What is the average Profit for each country in 2014?
select Country,avg(profit) as Average_Profit 
from [dbo].['Main data$']
where Year = 2014
group by Country

#List all countries where the total Units Sold exceeded 100,000 in any single year.

select Country, Sum([Units Sold]) as Total_Units_Sold
from [dbo].['Main data$']
where YEAR = 2014
group by Country
having Sum([Units Sold])>100000

#Which countries showed an increase in total Estimated GDP from 2013 to 2014?

with GDP_Summary as (
select Country, YEAR([Date]) AS Year, max([Estimated GDP]) as Total_Estimated_GDP
from [dbo].['Main data$']
where YEAR between 2013 and 2014
group by Country,YEAR([Date])
)
select g13.Country
from GDP_Summary g13
join GDP_Summary g14 
	on g13.Country = g14.Country and g13.Year = 2013 and g14.Year = 2014
where g14.Total_Estimated_GDP>g13.Total_Estimated_GDP
	

# Which country had the highest Profit Margin in any year? 
select top 1 country,Year,
		sum(profit) as TotalProfit,
		sum(sales) as TotalSales,
	Round (sum(profit)/sum(sales),2) as ProfitMargin
from [dbo].['Main data$']
group by country,Year
order by ProfitMargin desc

#Which Segment had the highest average Profit per Unit Sold across all countries in 2014?
select top 1 segment,
		avg([Profit]/[Units Sold]) as AvgProfitPerUnits
from [dbo].['Main data$']
where year([Date]) = 2014
group by segment
order by AvgProfitPerUnits desc




