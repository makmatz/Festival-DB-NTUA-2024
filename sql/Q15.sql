SELECT
  c.`name` AS `client_name`,
  pf.`name` AS `performer_name`,
  AVG(r.`artist_performance`) AS `rating_score`,
  COUNT(*) AS `num_of_ratings`
FROM `clients` c
JOIN `ratings` r ON c.`client_id` = r.`client`
JOIN `performances` p ON r.`performance` = p.`performance_id`
JOIN `performers` pf ON p.`performer` = pf.`performer_id`
GROUP BY c.`name`, pf.`name`
ORDER BY
  `rating_score` DESC,
  `num_of_ratings` DESC,
  c.`name`
LIMIT 5;