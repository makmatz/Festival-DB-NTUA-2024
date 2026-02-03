SELECT 
  LEAST(ps1.`genre_name`, ps2.`genre_name`) AS `genre1`,
  GREATEST(ps1.`genre_name`, ps2.`genre_name`) AS `genre2`,
  COUNT(DISTINCT per.`performer_id`) AS `pair_count`
FROM `performers` per
JOIN `performers_genres` ps1
  ON per.`performer_id` = ps1.`performer_id`
JOIN `performers_genres` ps2
  ON per.`performer_id` = ps2.`performer_id`
WHERE ps1.`genre_name` < ps2.`genre_name`
GROUP BY genre1, genre2
ORDER BY `pair_count` DESC
LIMIT 3;
