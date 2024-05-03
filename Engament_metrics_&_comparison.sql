/* User Engagment Metrics and Comparison table
This feature calculates the engagement metrics i.e., the platform activity for the logged-in user and compares them with the top users on Stack Overflow Hall of Fame table in the dashboard based on reputation, upvotes, downvotes, views, and badge count. Thus, this feature drives the users to be motivated to engage more and thereby inducing increased learning as one can compare themselves on various standard with the top 20 users of the platform. This also gives a strong determination for the user be listed on the hall of fame. */


USER ENGAGEMENT METRICS : WITH user_metrics AS (
    -- Query to calculate engagement metrics for the logged-in user
    SELECT
        u.id AS user_id,
        u.display_name,
        u.reputation,
        u.up_votes,
        u.down_votes,
        u.views,
        COUNT(DISTINCT b.id) AS badge_count
    FROM
        `bigquery-public-data.stackoverflow.users` u
    LEFT JOIN
        `bigquery-public-data.stackoverflow.badges` b
    ON
        u.id = b.user_id
    WHERE
        u.display_name = 'YourLoggedInUserName'
    GROUP BY
        u.id, u.display_name, u.reputation, u.up_votes, u.down_votes, u.views
),
top_users AS (
    -- Query to identify top users based on specific engagement metrics
    SELECT
        u.id AS user_id,
        u.display_name,
        u.reputation,
        u.up_votes,
        u.down_votes,
        u.views,
        COUNT(DISTINCT b.id) AS badge_count
    FROM
        `bigquery-public-data.stackoverflow.users` u
    LEFT JOIN
        `bigquery-public-data.stackoverflow.badges` b
    ON
        u.id = b.user_id
    GROUP BY
        u.id, u.display_name, u.reputation, u.up_votes, u.down_votes, u.views
    ORDER BY
        u.reputation DESC
    LIMIT
        20  -- Adjust this limit to get the top N users
)
-- Combine the results of user metrics and top users into a single table
SELECT
    'Logged-in User' AS user_type,
    user_id,
    display_name,
    reputation,
    up_votes,
    down_votes,
    views,
    badge_count
FROM
    user_metrics
UNION ALL
SELECT
    'Top User' AS user_type,
    user_id,
    display_name,
    reputation,
    up_votes,
    down_votes,
    views,
    badge_count
FROM
    top_users;

// Elapsed time = 13 sec; Slot time consumed = 12min 8 sec , Bytes = 11.12GB