/*
I then do some basic data quality checks to make sure I'm not making any poor assumptions.
This also allows me to ensure I'm not duplicating the grain or expecting fields to have a value when they're null.

Check: Are there any duplicate ids in the user table? I am assuming it's a primary key, but want to check that assumption is valid.

Result: No ids are returned, so id in the user table can be treated as a primary key because there is no duplication.
*/

SELECT
  id,
  COUNT(1) AS id_count
FROM
  `bigquery-public-data.stackoverflow.users`
GROUP BY
  ALL
HAVING
  id_count > 1;
