/*
I then start doing some exploratory data analysis (EDA) to get a good understanding of the data.

Question: What creation years have the highest user reputation?

Answer: As expected, the further back in time you go, the higher the reputation. 
However, it's not in year order, there is some variation year to year.
Accounts created in 2009 have the highest reputation, and 2022 has the lowest (the end time of this data set)
*/

SELECT
  EXTRACT(year
  FROM
    creation_date) AS creation_year,
  SUM(reputation) AS reputation_by_creation_year
FROM
  `bigquery-public-data.stackoverflow.users`
GROUP BY
  ALL
ORDER BY
  reputation_by_creation_year desc;
