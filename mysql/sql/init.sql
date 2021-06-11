USE `temp_db`;
DROP TABLE IF EXISTS `temp_table`;
CREATE TABLE `temp_table` (
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  `field` VARCHAR(255) NOT NULL,
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO temp_table (id, field) VALUES (1, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (2, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (3, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (4, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (5, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (6, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (7, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (8, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (9, 'dummy field');
INSERT INTO temp_table (id, field) VALUES (10, 'dummy field');