-- Netflix project --

create table netflix
(
	show_id	varchar(5),
	type varchar(10),	
	title varchar(250),
	director varchar(550),
	casts 	 varchar(1050),
	country varchar(550),
	date_added varchar(55),
	release_year int,
	rating varchar(15),
	duration varchar(15),
	listed_in varchar(250),
	description varchar(550)
);

select* from netflix

select count(*) as total_content from netflix

select Distinct type from netflix

-- 15 Business Problems & Solutions --

1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 7 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 3 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 20 years!
14. Find the top 15 actors who have appeared in the highest number of movies produced in India.
15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

-- 1. Count the number of Movies vs TV Shows --

select
	type,
	count(*) as total_content
from netflix 
group by type

-- 2. Find the most common rating for movies and TV shows --

select
	type,
	rating
from( 
select 
	type,
	rating,
	count(*),
	rank()over(partition by type order by count(*) desc) as rank
from netflix
group by 1, 2) as t1
where rank=1

-- 3. List all movies released in a specific year (e.g., 2020) --

select*
from netflix
where release_year=2020 and type= 'Movie'

-- 4. Find the top 5 countries with the most content on Netflix --

select* from netflix

select
	unnest(string_to_array(country,',')) as new_country,
	count(show_id)
from netflix
group by 1
order by 2 desc
limit 5

5. Identify the longest movie

select* from netflix

select* from netflix
where
type = 'Movie'
and
duration = (select MAX(duration) from netflix)

-- 6. Find content added in the last 7 years --

select* from netflix

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '7 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!--

select* from netflix

select* from netflix
where director ILIKE '%Rajiv Chilaka%' 


-- 8. List all TV shows with more than 5 seasons--

select* from netflix

select* from netflix
where type= 'TV Show'
and
SPLIT_PART(duration, ' ', 1)::int>5;

-- 9. Count the number of content items in each genre--

select* from netflix

select
count(*) as total_content,
unnest(string_to_array(listed_in,',')) as genre
from netflix
group by 2

-- 10.Find each year and the average numbers of content release in India on netflix. return top 3 year with highest avg content release!--

select
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round (count(*)::numeric /(select count (*) from netflix where country = 'India')::numeric * 100, 2) as avg_release_content
from netflix
where country ilike '%India%'
group by 1
order by 3 desc
limit 3

--11. List all movies that are documentaries--

select* from netflix

select* from netflix
where
type='Movie'
and
listed_in ilike'%Documentaries%'

-- 12. Find all content without a director --

select* from netflix
where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 20 years!--

select* 
from netflix
where casts ilike '%Salman Khan%'
and
release_year>extract(year from current_date) - 20

-- 14. Find the top 15 actors who have appeared in the highest number of movies produced in India. --

select
count(*),
unnest(string_to_array(casts, ',')) as actor
from netflix
where country ilike '%India%'
and
type='Movie'
group by 2
order by 1 desc
limit 15

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category. --


select
category,
count(*)
from
	(
	select*,
	case
		when description ilike '%kill%' or description ilike '%violence%' then 'Bad_content'
		else 'Good_content'
	end category
	from netflix
	) as t1
group by 1

-- End project --


