SET @myGenre = "Pop";
SET @myYear = 2017;

SELECT DISTINCT
  PGen.`performer_name` AS `performer_name`,
  PGen.`performer_id` AS `performer_id`,
  CASE 
    WHEN PInf.`performer` IS NOT NULL THEN 'Yes'
    ELSE 'No'
  END AS `participated_this_year`
FROM `performers_genres` PGen
LEFT JOIN `performances` PInf
ON PGen.`performer_id` = PInf.`performer`
AND YEAR(PInf.`date_time`) = @myYear
WHERE PGen.`genre_name` = @myGenre;
