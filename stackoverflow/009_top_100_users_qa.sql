/*
Question: Looking at the top 100 users by reputation, what are some of their question and answer statistics?

There is some variation amongst the top users 100 users (through November 2022), including some users that didn't post any questions.

The user who posted the most questions is only ranked 70th by overall reputation. 

The user who posted the most answers (more than double all other users in the top 100) didn't post any questions, and was ranked 2nd overall.
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
  GROUP BY ALL
  QUALIFY
    id_rank <= 100),
  questions AS (
  SELECT
    owner_user_id,
    COUNT(DISTINCT(id)) AS user_questions,
    SUM(IFNULL(score,0)) AS user_questions_score,
    SUM(IFNULL(view_count,0)) AS user_questions_views,
    SUM(IFNULL(answer_count,0)) AS user_questions_answers,
    SUM(IFNULL(comment_count,0)) AS user_questions_comment_count,
    SUM(IFNULL(favorite_count,0)) AS user_questions_favorite_count,
    COUNT(DISTINCT(accepted_answer_id)) AS users_questions_accepted_answer,
    MIN((EXTRACT(year
        FROM
          creation_date))) AS min_year_questions,
    MAX((EXTRACT(year
        FROM
          creation_date))) AS max_year_questions,
    COUNT(DISTINCT(EXTRACT(year
        FROM
          creation_date))) AS active_years_questions,
    COUNT(DISTINCT(DATE(creation_date))) AS active_days_questions
  FROM
    `bigquery-public-data.stackoverflow.posts_questions`
  WHERE
    owner_user_id in (
    SELECT
      DISTINCT id AS owner_user_id
    FROM
      top_users)
  GROUP BY
    ALL ),
  answers AS (
  SELECT
    owner_user_id,
    COUNT(DISTINCT(id)) AS user_answers,
    SUM(IFNULL(score,0)) AS user_answers_score,
    SUM(IFNULL(comment_count,0)) AS user_answers_comment_count,
    MIN((EXTRACT(year
        FROM
          creation_date))) AS min_year_answers,
    MAX((EXTRACT(year
        FROM
          creation_date))) AS max_year_answers,
    COUNT(DISTINCT(EXTRACT(year
        FROM
          creation_date))) AS active_years_answers,
    COUNT(DISTINCT(DATE(creation_date))) AS active_days_answers
  FROM
    `bigquery-public-data.stackoverflow.posts_answers`
  WHERE
    owner_user_id in (
    SELECT
      DISTINCT id AS owner_user_id
    FROM
      top_users)
  GROUP BY
    ALL )
SELECT
  top.id,
  top.display_name,
  reputation,
  id_rank,
  IFNULL(user_questions,0) AS user_questions,
  IFNULL(user_questions_score,0) AS user_questions_score,
  IFNULL(user_questions_views,0) AS user_questions_views,
  IFNULL(user_questions_answers,0) AS user_questions_answers,
  IFNULL(user_questions_comment_count,0) AS user_questions_comment_count,
  IFNULL(user_questions_favorite_count,0) AS user_questions_favorite_count,
  IFNULL(user_questions_favorite_count,0) AS user_questions_favorite_count,
  IFNULL(users_questions_accepted_answer,0) AS users_questions_accepted_answer,
  IFNULL(user_answers,0) AS user_answers,
  IFNULL(user_answers_score,0) AS user_answers_score,
  IFNULL(user_answers_comment_count,0) AS user_answers_comment_count,
  LEAST(min_year_answers, ifnull(min_year_questions,9999)) AS earliest_year_active,
  GREATEST(max_year_answers,ifnull(max_year_questions,0)) AS latest_year_active,
  IFNULL(active_years_questions, 0) AS active_years_questions,
  IFNULL(active_years_answers, 0) AS active_years_answers,
  IFNULL(active_days_questions, 0) AS active_days_questions,
  IFNULL(active_days_answers, 0) AS active_days_answers,
FROM
  top_users top
LEFT JOIN
  questions q
ON
  top.id = q.owner_user_id
LEFT JOIN
  answers a
ON
  top.id = a.owner_user_id
