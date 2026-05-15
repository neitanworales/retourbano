-- 004_create_cities_schema.sql
-- SUPERSEDED: cities is now created in 001_create_core_english_schema.sql
-- because events references it via FK and 003 runs before this file.
-- This file is kept for reference only. The CREATE TABLE below is a no-op
-- due to IF NOT EXISTS.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS cities (
    id INT NOT NULL AUTO_INCREMENT,
    legacy_city_id INT NULL,
    name VARCHAR(120) NOT NULL,
    slug VARCHAR(160) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cities_legacy_city_id (legacy_city_id),
    UNIQUE KEY uq_cities_slug (slug),
    KEY idx_cities_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;