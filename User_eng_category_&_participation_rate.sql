/*User Engagement Category and Participation Rate 
This categorizes users based on their activity levels in the platform by calculating the participation rate considering their total post, comments and views.*/



WITH UserEngagement AS (
  SELECT
    u.id AS user_id,
    u.display_name AS user_display_name,
    COALESCE(total_posts, 0) AS total_posts,
    COALESCE(total_views, 0) AS total_views,
    COALESCE(total_comments, 0) AS total_comments,
    COALESCE(total_comments_made, 0) AS total_comments_made
  FROM
    `bigquery-public-data.stackoverflow.users` u
  LEFT JOIN (
    SELECT
      owner_user_id,
      COUNT(id) AS total_posts,
      SUM(view_count) AS total_views
    FROM
      `bigquery-public-data.stackoverflow.posts_questions`
    GROUP BY
      owner_user_id
  ) p ON u.id = p.owner_user_id
  LEFT JOIN (
    SELECT
      user_id,
      COUNT(id) AS total_comments_made
    FROM
      `bigquery-public-data.stackoverflow.comments`
    GROUP BY
      user_id
  ) c_user ON u.id = c_user.user_id
  LEFT JOIN (
    SELECT
      user_id,
      COUNT(id) AS total_comments
    FROM
      `bigquery-public-data.stackoverflow.comments`
    GROUP BY
      user_id
  ) c ON u.id = c.user_id
)

SELECT
  user_id,
  user_display_name,
  total_posts,
  total_views,
  total_comments,
  total_comments_made,
  CASE
    WHEN total_posts > 100 AND total_comments_made * 100.0 / total_posts >= 80 THEN 'Active Contributor'
    WHEN total_posts > 100 AND total_comments_made * 100.0 / total_posts >= 50 THEN 'Occasional User'
    ELSE 'Lurker'
  END AS engagement_category
FROM
  UserEngagement
ORDER BY
  total_views DESC
LIMIT 20;


//Elapsed time = 4 sec; Slot time consumed = 5 min 13 sec , Bytes = 2.36GB