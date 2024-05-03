/* HALL OF FAME OPTIMIZATION 
Reducing the number of rows processed: Instead of joining the entire comments table with the users table, we limit the number of distinct user IDs retrieved from the comments table to 10 using a subquery with LIMIT 10. This significantly reduces the number of rows processed during the join operation.*/


SELECT
    c.user_id,
    u.display_name,
    (COALESCE(u.up_votes, 0) - COALESCE(u.down_votes, 0)) AS reputation,
    CASE
        WHEN (COALESCE(u.up_votes, 0) - COALESCE(u.down_votes, 0)) >= 100000 THEN '★★★★★'
        WHEN (COALESCE(u.up_votes, 0) - COALESCE(u.down_votes, 0)) >= 60000 THEN '★★★★'
        WHEN (COALESCE(u.up_votes, 0) - COALESCE(u.down_votes, 0)) >= 50000 THEN '★★★'
        WHEN (COALESCE(u.up_votes, 0) - COALESCE(u.down_votes, 0)) >= 30000 THEN '★★'
        ELSE '★'
    END AS star_rating
FROM
    `bigquery-public-data.stackoverflow.users` u
JOIN (
    SELECT
        DISTINCT user_id
    FROM
        `bigquery-public-data.stackoverflow.comments`
    LIMIT
        10
) c
ON
    u.id = c.user_id
ORDER BY
    reputation DESC;


// slot time consumed = 1 min 7 sec 