Select * from Data1;
Select * from data2;

-- Number of rows present in our dataset

Select count(*) as Total_Rows from data1;
Select count(*) as Total_Rows from data2;

-- Dataset from Jharkhand and Bihar

Select * from data1
where state='Jharkhand' or state='Bihar';

-- Population of India

Select sum(population) as India_Population from data2;

-- Average growth of india

Select avg(growth)*100 as overall_avg_growth from data1;

-- Average growth by state

Select state,avg(growth)*100 as overall_avg_growth from data1
group by state;

-- Average sex ratio by state in desc order

Select state,round(avg(sex_ratio),0) as avg_sex_ratio from data1
group by state
order by avg_sex_ratio desc;

-- Average literacy rate

Select state,round(avg(literacy),0) as avg_literacy from data1
group by state
having round(avg(literacy),0)>90
order by avg_literacy desc;

-- Top 5 states having the highest growth ratio

Select top 5 state,avg(growth)*100 as overall_avg_growth from data1
group by state
order by overall_avg_growth desc;

-- Bottom 5 states having the lowest sex ratio

Select top 5 state,round(avg(sex_ratio),0) as avg_sex_ratio from data1
group by state
order by avg_sex_ratio ;

-- Top and bottom 3 states in terms of literacy rate

Select * from (Select top 3 state,round(avg(literacy),0) as avg_literacy from data1
group by state
order by avg_literacy desc)a
UNION
Select top 3 state,round(avg(literacy),0) as avg_literacy from data1
group by state
order by avg_literacy;

-- Records for which states are starting with the letter 'A' or 'B'

Select distinct state from data1 
where state like '[ab]%';

-- Joining both tables
-- Total males and females state wise

select c.state,sum(c.number_of_males) as Total_Males,sum(c.number_of_females) as Total_Females from(
Select district,state,round(population/(Sex_Ratio+1),0) as number_of_males,round(population-(population/(Sex_Ratio+1)),0) as number_of_females from(
Select A.district,A.state,A.sex_ratio/1000 as Sex_Ratio,B.population from data1 as A inner join data2 as B 
on A.district=B.district)p)c 
group by c.state;

-- Total Literate and illiterate population state wise

select state,sum(Literate_Population) as Total_Literate_Population, sum(Illiterate_Population) as Total_Illiterate_Population from(
select district,state,round(literacy_ratio*population,0) as Literate_Population,round((1-literacy_ratio)*population,0) as Illiterate_Population from(
Select A.district,A.state,A.literacy/100 as Literacy_Ratio,B.population from data1 as A inner join data2 as B 
on A.district=B.district)m)n
group by state;

-- Population in previous census
select state,sum(Previous_Census_Population) as Total_Previous_Census_Population,sum(Current_Census_Population) as Total_Current_Census_Population from (
Select district,state,round(population/(growth+1),0) as Previous_Census_Population,population as Current_Census_Population from(
Select A.district,A.state,A.growth,B.population from data1 as A inner join data2 as B 
on A.district=B.district)k)l
group by state;

-- Population of india in previous and current census

Select sum(Total_Previous_Census_Population) as India_Previous_Census_Population,sum(Total_Current_Census_Population) as India_Current_Census_Population from(
select state,sum(Previous_Census_Population) as Total_Previous_Census_Population,sum(Current_Census_Population) as Total_Current_Census_Population from (
Select district,state,round(population/(growth+1),0) as Previous_Census_Population,population as Current_Census_Population from(
Select A.district,A.state,A.growth,B.population from data1 as A inner join data2 as B 
on A.district=B.district)k)l
group by state)v;

-- Population vs area

Select total_area/India_Previous_Census_Population as India_Previous_Census_Population_vs_area,total_area/India_Current_Census_Population as India_Current_Census_Population_vs_area from(
Select w.*,h.total_area from (
select '1' as keyy , x.* from(
Select sum(Total_Previous_Census_Population) as India_Previous_Census_Population,sum(Total_Current_Census_Population) as India_Current_Census_Population from(
select state,sum(Previous_Census_Population) as Total_Previous_Census_Population,sum(Current_Census_Population) as Total_Current_Census_Population from (
Select district,state,round(population/(growth+1),0) as Previous_Census_Population,population as Current_Census_Population from(
Select A.district,A.state,A.growth,B.population from data1 as A inner join data2 as B 
on A.district=B.district)k)l
group by state)v)x)w
inner join 
(Select '1' as keyy,f.* from(
select sum(area_km2) as total_area from data2)f)h
on w.keyy=h.keyy)o;


-- Top 3 district from each state with highest literacy rate
select *  from(
select state,district,literacy,dense_rank() over(partition by state order by literacy desc) as lit_rank from data1)q 
where lit_rank in (1,2,3);
