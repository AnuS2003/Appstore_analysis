create table combined_apple_store_description AS

select * from appleStore_description1
union ALL
select * from appleStore_description2
union all 
select * from appleStore_description3
union ALL
select * from appleStore_description4;

**EDA**
--check the no of unique apps in both table app store
select count(distinct c2) as UniqueAppID
from AppleStore;

select count(distinct c1) as UniqueAppIDs
from combined_apple_store_description;

--checking for missing values
select count(*) as MissingValues
from AppleStore
where c2 is null or c3 is null or c4 is null;

select Count(*) as MissingValues
from combined_apple_store_description
where c2 is null or c3 is null or c4 is null;

--Find out no of apps per genre 
select * from AppleStore;
select * from combined_apple_store_description;


select c13,Count(*) As AppsPerGenre
from AppleStore
group by c13
order by AppsPerGenre desc;


--select an overview of apps ratings
select Count(c10),max(c10 ) as max_user_rating,min(c10) as min_user_rating,avg(c10) as avg_user_rating
from AppleStore;

**Data Analysis**
--Determine whether paid apps have higher ratings from free apps

select CASE 
			when c6>0 then 'Paid'
            else 'Free'
            end as app_type,
            avg(c9) As avg_ratings
from AppleStore
group by app_type;

--check if apps with more supported languages has higher ratings or not
select CASE
			when c16<10 then '<10 languages'
            when c16 between 10 and 30 then '10-30 languages'
            else '>30 languages'
            end as app_type, avg(c9) As avg_ratings
from AppleStore
group by app_type
order by avg_ratings;

--check genre with low ratingsAppleStore
select c13,avg(c9) as avg_ratings
from AppleStore
group by c13
order by avg_ratings asc
limit 10;

--check if there is correlation between the length of the app description and user ratings
SELECT case 
			when length(b.c4)<500 then 'short'
            when length(b.c4) between 500 and 1000 then 'Medium'
            else 'Long'
            end as app_desc,avg(c9) as avg_rating
from AppleStore as a
join combined_apple_store_description as b
on a.c2=b.c1
group by app_desc
order by avg_rating;

--check top rated apps for each genre
--Window functions--
select c13,c3,c9
from (select c13,c3,c9, rank() over(partition by c13 order by c9 desc,c7 desc) as rank from AppleStore as a);
where a.rank = 1