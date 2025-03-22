/*
Question: When did the top 10 users experience the largest year-over-year changes in question and answer scores?

Questions:
The top 10 users saw the most significant growth in question scores earlier in the timeframe:
2 users in 2010
1 in 2011
1 in 2012
1 in 2013
2 in 2014
1 in 2020
1 user never posted any questions
1 user did not experience year-over-year growth

The biggest declines in question scores (excluding years when no questions were posted) occurred earlier in the timeframe:
2 users in 2009
1 in 2010
2 in 2011
1 in 2013
1 in 2014
1 in 2022
1 users never posted questions
2 users nly saw declines due to inactivity the following year


Answers:
The top 10 users saw the most significant growth in answer scores earlier in the timeframe:
4 users in 2009
3 in 2010
1 in 2012
1 in 2013
Only 1 user saw their biggest growth in 2021

The largest declines in answer scores (excluding years when no answers were posted) were more spread out, occurring in:
2011, 2013, 2014, 2015, 2018, 2020, 2021, and 2022 (each with 1 user)
2016 saw the largest declines for 2 users
*/

WITH
  top_users AS (
  SELECT
    id,
    display_name,
    EXTRACT(year
    FROM
      creation_date) AS creation_year,
    reputation,
    RANK() OVER (ORDER BY reputation DESC) AS id_rank
  FROM
    `bigquery-public-data.stackoverflow.users`
  GROUP BY
    ALL
  QUALIFY
    id_rank <= 10),
  years AS (
  SELECT
    year
  FROM
    UNNEST(GENERATE_ARRAY(2008, 2022)) AS year ),
  top_users_year AS (
  SELECT
    id,
    years.year
  FROM
    top_users
  CROSS JOIN
    years ),
  questions AS (
  SELECT
    owner_user_id,
    EXTRACT(year
    FROM
      creation_date) AS year,
    COUNT(DISTINCT(id)) AS user_questions,
    SUM(IFNULL(score,0)) AS user_questions_score
  FROM
    `bigquery-public-data.stackoverflow.posts_questions`
  WHERE
    owner_user_id IN (
    SELECT
      DISTINCT id AS owner_user_id
    FROM
      top_users)
  GROUP BY
    ALL ),
  questions_gap_years AS (
  SELECT
    ay.id AS owner_user_id,
    ay.year,
    COALESCE(q.user_questions, 0) AS user_questions,
    COALESCE(q.user_questions_score, 0) AS user_questions_score
  FROM
    top_users_year ay
  LEFT JOIN
    questions q
  ON
    ay.id = q.owner_user_id
    AND ay.year = q.year ),
  questions_agg AS (
  SELECT
    owner_user_id,
    year,
    user_questions,
    user_questions_score,
    CASE
      WHEN year = 2008 THEN NULL
      WHEN LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year) = 0 THEN NULL
      WHEN SAFE_DIVIDE(user_questions_score - LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year), LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year)) >= 0 THEN FORMAT("+%.1f%%", SAFE_DIVIDE(user_questions_score - LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year), LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year)) * 100)
      ELSE FORMAT("(%.1f%%)", ABS(SAFE_DIVIDE(user_questions_score - LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year), LAG(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year)) * 100))
  END
    AS yoy_growth_questions
  FROM
    questions_gap_years
  GROUP BY
    ALL ),
  answers AS (
  SELECT
    owner_user_id,
    EXTRACT(year
    FROM
      creation_date) AS year,
    COUNT(DISTINCT(id)) AS user_answers,
    SUM(IFNULL(score,0)) AS user_answers_score,
  FROM
    `bigquery-public-data.stackoverflow.posts_answers`
  WHERE
    owner_user_id IN (
    SELECT
      DISTINCT id AS owner_user_id
    FROM
      top_users)
  GROUP BY
    ALL ),
  answers_gap_years AS (
  SELECT
    ay.id AS owner_user_id,
    ay.year,
    COALESCE(a.user_answers, 0) AS user_answers,
    COALESCE(a.user_answers_score, 0) AS user_answers_score
  FROM
    top_users_year ay
  LEFT JOIN
    answers a
  ON
    ay.id = a.owner_user_id
    AND ay.year = a.year ),
  answers_agg AS (
  SELECT
    owner_user_id,
    year,
    user_answers,
    user_answers_score,
    CASE
      WHEN year = 2008 THEN NULL
      WHEN LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year) = 0 THEN NULL
      WHEN SAFE_DIVIDE(user_answers_score - LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year), LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year)) >= 0 THEN FORMAT("+%.1f%%", SAFE_DIVIDE(user_answers_score - LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year), LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year)) * 100)
      ELSE FORMAT("(%.1f%%)", ABS(SAFE_DIVIDE(user_answers_score - LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year), LAG(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year)) * 100))
  END
    AS yoy_growth_answers
  FROM
    answers_gap_years
  GROUP BY
    ALL )
SELECT
  top.id,
  top.display_name,
  top.reputation,
  top.id_rank,
  top_year.year,
  IFNULL(user_questions,0) AS user_questions,
  IFNULL(user_questions_score,0) AS user_questions_score,
  yoy_growth_questions,
  IFNULL(user_answers,0) AS user_answers,
  IFNULL(user_answers_score,0) AS user_answers_score,
  yoy_growth_answers
FROM
  top_users_year top_year
INNER JOIN
  top_users top
USING
  (id)
LEFT JOIN
  questions_agg q
ON
  top_year.id = q.owner_user_id
  AND top_year.year = q.year
LEFT JOIN
  answers_agg a
ON
  top_year.id = a.owner_user_id
  AND top_year.year = a.year
GROUP BY
  all
