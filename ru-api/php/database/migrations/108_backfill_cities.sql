-- 108_backfill_cities.sql
-- Phase 2 / Backfill
-- Populate normalized cities catalog and reconcile city links.

SET NAMES utf8mb4;

INSERT INTO cities (id, legacy_city_id, name, slug, is_active)
SELECT
    ci.id AS id,
    ci.id AS legacy_city_id,
    COALESCE(NULLIF(TRIM(ci.nombre), ''), CONCAT('legacy-city-', ci.id)) AS name,
    LOWER(
        REPLACE(
            REPLACE(
                REPLACE(
                    COALESCE(NULLIF(TRIM(ci.nombre), ''), CONCAT('legacy-city-', ci.id)),
                    ' ', '-'
                ),
                '.', ''
            ),
            '--', '-'
        )
    ) AS slug,
    1 AS is_active
FROM ciudades ci
ON DUPLICATE KEY UPDATE
    legacy_city_id = VALUES(legacy_city_id),
    name = VALUES(name),
    slug = VALUES(slug),
    is_active = VALUES(is_active);

UPDATE events e
INNER JOIN cities c ON c.legacy_city_id = e.city_id
SET e.city_id = c.id
WHERE e.city_id IS NOT NULL;