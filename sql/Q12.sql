SELECT
  e.`festival` AS `festival_id`,
  DATE(e.`date_time`) AS `festival_day`,
  sr.`role` AS `staff_role`,
  CASE
    WHEN sr.`id` = 1 THEN SUM(CEIL(v.`capacity` * 0.03))
    WHEN sr.`id` = 2 THEN SUM(CEIL(v.`capacity` * 0.05))
    WHEN sr.`id` = 3 THEN SUM(CEIL(v.`capacity` * 0.02))
    ELSE 0
  END AS `staff_count`
FROM `events` e
JOIN `venues` v ON e.`venue` = v.`venue_id`
JOIN `staff_roles` sr
GROUP BY
  e.`festival`,
  DATE(e.`date_time`),
  sr.`role`
ORDER BY
  `festival_id`,
  `festival_day`,
  `staff_role`;
