
/* RECOMMENDATIONS TABLE 
This feature is in responsible for giving users information about their Stack Overflow activity, such as their most popular tags, commonly asked questions, and recommendations that are personalized for them based on their behavior



WITH UserActivity AS (
  SELECT
    u.id AS user_id,
    u.display_name AS user_display_name,
    STRING_AGG(DISTINCT p.tags, ', ') AS top_tags,
    STRING_AGG(DISTINCT p.title, ', ') AS frequently_answered_topics
  FROM
    `bigquery-public-data.stackoverflow.users` u
  LEFT JOIN
    `bigquery-public-data.stackoverflow.posts_questions` p
  ON
    u.id = p.owner_user_id
  GROUP BY
    u.id, u.display_name
),
Suggestions AS (
  SELECT
    u.id AS user_id,
    STRING_AGG(DISTINCT p.title, ', ') AS suggested_questions
  FROM
    `bigquery-public-data.stackoverflow.users` u
  LEFT JOIN
    `bigquery-public-data.stackoverflow.posts_questions` p
  ON
    u.id = p.owner_user_id
  WHERE
    p.tags LIKE CONCAT('%', (SELECT top_tags FROM UserActivity WHERE user_id = u.id), '%')
  GROUP BY
    u.id
)
SELECT
  ua.user_id,
  ua.user_display_name,
  ua.top_tags,
  ua.frequently_answered_topics,
  COALESCE(s.suggested_questions, 'No suggestions available') AS suggested_questions
FROM
  UserActivity ua
LEFT JOIN
  Suggestions s
ON
  ua.user_id = s.user_id;



// Elapsed time = 23 sec; Slot time consumed = 2min 57sec, Bytes = 400.85MB