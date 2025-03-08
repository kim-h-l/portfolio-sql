/*
I then do some basic data quality checks to make sure I'm not making any poor assumptions.
This also allows me to ensure I'm not duplicating the grain or expecting fields to have a value when they're null.

Check: The range of values for reputation (to see if they can ever be negative or zero).
*/
SELECT
  MIN(reputation) AS min_reputation,
  MAX(reputation) AS max_reputation
FROM
  `bigquery-public-data.stackoverflow.users`;
