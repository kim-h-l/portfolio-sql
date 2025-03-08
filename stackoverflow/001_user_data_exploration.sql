/*
I like to get a good understanding of the data I'm working with by first looking at one example and expanding from there. 

I went to stackoverflow.com and found the top user overall: https://stackoverflow.com/users/22656/jon-skeet
*/

SELECT
  id,
  display_name,
  DATE(creation_date) AS creation_date,
  DATE_DIFF(CURRENT_DATE(), DATE(creation_date), YEAR) AS years_since_creation,
  reputation,
  up_votes,
  down_votes,
  views
FROM
  `bigquery-public-data.stackoverflow.users`
WHERE
  id = 22656;
