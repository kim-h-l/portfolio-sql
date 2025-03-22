/*
Question: Looking at the top 10 users only, what were their rolling 5 year scores?

Not surprisingly, the top 10 users had the hightest rolling 5 year score mostly concentrated near the beginning of the data timeframe (data timeframe: 2008-2022)

3 of the users had their highest rolling average in 2012, 3 in 2013, 2 in 2014, and one each in 2016 and 2018. 
Suprisingly, the user that had their highest rolling average in 2018 was the only user in the top 10 that did not post any questions, they just submitted answers.
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
    SUM(user_questions_score) OVER (PARTITION BY owner_user_id ORDER BY year RANGE BETWEEN 4 PRECEDING AND 0 PRECEDING ) AS rolling_5_years_score_questions
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
    SUM(user_answers_score) OVER (PARTITION BY owner_user_id ORDER BY year RANGE BETWEEN 4 PRECEDING AND 0 PRECEDING ) AS rolling_5_years_score_answers
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
  IFNULL(user_answers,0) AS user_answers,
  IFNULL(user_answers_score,0) AS user_answers_score,
  IFNULL(rolling_5_years_score_questions,0) AS rolling_5_years_score_questions,
  IFNULL(rolling_5_years_score_answers,0) AS rolling_5_years_score_answers,
  IFNULL(rolling_5_years_score_questions,0) + IFNULL(rolling_5_years_score_answers,0) AS rolling_5_years_score_q_and_a
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
  all;
