SET @specific_date = '2022-08-04';

SELECT s.`staff_id`, s.`name`
FROM `staff` s
LEFT JOIN (
  SELECT DISTINCT sv.`staff_member`
  FROM `staff_venue` sv
  JOIN `events` e ON sv.`venue` = e.`venue`
  WHERE DATE(e.`date_time`) = @specific_date
) worked ON worked.`staff_member` = s.`staff_id`
WHERE worked.`staff_member` IS NULL
AND s.`role` = 3;
