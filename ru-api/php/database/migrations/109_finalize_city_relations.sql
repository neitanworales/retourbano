-- 109_finalize_city_relations.sql
-- Phase 2 / Backfill
-- Align previously created localhost schemas with the normalized cities catalog.

SET NAMES utf8mb4;

SET @organizations_has_city_id := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'organizations'
      AND COLUMN_NAME = 'city_id'
);

SET @sql := IF(
    @organizations_has_city_id = 0,
    'ALTER TABLE organizations ADD COLUMN city_id INT NULL AFTER legacy_city_id',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @organizations_has_city_idx := (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'organizations'
      AND INDEX_NAME = 'idx_organizations_city'
);

SET @sql := IF(
    @organizations_has_city_idx = 0,
    'ALTER TABLE organizations ADD KEY idx_organizations_city (city_id)',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE organizations o
INNER JOIN cities c ON c.legacy_city_id = o.legacy_city_id
SET o.city_id = c.id
WHERE o.legacy_city_id IS NOT NULL
  AND (o.city_id IS NULL OR o.city_id <> c.id);

SET @events_has_city_fk := (
    SELECT COUNT(*)
    FROM information_schema.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE()
      AND CONSTRAINT_NAME = 'fk_events_city'
      AND TABLE_NAME = 'events'
);

SET @sql := IF(
    @events_has_city_fk = 0,
    'ALTER TABLE events ADD CONSTRAINT fk_events_city FOREIGN KEY (city_id) REFERENCES cities(id) ON UPDATE CASCADE ON DELETE SET NULL',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @organizations_has_city_fk := (
    SELECT COUNT(*)
    FROM information_schema.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE()
      AND CONSTRAINT_NAME = 'fk_organizations_city'
      AND TABLE_NAME = 'organizations'
);

SET @sql := IF(
    @organizations_has_city_fk = 0,
    'ALTER TABLE organizations ADD CONSTRAINT fk_organizations_city FOREIGN KEY (city_id) REFERENCES cities(id) ON UPDATE CASCADE ON DELETE SET NULL',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;