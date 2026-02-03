SET @myPerformer = "Billie Eilish";

SELECT
  AVG(r.`artist_performance`) AS `performance_rating`,
  AVG(r.`overall`) AS `overall_rating`
FROM `ratings` r
JOIN `performances` perfc
ON r.`performance` = perfc.`performance_id`
JOIN `performers` perfm
ON perfc.`performer` = perfm.`performer_id`
WHERE perfm.`name` = @myPerformer
