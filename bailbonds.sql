CREATE TABLE `user_bailbonds` (
	`name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`price` INT(11) NULL DEFAULT NULL,
	`paid` TINYINT(1) NOT NULL DEFAULT '0'
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;