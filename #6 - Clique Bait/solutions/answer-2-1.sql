-- How many users are there?
-- Ilu jest użytkowników?

SELECT
    COUNT(DISTINCT user_id) as all_users
FROM users;