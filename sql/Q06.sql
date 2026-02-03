SET @visitor = 5033;

SELECT 
  ev.`event_id` AS `event_id`,
  ev.`name` AS `event_name`,
  CASE
    WHEN AVG((r.`artist_performance` + r.`sound_lighting` + r.`stage_presence` + r.`organization` + r.`overall`) / 5) IS NULL
    THEN 'no rating'
    ELSE CAST(AVG((r.`artist_performance` + r.`sound_lighting` + r.`stage_presence` + r.`organization` + r.`overall`) / 5) AS CHAR)
  END AS average_rating
FROM `tickets` tk 
JOIN `events` ev
  ON tk.`event` = ev.`event_id`
JOIN `performances` pf
  ON pf.`event` = tk.`event`
LEFT JOIN ratings r
  ON tk.`client` = r.`client` AND pf.`performance_id` = r.`performance`
WHERE tk.`client` = @visitor AND tk.`is_used` = TRUE
GROUP BY ev.`event_id`;
