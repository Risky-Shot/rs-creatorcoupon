
CREATE TABLE IF NOT EXISTS `coupons` (
  `code` varchar(50) NOT NULL,
  `maxUse` int(11) NOT NULL DEFAULT 0 COMMENT '-1 is infinite use | 0 and above is ',
  `currentUse` int(10) unsigned NOT NULL DEFAULT 0,
  `active` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `coupons_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `item` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `coupon_items_code_fk` (`code`),
  KEY `coupon_items_item_fk` (`item`) USING BTREE,
  CONSTRAINT `coupon_items_code_fk` FOREIGN KEY (`code`) REFERENCES `coupons` (`code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_items_item_fk` FOREIGN KEY (`item`) REFERENCES `items` (`item`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `coupons_money` (
  `code` varchar(50) NOT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  `gold` int(11) NOT NULL DEFAULT 0,
  `rol` int(11) NOT NULL DEFAULT 0,
  KEY `coupon_money_code_fk` (`code`),
  CONSTRAINT `coupon_money_code_fk` FOREIGN KEY (`code`) REFERENCES `coupons` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `coupons_users` (
  `identifier` varchar(50) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `coupons_weapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL DEFAULT '',
  `weapon` varchar(50) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `coupon_weapons_code_fk` (`code`),
  CONSTRAINT `coupon_weapons_code_fk` FOREIGN KEY (`code`) REFERENCES `coupons` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

