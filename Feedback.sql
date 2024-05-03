
/*FEEDBACK TABLE
This table is basically responsible for filtering out the comments which are the feedback from the users. This could be either bugs, reports or other similar feedback. This gives the stakeholders and developers of the platform a room for improvement and for the users, a satisfaction with the platform's features and content.*/



SELECT
    id AS comment_id,
    text AS feedback_text,
    creation_date AS feedback_date,
    user_id,
    user_display_name,
    CASE
        WHEN LOWER(text) LIKE '%bug%' THEN 'Bug Report'
        WHEN LOWER(text) LIKE '%suggestion%' THEN 'Feature Request'
        ELSE 'General Feedback'
    END AS feedback_type
FROM
    `bigquery-public-data.stackoverflow.comments`
WHERE
    LOWER(text) LIKE '%bug%' OR LOWER(text) LIKE '%suggestion%' OR LOWER(text) LIKE '%feedback%';


// Elapsed time = 207ms; Slot time consumed = 38ms, Bytes = 12.51KB