SELECT
  `festival`,
  AVG(`experience_sv`) AS `avg_festival_exp`
FROM `staff_venue`
GROUP BY `festival`
ORDER BY `avg_festival_exp`
LIMIT 1;
