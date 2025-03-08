/*
I then start doing some exploratory data analysis (EDA) to get a good understanding of the data.

Question: What creation years have the highest reputation per user?

Answer: As expected, the further back in time you go, the higher the reputation. 
When normalizing by the number of users created per year, it's in order by year, 
with 2008 having the highest reputation per user and 2022 having the lowest.
*/


SELECT
  EXTRACT(year
  FROM
    creation_date) AS creation_year,
  ROUND(SAFE_DIVIDE(SUM(reputation), COUNT(DISTINCT(id))),2) AS reputation_per_user
FROM
  `bigquery-public-data.stackoverflow.users`
GROUP BY
  ALL
ORDER BY
  reputation_per_user desc;
