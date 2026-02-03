SELECT perf.`performer_id`, perf.`name`
FROM `performances` per
JOIN `performers` perf ON per.`performer` = perf.`performer_id`
JOIN `events` eve ON per.`event` = eve.`event_id`
JOIN `festivals` f ON eve.`festival` = f.`festival_id`
JOIN `locations` loc ON f.`location` = loc.`location_id`
GROUP BY perf.`performer_id`, perf.`name`
HAVING COUNT(DISTINCT loc.`continent`) > 2;
