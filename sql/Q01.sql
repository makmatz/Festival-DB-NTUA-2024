SELECT 
  YEAR(f.`first_day`) AS `year`,
  SUM(cst.`cost`) AS `income`,
  SUM(CASE WHEN inf.`payment_method` = 1 THEN cst.`cost` ELSE 0 END) AS `income_debit`,
  SUM(CASE WHEN inf.`payment_method` = 2 THEN cst.`cost` ELSE 0 END) AS `income_credit`,
  SUM(CASE WHEN inf.`payment_method` = 3 THEN cst.`cost` ELSE 0 END) AS `income_wire`
FROM 
  `tickets` inf
  JOIN `events` evn 
    ON evn.`event_id` = inf.`event`
  JOIN `ticket_costs` cst 
    ON cst.`event` = inf.`event` AND cst.`category` = inf.`category`
  JOIN `festivals` f 
    ON f.`festival_id` = evn.`festival`
GROUP BY f.`festival_id`;