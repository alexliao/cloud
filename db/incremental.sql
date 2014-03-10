ALTER TABLE `grapps`.`reports` 
ADD COLUMN `param_name` VARCHAR(45) NULL AFTER `created_at`,
ADD COLUMN `param_default` VARCHAR(500) NULL AFTER `param_name`,
ADD COLUMN `lookups` VARCHAR(500) NULL AFTER `param_default`;
