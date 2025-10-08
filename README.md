# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/hrithick-2003/netflix_project_SQL/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select
	type,
	count(*) as total_content
from netflix 
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select*
from netflix
where release_year=2020 and type= 'Movie'```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select* from netflix

select
	unnest(string_to_array(country,',')) as new_country,
	count(show_id)
from netflix
group by 1
order by 2 desc
limit 5
```


**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select* from netflix
where
type = 'Movie'
and
duration = (select MAX(duration) from netflix)
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 7 Years

```sql
SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '7 years'
```

**Objective:** Retrieve content added to Netflix in the last 7 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select* from netflix
where director ILIKE '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.```

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select
count(*) as total_content,
unnest(string_to_array(listed_in,',')) as genre
from netflix
group by 2
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 3 year with highest avg content release!

```sql
select
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round (count(*)::numeric /(select count (*) from netflix where country = 'India')::numeric * 100, 2) as avg_release_content
from netflix
where country ilike '%India%'
group by 1
order by 3 desc
limit 3
```
**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select* from netflix
where
type='Movie'
and
listed_in ilike'%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select* from netflix
where director is null
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 20 Years

```sql
select* 
from netflix
where casts ilike '%Salman Khan%'
and
release_year>extract(year from current_date) - 20;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 20 years.

### 14. Find the Top 15 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 15 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.




## Author - Hrithick

Email ID: hrithick2309@gmail.com
Linkedin: https://www.linkedin.com/in/hrithick-a-6019b426b/

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

- **Discord**: [Join our community to learn and grow together](https://discord.gg/36h5f2Z5PK)

Thank you for your support, and I look forward to connecting with you!
