/*
I then do some basic data quality checks to make sure I'm not making any poor assumptions.
This also allows me to ensure I'm not duplicating the grain or expecting fields to have a value when they're null.

Check: Can reputation ever be null?

Result: The result is 0, which means the reputation is never null in the user table
*/

SELECT
  COUNT(1)
FROM
  `bigquery-public-data.stackoverflow.users`
WHERE
  reputation IS NULL;
