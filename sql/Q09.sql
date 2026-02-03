-- Table containing (artist - year - number_of_events_attended)
WITH `ClientAttendancesPerYearFiltered` AS (
  SELECT
    t.`client` AS `client_id`,
    YEAR(e.`date_time`) AS `event_year`,
    COUNT(t.`ticket_id`) AS `events_attended`
  FROM `tickets` t
    JOIN `events` e ON t.`event` = e.`event_id`
  WHERE t.`is_used` = true
  GROUP BY t.`client`, YEAR(e.`date_time`)
  HAVING COUNT(t.`ticket_id`) > 3
),
`WithDuplicates` AS (
  SELECT
    caf.*,
    COUNT(*) OVER (
      PARTITION BY `event_year`, `events_attended`
    ) AS `same_count_clients`
  FROM `ClientAttendancesPerYearFiltered` caf
)
SELECT
  caf.`event_year`,
  caf.`events_attended`,
  caf.`client_id`,
  c.`name` AS `client1_name`
FROM `WithDuplicates` caf
JOIN `clients` c ON c.`client_id` = caf.`client_id`
WHERE `same_count_clients` > 1
ORDER BY
  caf.`event_year`,
  caf.`events_attended`,
  `client_id`;
