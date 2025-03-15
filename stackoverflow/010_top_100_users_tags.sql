/*
Question: What tags did each of the top 100 users use?

User 31671 (alex) used the php tag in 203 questions - the top overall.

On average, the top 100 users by overall reputation used 86 different tags (excluding the 7 users who didn't post any questions from the average).
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
    SPLIT(tags,"|") AS tags,
    EXTRACT(year
    FROM
      creation_date) AS created_year,
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
  FROM
    `bigquery-public-data.stackoverflow.posts_questions`
  WHERE
    owner_user_id IN (
    SELECT
      DISTINCT id AS owner_user_id
    FROM
      top_users)
  GROUP BY
    ALL )
SELECT
  q.owner_user_id,
  tag,
  COUNT(DISTINCT(created_year)) AS tags_years,
  SUM(q.user_questions) AS user_questions,
  SUM(q.user_questions_score) AS user_questions_score,
  SUM(q.user_questions_views) AS user_questions_views,
  SUM(q.user_questions_answers) AS user_questions_answers,
  SUM(q.user_questions_comment_count) AS user_questions_comment_count,
  SUM(q.user_questions_favorite_count) AS user_questions_favorite_count,
  SUM(q.users_questions_accepted_answer) AS users_questions_accepted_answer,
  MIN(min_year_questions) AS min_year_questions,
  MAX(max_year_questions) AS max_year_questions
FROM
  questions q
CROSS JOIN
  UNNEST(q.tags) AS tag
GROUP BY
  ALL
