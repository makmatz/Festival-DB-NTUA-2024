DROP DATABASE IF EXISTS ntua;
CREATE DATABASE ntua;
USE ntua;

-- #region tables
/*------------------*/
/*----- TABLES -----*/
/*------------------*/

CREATE TABLE `locations` (
  `location_id` INT AUTO_INCREMENT PRIMARY KEY,
  `address` VARCHAR(100) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `country` VARCHAR(50) NOT NULL,
  `continent` VARCHAR(20) NOT NULL,
  `coords_long` FLOAT NOT NULL,
  `coords_lat` FLOAT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `festivals` (
  `festival_id` INT AUTO_INCREMENT PRIMARY KEY,
  `first_day` DATE NOT NULL,
  `last_day` DATE NOT NULL,
  `poster` VARCHAR(70),
  `poster_desc` VARCHAR(200),
  `location` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_fk_location` (`location`),
  CONSTRAINT `fk_festival_location`
    FOREIGN KEY (`location`)
    REFERENCES `locations` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `venues` (
  `venue_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(250),
  `capacity` INT NOT NULL,
  `equipment` VARCHAR(250) NOT NULL,
  `picture` VARCHAR(70),
  `picture_desc` VARCHAR(200),
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `events` (
  `event_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50),
  `date_time` DATETIME NOT NULL,
  `duration` TIME NOT NULL,
  `poster` VARCHAR(70),
  `poster_desc` VARCHAR(200),
  `venue` INT NOT NULL,
  `festival` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_fk_venue` (`venue`),
  KEY `idx_fk_festival` (`festival`),
  KEY `idx_events_id_date` (`event_id`, `date_time`),
  CONSTRAINT `fk_event_venue`
    FOREIGN KEY (`venue`)
    REFERENCES `venues` (`venue_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_festival`
    FOREIGN KEY (`festival`)
    REFERENCES `festivals` (`festival_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `performers` (
  `performer_id` INT AUTO_INCREMENT PRIMARY KEY,
  `is_group` BOOLEAN NOT NULL,
  `name` VARCHAR(40) NOT NULL,
  `stage_name` VARCHAR(40),
  `birth_date` DATE,
  `website` varchar(40),
  `instagram` varchar(70),
  `picture` VARCHAR(70),
  `picture_desc` VARCHAR(200),
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_performer_name` (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `genres` (
  `genre_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  UNIQUE KEY `idx_genre_name` (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `subgenres` (
  `subgenre_id` INT AUTO_INCREMENT PRIMARY KEY,
  `genre_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  UNIQUE KEY `idx_fk_genre` (`genre_id`, `name`),
  CONSTRAINT `fk_subgen_gen`
    FOREIGN KEY (`genre_id`) 
    REFERENCES `genres`(`genre_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `performer_subgenres` (
  `performer_id` INT,
  `subgenre_id` INT,
  PRIMARY KEY (`performer_id`, `subgenre_id`),
  KEY `idx_fk_subgenre` (`subgenre_id`),
  CONSTRAINT `fk_perfsub_per`
    FOREIGN KEY (`performer_id`) 
    REFERENCES `performers`(`performer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_perfsub_subgen`
    FOREIGN KEY (`subgenre_id`) 
    REFERENCES `subgenres`(`subgenre_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `group_artist` (
  `artist` INT NOT NULL,
  `group` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`group`, `artist`),
  KEY `idx_fk_artist` (`artist`),
  CONSTRAINT `fk_ga_artist`
    FOREIGN KEY (`artist`)
    REFERENCES `performers` (`performer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ga_group`
    FOREIGN KEY (`group`)
    REFERENCES `performers` (`performer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `performance_types` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(20) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `performances` (
  `performance_id` INT AUTO_INCREMENT PRIMARY KEY,
  `sequence_num` INT NOT NULL,
  `date_time` DATETIME NOT NULL,
  `duration` TIME NOT NULL,
  `event` INT NOT NULL,
  `performer` INT NOT NULL,
  `type` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_fk_event` (`event`),
  KEY `idx_fk_performer` (`performer`),
  CONSTRAINT `fk_performance_event`
    FOREIGN KEY (`event`)
    REFERENCES `events` (`event_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_performance_performer`
    FOREIGN KEY (`performer`)
    REFERENCES `performers` (`performer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_performances_types`
    FOREIGN KEY (`type`)
    REFERENCES `performance_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `check_performance_duration` CHECK (
    `duration` > '00:00:00'
    AND `duration` <= '03:00:00'
  )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `clients` (
  `client_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `birth_date` DATE NOT NULL,
  `email` VARCHAR(50),
  `phone` VARCHAR(15),
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `staff_roles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `role` VARCHAR(15) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `staff` (
  `staff_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(40) NOT NULL,
  `birth_date` DATE NOT NULL,
  `role` INT NOT NULL,
  `experience` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_staff_role` (`role`),
  CONSTRAINT `fk_staff_role`
    FOREIGN KEY (`role`)
    REFERENCES `staff_roles` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `check_experience_rate` CHECK (
    `experience` >= 0
    AND `experience` <= 5
  )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `staff_venue` (
  `staff_member` INT NOT NULL,
  `venue` INT NOT NULL,
  `festival` INT NOT NULL,
  `experience_sv` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`festival`, `staff_member`),
  KEY `idx_fk_staff` (`staff_member`),
  KEY `idx_fk_venue` (`venue`),
  CONSTRAINT `fk_sv_staff`
    FOREIGN KEY (`staff_member`)
    REFERENCES `staff` (`staff_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sv_venue`
    FOREIGN KEY (`venue`)
    REFERENCES `venues` (`venue_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sv_festival`
    FOREIGN KEY (`festival`)
    REFERENCES `festivals` (`festival_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `check_experience_sv_rate` CHECK (
    `experience_sv` >= 0
    AND `experience_sv` <= 5
  )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `ticket_categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `category` VARCHAR(20) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `payment_methods` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `method` VARCHAR(20) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `tickets` (
  `ticket_id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(13) DEFAULT NULL,
  `category` INT,
  `event` INT NOT NULL,
  `client` INT NOT NULL,
  `payment_method` INT NOT NULL,
  `is_used` BOOLEAN DEFAULT FALSE,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_event_category_payment` (`event`, `category`, `payment_method`),
  KEY `idx_fk_client` (`client`, `is_used`, `event`),
  UNIQUE (`client`, `event`),
  CONSTRAINT `fk_ticket_event`
    FOREIGN KEY (`event`)
    REFERENCES `events` (`event_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_category`
    FOREIGN KEY (`category`)
    REFERENCES `ticket_categories` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_client`
    FOREIGN KEY (`client`)
    REFERENCES `clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_pmethod`
    FOREIGN KEY (`payment_method`)
    REFERENCES `payment_methods` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `ticket_costs` (
  `event` INT NOT NULL,
  `category` INT NOT NULL,
  `cost` NUMERIC(5, 2) NOT NULL,
  PRIMARY KEY (`event`, `category`),
  CONSTRAINT `fk_costs_event`
    FOREIGN KEY (`event`)
    REFERENCES `events` (`event_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_costs_category`
    FOREIGN KEY (`category`)
    REFERENCES `ticket_categories` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `resale_waitlist` (
  `event` INT NOT NULL,
  `client` INT NOT NULL,
  `category` INT NOT NULL,
  `payment_method` INT NOT NULL,
  `added_at` TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`client`, `event`),
  KEY `idx_event_category_wl` (`event`, `category`),
  KEY `idx_rw_time`(`added_at`),
  CONSTRAINT `fk_waitlist_event` 
    FOREIGN KEY (`event`)
    REFERENCES `events` (`event_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_waitlist_client`
    FOREIGN KEY (`client`)
    REFERENCES `clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_waitlist_category`
    FOREIGN KEY (`category`)
    REFERENCES `ticket_categories` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_waitlist_method`
    FOREIGN KEY (`payment_method`)
    REFERENCES `payment_methods` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `resale_queue` (
  `ticket` INT PRIMARY KEY,
  `listed_at` TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  KEY `idx_rq_time` (`listed_at`),
  CONSTRAINT `fk_resale_ticket`
    FOREIGN KEY (`ticket`)
    REFERENCES `tickets` (`ticket_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `ratings` (
  `artist_performance` INT NOT NULL,
  `sound_lighting` INT NOT NULL,
  `stage_presence` INT NOT NULL,
  `organization` INT NOT NULL,
  `overall` INT NOT NULL,
  `client` INT NOT NULL,
  `performance` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`performance`, `client`),
  CONSTRAINT `fk_rating_client`
    FOREIGN KEY (`client`)
    REFERENCES `clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rating_performance`
    FOREIGN KEY (`performance`)
    REFERENCES `performances` (`performance_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `check_rating_artist_perf` CHECK (
    `artist_performance` >= 1
    AND `artist_performance` <= 5
  ),
  CONSTRAINT `check_rating_sound_lighting` CHECK (
    `sound_lighting` >= 1
    AND `sound_lighting` <= 5
  ),
  CONSTRAINT `check_rating_stage_presence` CHECK (
    `stage_presence` >= 1
    AND `stage_presence` <= 5
  ),
  CONSTRAINT `check_rating_organization` CHECK (
    `organization` >= 1
    AND `organization` <= 5
  ),
  CONSTRAINT `check_rating_overall` CHECK (
    `overall` >= 1
    AND `overall` <= 5
  )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `ticket_transactions` (
  `transaction_id` INT AUTO_INCREMENT PRIMARY KEY,
  `ticket` INT NOT NULL,
  `seller` INT NOT NULL,
  `buyer` INT NOT NULL,
  `last_update` TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_transaction_ticket`
    FOREIGN KEY (`ticket`)
    REFERENCES `tickets` (`ticket_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_transaction_seller`
    FOREIGN KEY (`seller`)
    REFERENCES `clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_transaction_buyer`
    FOREIGN KEY (`buyer`)
    REFERENCES `clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;
-- #endregion

-- #region views
/*-------------------*/
/*------ VIEWS ------*/
/*-------------------*/

/**
  * Holds information about the genre of each performer.
  */
CREATE VIEW `performers_genres` AS
SELECT
  perf.`performer_id`,
  perf.`name` AS `performer_name`,
  gen.`name` AS `genre_name`
FROM `performers` perf
JOIN `performer_subgenres` perf_sub
  ON perf.`performer_id` = perf_sub.`performer_id`
JOIN `subgenres` sub 
  ON sub.`subgenre_id` = perf_sub.`subgenre_id`
JOIN `genres` gen
  ON gen.`genre_id` = sub.`genre_id`;
-- #endregion

-- #region functions
/*-------------------*/
/*---- FUNCTIONS ----*/
/*-------------------*/

DELIMITER ||

/**
  * Function to check if two time frames (a and b) overlap.
  */
CREATE FUNCTION `check_time_overlap`(
  `a_start` DATETIME,
  `a_durat` TIME,
  `b_start` DATETIME,
  `b_durat` TIME
)
RETURNS TINYINT(1)
BEGIN
  RETURN NOT (
    `a_start` >= ADDTIME(`b_start`, `b_durat`)
    OR ADDTIME(`a_start`, `a_durat`) <= `b_start`
  );
END ||

/**
  * Generates an EAN-13 code from a given integer.
  * Code from: https://gist.github.com/Den2016/2b1f6e1badc97bbc58e8e424766fe437
  */
CREATE FUNCTION `gen_ean13`(`code` INT)
RETURNS VARCHAR(13)
LANGUAGE SQL NOT DETERMINISTIC
NO SQL SQL SECURITY INVOKER
BEGIN
	DECLARE response VARCHAR(13);
	DECLARE prefix CHAR(2);
	DECLARE indx INT;
	DECLARE SumODD INT;
	DECLARE SumEven INT;
	DECLARE Summ INT;

	SET prefix = '24'; -- first two digits in generated barcode

	SET response = CAST(code AS CHAR);

	WHILE LENGTH(response) < 12 - LENGTH(prefix) DO
		SET response = CONCAT('0', response);
	END WHILE;

	SET response = CONCAT(prefix, response);

	SET indx = LENGTH(response);
	SET SumODD = 0;
	SET SumEven = 0;

	WHILE indx > 0 DO
		SET SumODD = SumODD + CAST(SUBSTRING(response, indx, 1) AS UNSIGNED);
		SET indx = indx - 1;
		SET SumEven = SumEven + CAST(SUBSTRING(response, indx, 1) AS UNSIGNED);
		SET indx = indx - 1;
	END WHILE;

	SET Summ = SumODD * 3 + SumEven;

	SET indx = CASE Summ % 10
		WHEN 0 THEN 0
		ELSE 10 - (Summ % 10)
	END;

	SET response = CONCAT(response, CAST(indx AS CHAR));

	RETURN response;
END ||
-- #endregion

-- #region precedures
/*--------------------*/
/*---- PROCEDURES ----*/
/*--------------------*/

/**
 * Creates a sale of a ticket based on the given info.
 */
CREATE PROCEDURE `purchase_ticket` (
  IN `client_id` INT,
  IN `event_id` INT,
  IN `category` INT,
  IN `payment_method` INT
)
BEGIN
  DECLARE `allowed` INT DEFAULT 0;
  DECLARE `sold` INT DEFAULT 0;
  DECLARE `num_tickets` INT;
  DECLARE `event_capacity` INT;
  DECLARE `generated_code` VARCHAR(13);
  DECLARE `has_ticket` INT DEFAULT 0;

  -- Step 1: Check if client already has a ticket for this event
  SELECT COUNT(*) INTO `has_ticket`
  FROM `tickets`
  WHERE `client` = `client_id` AND event = `event_id`;

  IF `has_ticket` > 0 THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'Client already owns a ticket for this event.';
  END IF;

  -- Step 2: Get event capacity
  SELECT ven.`capacity` INTO `event_capacity`
  FROM `events` evn
  JOIN `venues` ven ON evn.`venue` = ven.`venue_id`
  WHERE evn.`event_id` = `event_id`;

  -- Step 3: Determine category share
  SET `allowed` = CASE
    WHEN `category` = 1 THEN `event_capacity` - CEIL(`event_capacity` * 0.1) - CEIL(`event_capacity` * 0.05)
    WHEN `category` = 2 THEN CEIL(`event_capacity` * 0.1)
    WHEN `category` = 3 THEN CEIL(`event_capacity` * 0.05)
    ELSE 0.00
  END;

  -- Step 4: Count how many tickets already sold for this event + category
  SELECT COUNT(*) INTO `sold`
  FROM `tickets` tk
  WHERE tk.`event` = `event_id` AND tk.`category` = `category`;

  -- Step 5: Check if sold out
  IF `sold` >= `allowed` THEN
    SIGNAL SQLSTATE '45002'
      SET MESSAGE_TEXT = 'Tickets sold out for this category.';
  END IF;

  -- Step 6: Insert ticket
  START TRANSACTION;

  INSERT INTO `tickets` (
    `category`, `event`, `client`, `payment_method`
  )
  VALUES (
    `category`, 
    `event_id`,
    `client_id`,
    `payment_method`
  );

  -- Get the last inserted ticket's ID
  SET @last_ticket_id = LAST_INSERT_ID();

  UPDATE `tickets`
  SET `code` = gen_ean13(@last_ticket_id)
  WHERE `ticket_id` = @last_ticket_id;

  COMMIT;
END ||


/**
  * Adds a ticket to the resale queue.
  */
CREATE PROCEDURE `list_for_resale` (IN `p_ticket_id` INT)
BEGIN
  DECLARE `v_event_id` INT;
  DECLARE `v_category` INT;
  DECLARE `v_is_used` BOOLEAN;
  DECLARE `v_sold` INT DEFAULT 0;
  DECLARE `v_event_capacity` INT;
  DECLARE `v_buyer` INT DEFAULT NULL;
  DECLARE `v_seller` INT;

  -- Get ticket details
  SELECT t.`event`, t.`category`, t.`is_used`, t.`client` 
  INTO `v_event_id`, `v_category`, `v_is_used`, `v_seller`
  FROM `tickets` t
  WHERE t.`ticket_id` = `p_ticket_id`;

  -- Check if the ticket was found
  IF `v_event_id` IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Ticket does not exist.';
  END IF;

  -- Check if ticket has already been used
  IF `v_is_used` = TRUE THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'Used ticket cannot be resold.';
  END IF;

  -- Get event capacity
  SELECT ven.`capacity` 
  INTO `v_event_capacity`
  FROM `events` evn
  JOIN `venues` ven ON evn.`venue` = ven.`venue_id`
  WHERE evn.`event_id` = `v_event_id`;

  -- Count sold tickets in that category
  SELECT COUNT(*) 
  INTO `v_sold`
  FROM `tickets` tk
  WHERE tk.`event` = `v_event_id`;

  -- Check if tickets are sold out
  IF `v_sold` < `v_event_capacity` THEN
    SIGNAL SQLSTATE '45002'
      SET MESSAGE_TEXT = 'Tickets are not sold out for this event.';
  END IF;

  START TRANSACTION;

  -- Get first buyer from waitlist
  SELECT rw.`client` 
  INTO `v_buyer`
  FROM `resale_waitlist` rw
  WHERE rw.`category` = `v_category` AND rw.`event` = `v_event_id`
  ORDER BY rw.`added_at` ASC
  LIMIT 1
  FOR UPDATE;

  -- If a buyer is found, perform transaction
  IF `v_buyer` IS NOT NULL THEN
    INSERT INTO `ticket_transactions` (`ticket`, `buyer`, `seller`)
    VALUES (`p_ticket_id`, `v_buyer`, `v_seller`);

    UPDATE `tickets` t
    SET t.`client` = `v_buyer`
    WHERE t.`ticket_id` = `p_ticket_id`;

    DELETE FROM `resale_waitlist`
    WHERE `client` = `v_buyer` AND `category` = `v_category` AND event = `v_event_id`;

    COMMIT;
  ELSE
    ROLLBACK;
    -- If no buyer, add ticket to resale queue
    INSERT INTO `resale_queue` (`ticket`)
    VALUES (`p_ticket_id`);
  END IF;
END ||


/**
  * Adds a customer to the waiting list for a ticket resale for a specific
  * event and ticket category.
  */
CREATE PROCEDURE `purchase_from_resale`(
  IN `p_client_id` INT,
  IN `p_event_id` INT,
  IN `p_category_id` INT,
  IN `p_payment_method_id` INT
)
BEGIN
  DECLARE `v_ticket_id` INT DEFAULT NULL;
  DECLARE `v_seller_id` INT;
  DECLARE `has_ticket` INT DEFAULT 0;
  DECLARE `v_event_capacity` INT;
  DECLARE `v_sold` INT DEFAULT 0;

  -- Check if client already has a ticket for this event
  SELECT COUNT(*) INTO `has_ticket`
  FROM `tickets`
  WHERE `client` = `p_client_id` AND `event` = `p_event_id`;

  IF `has_ticket` > 0 THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'Client already owns a ticket for this event.';
  END IF;

  -- Get event capacity
  SELECT ven.`capacity` 
  INTO `v_event_capacity`
  FROM `events` evn
  JOIN `venues` ven ON evn.`venue` = ven.`venue_id`
  WHERE evn.`event_id` = `p_event_id`;

  -- Count sold tickets in that category
  SELECT COUNT(*) 
  INTO `v_sold`
  FROM `tickets` tk
  WHERE tk.`event` = `p_event_id`;

  -- Check if tickets are sold out
  IF `v_sold` < `v_event_capacity` THEN
    SIGNAL SQLSTATE '45002'
      SET MESSAGE_TEXT = 'Tickets are not sold out for this event.';
  END IF;

  START TRANSACTION;

  -- Try to get a ticket from resale queue
  SELECT rq.`ticket`, t.`client` 
  INTO `v_ticket_id`, `v_seller_id`
  
  FROM `resale_queue` rq
  JOIN `tickets` t
  ON t.`ticket_id` = rq.`ticket`
  
  WHERE t.`event` = `p_event_id` AND t.`category` = `p_category_id`
  ORDER BY rq.`listed_at` ASC
  LIMIT 1
  FOR UPDATE;

  -- If ticket found, process transaction
  IF `v_ticket_id` IS NOT NULL THEN
    -- Get the current owner of the ticket
    INSERT INTO `ticket_transactions` (`ticket`, `buyer`, `seller`) VALUES
    (`v_ticket_id`, `p_client_id`, `v_seller_id`);

    -- Update ticket ownership
    UPDATE `tickets` t
    SET t.`client` = `p_client_id`, t.`payment_method` = `p_payment_method_id`
    WHERE t.`ticket_id` = `v_ticket_id`;

    -- Remove ticket from resale queue
    DELETE FROM `resale_queue`
    WHERE `ticket` = `v_ticket_id`;

    COMMIT;
  ELSE
    ROLLBACK; -- Rollback the transaction as no ticket was processed
    -- If no ticket found, insert client into resale waitlist
    INSERT INTO `resale_waitlist` (`event`, `client`, `category`, `payment_method`)
    VALUES (`p_event_id`, `p_client_id`, `p_category_id`, `p_payment_method_id`);
  END IF;
END ||
-- #endregion

-- #region triggers
/*------------------*/
/*---- TRIGGERS ----*/
/*------------------*/

/**
  * Checks if a new added festival is on the same location as last year.
  */
CREATE TRIGGER `different_location_each_year`
BEFORE INSERT ON `festivals`
FOR EACH ROW 
BEGIN
  DECLARE `prev_location` INT;

  SELECT `location` INTO `prev_location`
  FROM `festivals`
  ORDER BY `festival_id` DESC
  LIMIT 1;

  IF `prev_location` = new.`location` THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'location should be different each year';
  END IF;
END ||


/**
  * Checks if a new added performance is within the event's time period
  * and if the break durations are correct.
  */
CREATE TRIGGER `check_performance_time`
BEFORE INSERT ON `performances`
FOR EACH ROW
BEGIN
  DECLARE `event_start` DATETIME;
  DECLARE `event_end` DATETIME;
  DECLARE `performance_start` DATETIME;
  DECLARE `performance_end` DATETIME;
  DECLARE `break_before` TIME DEFAULT NULL;

  -- Check if performance fits within event time range
  SELECT `date_time`, ADDTIME(`date_time`, `duration`)
  INTO `event_start`, `event_end`
  FROM `events`
  WHERE `event_id` = new.`event`;

  SET `performance_start` = new.`date_time`;
  SET `performance_end` = ADDTIME(new.`date_time`, new.`duration`);

  IF `performance_start` < `event_start` OR `performance_end` > `event_end` THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Performance time is outside the bounds of the event';
  END IF;

  -- Check constraints for the break before the performance 
  SELECT TIMEDIFF(new.`date_time`, p.`date_time` + p.`duration`) INTO `break_before`
  FROM `performances` p
  WHERE p.`event` = new.`event` 
  AND p.`sequence_num` = new.`sequence_num` - 1;
  
  IF new.`sequence_num` > 1 THEN
    IF `break_before` IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'previous performance of this event is missing';
    ELSEIF `break_before` < '00:05:00' OR `break_before` > '00:30:00' THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'break duration should be between 5 and 30 mins';
    END IF;
  END IF;
END ||

/**
  * Checks if the date of the added event is within the dates of the festival 
  */
CREATE TRIGGER `check_event_date_within_festival`
BEFORE INSERT ON `events`
FOR EACH ROW
BEGIN
  DECLARE `fest_start` DATE;
  DECLARE `fest_end` DATE;

  SELECT `first_day`, `last_day`
  INTO `fest_start`, `fest_end`
  FROM `festivals` 
  WHERE `festival_id` = new.`festival`;

  -- Check if the event date is within the festival's range
  IF DATE(new.`date_time`) < fest_start OR DATE(new.`date_time`) > fest_end THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Event date must be within the corresponding festival dates';
  END IF;
END ||

/**
  * Checks if a newly added event in the "events" table overlaps with
  * an existing event in the same venue.
  */
CREATE TRIGGER `deny_overlapping_events` 
BEFORE INSERT ON `events` 
FOR EACH ROW BEGIN
  IF EXISTS (
    SELECT 1
    FROM `events` AS evn
    WHERE
      evn.`venue` = new.`venue`
      AND check_time_overlap(
        new.`date_time`,
        new.`duration`,
        evn.`date_time`,
        evn.`duration`
      )
    LIMIT 1
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET
      MESSAGE_TEXT = 'The new event overlaps with an existing one.';
  END IF;
END ||

/**
  * Checks if newly added performances contain performers that appear
  * in other performances at the same time.
  */
CREATE TRIGGER `check_artist_availability` 
BEFORE INSERT ON `performances` 
FOR EACH ROW BEGIN
  IF EXISTS (
    SELECT 1
    FROM `performances` AS per
    WHERE
      per.`performer` IN (
        SELECT new.`performer` AS `performer`
        UNION
        (
          SELECT `group_artist`.`artist` AS `performer`
          FROM `group_artist`
          WHERE `group_artist`.`group` = new.`performer`
        )
        UNION
        (
          SELECT `group_artist`.`group` AS `performer`
          FROM `group_artist`
          WHERE
            `group_artist`.`artist` IN (
              SELECT `group_artist`.`artist` AS `performer`
              FROM `group_artist`
              WHERE `group_artist`.`group` = new.`performer`
            )
            OR `group_artist`.`artist` = new.`performer`
        )
      )
      AND check_time_overlap(
        new.`date_time`,
        new.`duration`,
        per.`date_time`,
        per.`duration`
      )
    LIMIT 1
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET
      MESSAGE_TEXT = 'Performer is not available at the selected time.';
  END IF;
END ||

/**
  * Checks if the added entries in the "group_artist" table are valid.
  * => "artist" must be an artist and "group" must be a group.
  */
CREATE TRIGGER `check_group_artist_integrity`
BEFORE INSERT ON `group_artist`
FOR EACH ROW BEGIN
  DECLARE `group_type` BOOLEAN;
  DECLARE `artist_type` BOOLEAN;

  SELECT `is_group` INTO `group_type`
  FROM `performers`
  WHERE `performer_id` = new.`group`;

  SELECT `is_group` INTO `artist_type`
  FROM `performers`
  WHERE `performer_id` = new.`artist`;
  
  IF `group_type` = FALSE THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'The performer "group" is not valid group.';
  END IF;

  IF `artist_type` = TRUE THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'The performer "artist" is not valid individual artist.';
  END IF;
END ||

/**
  * Checks if an artist has participated in the previous 3 years
  */
CREATE TRIGGER `check_consecutive_participations`
BEFORE INSERT ON `performances`
FOR EACH ROW BEGIN
  DECLARE y1 BOOLEAN DEFAULT FALSE;
  DECLARE y2 BOOLEAN DEFAULT FALSE;
  DECLARE y3 BOOLEAN DEFAULT FALSE;
  IF EXISTS (
    SELECT 1
    FROM `performances` AS p
    WHERE
      YEAR(p.`date_time`) = YEAR(new.`date_time`) - 1
      AND p.`performer` = new.`performer`
    LIMIT 1
  ) THEN
    SET y1 = TRUE;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM `performances` AS p
    WHERE
      YEAR(p.`date_time`) = YEAR(new.`date_time`) - 2
      AND p.`performer` = new.`performer`
    LIMIT 1
  ) THEN
    SET y2 = TRUE;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM `performances` AS p
    WHERE
      YEAR(p.`date_time`) = YEAR(new.`date_time`) - 3
      AND p.`performer` = new.`performer`
    LIMIT 1
  ) THEN
    SET y3 = TRUE;
  END IF;

  IF y1 AND y2 AND y3 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Performer has participated in the last 3 years.';
  END IF;
END ||
-- #endregion

DELIMITER ;

COMMIT;
