WITH `event_artist` AS (
  SELECT DISTINCT
    p.`event`,
    COALESCE(ga.`artist`, p.`performer`) AS `artist`
  FROM `performances` p
  LEFT JOIN `group_artist` ga ON p.`performer` = ga.`group`
),
`young_artist_participation` AS (
  SELECT 
    ea.`artist`,
    COUNT(DISTINCT e.`festival`) AS `participations`,
    pf.`name`,
    TIMESTAMPDIFF(YEAR, pf.`birth_date`, CURRENT_DATE) AS `age`
  FROM `event_artist` ea
  JOIN `events` e ON ea.`event` = e.`event_id`
  JOIN `performers` pf ON pf.`performer_id` = ea.`artist`
  WHERE TIMESTAMPDIFF(YEAR, pf.`birth_date`, CURRENT_DATE) < 30
  GROUP BY ea.`artist`, pf.`name`, pf.`birth_date`
),
`max_participation` AS (
  SELECT MAX(`participations`) AS `max_participations`
  FROM `young_artist_participation`
)
SELECT 
  yap.`artist` AS `performer_id`,
  yap.`name`,
  yap.`age`,
  yap.`participations`
FROM `young_artist_participation` yap
JOIN `max_participation` mp ON yap.`participations` = mp.`max_participations`;
