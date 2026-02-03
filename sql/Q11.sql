WITH `participation_counts` AS (
  SELECT
    `performer`,
    COUNT(DISTINCT eve.`festival`) AS `participation_count`
  FROM `performances` p
  JOIN `events` eve 
  ON eve.`event_id` = p.`event`
  GROUP BY `performer`
),
`max_participation` AS (
  SELECT MAX(`participation_count`) AS `max_count`
  FROM `participation_counts`
)
SELECT
  per.`performer_id`,
  per.`name`,
  pc.`participation_count`
FROM `participation_counts` pc
JOIN `performers` per ON per.`performer_id` = pc.`performer`
JOIN `max_participation` mp ON 1 = 1
WHERE pc.`participation_count` <= mp.`max_count` - 5;
