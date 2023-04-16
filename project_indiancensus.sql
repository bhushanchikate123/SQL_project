select*from project. dbo.data1;


select*from project. dbo.data2;

-- number of rows into our dataset
select count(*) from project..data1
 select count(*) from project..data2


 -- dataset for jharkhand and bihar 

 select *from project..data1 where state in ('jharkhand','bihar')


 --population of india 
 select sum (population) as population from project..data2


 -- average growth
 select state , avg(growth)*100 avg_growth from project..data1 group by state;


 -- avg sex ratio 
 select state , round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by state order by avg_sex_ratio desc;


 -- avg literacy rate
  select state , round(avg(literacy),0) avg_literacy_ratio from project..data1 group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc;


  -- top 3 state showing highest growth ratio 
   select top 3 state , avg(growth)*100 avg_growth from project..data1 group by state order by avg_growth desc;



 -- bottom 3 state showing lowest sex ratio 
 select top 3 state , round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by state order by avg_sex_ratio asc;


 -- top and bottom 3 states in literacy state

 
 drop table if exists #topstates;
 create table #topstates

( state nvarchar(255),
 topstates float
 )

 insert into #topstates
 select state ,round(avg(literacy),0) avg_literacy_ratio from project..data1 group by state order by avg_literacy_ratio desc;

 select top 3 * from #topstates order by #topstates. topstates desc;





 drop table if exists #bottomstates;
 create table #bottomstates

( state nvarchar(255),
 bottomstates float
 )

 insert into #bottomstates
 select state ,round(avg(literacy),0) avg_literacy_ratio from project..data1 group by state order by avg_literacy_ratio desc;
 select top 3 * from #topstates order by #topstates. topstates desc;
 select top 3 * from #bottomstates order by #bottomstates. bottomstates asc;


 --union operator 
 select*from(
  select top 3 * from #topstates order by #topstates. topstates desc) a

  union

  select*from(
   select top 3 * from #bottomstates order by #bottomstates. bottomstates asc)b;


   --state starting with letter a

   select distinct state from project..data1 where lower( state) like 'a%' or lower(state) like 'b%'


 select distinct state from project..data1 where lower( state) like 'a%' and lower(state) like '%m'






