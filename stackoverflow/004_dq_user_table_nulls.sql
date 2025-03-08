/*
I then do some basic data quality checks to make sure I'm not making any poor assumptions.
This also allows me to ensure I'm not duplicating the grain or expecting fields to have a value when they're null.

Check: What columns in the user table have null values?

Result: Only fields that are optional for a user come back with null values
- about me
- age
- location
- profile image URL
- website URL
*/

SELECT
  COUNT(1) AS total_records,
  SUM(
  IF
    (id IS NULL,1,0)) AS null_id,
  SUM(
  IF
    (display_name IS NULL,1,0)) AS null_display_name,
  SUM(
  IF
    (about_me IS NULL,1,0)) AS null_about_me,
  SUM(
  IF
    (age IS NULL,1,0)) AS null_age,
  SUM(
  IF
    (creation_date IS NULL,1,0)) AS null_creation_date,
  SUM(
  IF
    (last_access_date IS NULL,1,0)) AS null_last_access_date,
  SUM(
  IF
    (location IS NULL,1,0)) AS null_location,
  SUM(
  IF
    (reputation IS NULL,1,0)) AS null_reputation,
  SUM(
  IF
    (up_votes IS NULL,1,0)) AS null_up_votes,
  SUM(
  IF
    (down_votes IS NULL,1,0)) AS null_down_votes,
  SUM(
  IF
    (views IS NULL,1,0)) AS null_views,
  SUM(
  IF
    (profile_image_url IS NULL,1,0)) AS null_profile_image_url,
  SUM(
  IF
    (website_url IS NULL,1,0)) AS null_website_url
FROM
  `bigquery-public-data.stackoverflow.users`;
