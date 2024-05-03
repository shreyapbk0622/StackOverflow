
/* USER ENGAGEMENT METRICS AND COMPARISON TABLE 
Removing DISTINCT: In the original query, COUNT (DISTINCT b.id) was used to count the number of badges for each user. However, using DISTINCT can be computationally expensive, especially when applied to large datasets. In the optimized query, we removed the DISTINCT keyword, and instead, we use COUNT(b.id) directly. This change assumes that there are no duplicate badge IDs for a single user, which is a reasonable assumption given that each badge should have a unique ID.*/

WITH user_metrics AS (
    SELECT
        u.id AS user_id,
        u.display_name,
        u.reputation,
        u.up_votes,
        u.down_votes,
        u.views,
        COUNT(b.id) AS badge_count
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
    SELECT
        u.id AS user_id,
        u.display_name,
        u.reputation,
        u.up_votes,
        u.down_votes,
        u.views,
        COUNT(b.id) AS badge_count
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
        20
)
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


// slot time consumed = 4 minutes 17 seconds.