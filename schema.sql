CREATE TABLE IF NOT EXISTS `combo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `comment` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `symbol` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8_bin NOT NULL,
  `multiplier` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `symbol` (`name`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `trade` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `trade_id` bigint(20) unsigned NOT NULL,
  `execution_date` datetime NOT NULL,
  `symbol_id` int(10) unsigned NOT NULL,
  `exchange_id` int(10) unsigned DEFAULT NULL,
  `type` enum('CALL','PUT','STK') COLLATE utf8_bin NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `strike` int(10) unsigned DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `commission` int(11) NOT NULL,
  `combo_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
