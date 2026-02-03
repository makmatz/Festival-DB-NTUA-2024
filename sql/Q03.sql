SELECT DISTINCT prs.`name`
FROM `performances` pes
JOIN `events` eve 
ON pes.`event` = eve.`event_id`
JOIN `performers` prs
ON pes.`performer` = prs.`performer_id`
WHERE pes.`type` = 1
GROUP BY prs.`performer_id`, eve.`festival`
HAVING COUNT(*) > 2;