/*
I then start doing some exploratory data analysis (EDA) to get a good understanding of the data.

Question: Who are the top 5 users per year, for the top 5 reputation years (by year of account creation).

I'm using rank because if there's a tie, I want them to have the same rank (which eliminates using row_number) 
and if there's ties, I want to minimize the amount of people I bring back (which is why I'm not using dense_rank)

I'm also using a join instead of exists for the top 5 years because I want to rank them in my output along side the individual user ranking.

Even though Jon Skeet is the top overall in terms of reputation, because his year is ranked 5th in terms of overall reputation, he is number 21 on this list.

Even though using rank allowed me to bring in ties, there are only 25 rows so there were no ties that brought in an extra user in the top 5 per year, for the top 5 years.
*/

WITH
  user_year_reputation AS (
  SELECT
    id,
    display_name,
    EXTRACT(year
    FROM
      creation_date) AS creation_year,
    reputation
  FROM
    `bigquery-public-data.stackoverflow.users`),
  top_creation_years AS (
  SELECT
    creation_year,
    SUM(reputation) AS reputation_by_creation_year,
    RANK() OVER (ORDER BY SUM(reputation) DESC) AS creation_year_rank
  FROM
    user_year_reputation
  GROUP BY
    ALL
  QUALIFY
    creation_year_rank <= 5)
SELECT
  id,
  display_name,
  creation_year,
  reputation,
  creation_year_rank,
  RANK() OVER (PARTITION BY creation_year ORDER BY reputation DESC) AS id_rank_per_year
FROM
  user_year_reputation
INNER JOIN
  top_creation_years
USING
  (creation_year)
GROUP BY
  ALL
QUALIFY
  id_rank_per_year <= 5
ORDER BY
  creation_year_rank ASC,
  id_rank_per_year asc;
