WITH `performance_counts` AS (
  SELECT
    pg.`genre_name` AS `genre_name`,
    YEAR(p.`date_time`) AS year,
    COUNT(DISTINCT p.`performance_id`) AS `appearances`
  FROM `performances` p
  JOIN `performers_genres` pg
    ON p.`performer` = pg.`performer_id`
  GROUP BY pg.genre_name, YEAR(p.date_time)
  HAVING COUNT(*) >= 3
)
SELECT
  pc1.`genre_name`,
  pc1.`year` AS `year1`,
  pc2.`year` AS `year2`,
  pc1.`appearances`
FROM
  `performance_counts` pc1
JOIN
  `performance_counts` pc2
  ON pc1.`genre_name` = pc2.`genre_name`
  AND pc2.`year` = pc1.`year` + 1
  AND pc1.`appearances` = pc2.`appearances`
ORDER BY `year1`, pc1.`genre_name`;