-- 1 . Find the ten best-selling video games in game_sales.

SELECT * FROM game_sales 
ORDER BY games_sold desc
LIMIT 10


-- 2. Determine how many games in the game_sales table are missing both a user_score and a critic_score

SELECT COUNT(*) FROM game_sales gs
LEFT JOIN reviews r 
    ON gs.game = r.game
WHERE r.critic_score IS NULL AND r.user_score IS NULL


-- 3. Find the years with the highest average critic_score

SELECT year, ROUND(SUM(critic_score)/COUNT(critic_score),2) AS avg_critic_score 
FROM game_sales gs
INNER JOIN reviews r ON gs.game = r.game 
GROUP BY year


-- 4. Find game critics' ten favorite years, this time with the stipulation that a year must have more than four games released in order to be considered.

SELECT year, count(gs.game) AS num_games, ROUND(SUM(critic_score)/COUNT(critic_score),2) AS avg_critic_score 
FROM game_sales gs
INNER JOIN reviews r on gs.game = r.game 
GROUP BY year
HAVING COUNT(gs.game) > 4
ORDER BY avg_critic_score desc
LIMIT 10


-- 5. Use set theory to find the years that were on our first critics' favorite list but not the second.

SELECT year, avg_critic_score 
FROM top_critic_years 
WHERE year NOT IN 
    (SELECT year FROM top_critic_years_more_than_four_games)
ORDER BY avg_critic_score DESC



-- 6. Update your query from Task Four so that it returns years with ten highest avg_user_score values

SELECT year, COUNT(gs.game) AS num_games, ROUND(AVG(user_score),2) AS avg_user_score 
FROM game_sales gs
INNER JOIN reviews r 
    ON gs.game = r.game 
GROUP BY year
HAVING COUNT(gs.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10

-- 7. Create a list of years that appear on both the top_critic_years_more_than_four_games table and the top_user_years_more_than_four_games table

SELECT year FROM top_critic_years_more_than_four_games
INTERSECT 
SELECT year FROM top_user_years_more_than_four_games


-- 8. Add a column showing total games_sold in each year to the table you created in the previous task

SELECT year, sum(games_sold) AS total_games_sold
FROM game_sales 
WHERE year IN 
    (SELECT year FROM top_critic_years_more_than_four_games
INTERSECT 
SELECT year 
FROM top_user_years_more_than_four_games)
GROUP BY year
ORDER BY total_games_sold DESC