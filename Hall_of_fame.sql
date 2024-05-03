
/* HALL OF FAME 
The hall of fame table is designed to showcase top 20 users and give them a star-ratings based on their platform activity. 



SELECT
    DISTINCT c.user_id,
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
JOIN
    `bigquery-public-data.stackoverflow.comments` c
ON
    u.id = c.user_id
ORDER BY
    reputation DESC
LIMIT
    10;


// Elapsed time = 4 sec; Slot time consumed = 3 min 2 sec, Bytes = 171.11MB