-- 106_seed_default_organizations.sql
-- Phase 2 / Backfill
-- Seed organizations and attach events to owner organizations.

SET NAMES utf8mb4;

-- Ensure default org exists.
INSERT INTO organizations (name, slug, legal_name, is_active)
SELECT 'Legacy Default Organization', 'legacy-default-org', 'Legacy Default Organization', 1
WHERE NOT EXISTS (
    SELECT 1 FROM organizations WHERE slug = 'legacy-default-org'
);

-- Create organizations from legacy cities.
INSERT INTO organizations (legacy_city_id, city_id, name, slug, legal_name, is_active)
SELECT
    ci.id AS legacy_city_id,
    ci.id AS city_id,
    CONCAT('Organization ', ci.nombre) AS name,
    CONCAT('org-city-', ci.id) AS slug,
    CONCAT('Organization ', ci.nombre) AS legal_name,
    1 AS is_active
FROM ciudades ci
WHERE NOT EXISTS (
    SELECT 1 FROM organizations o WHERE o.legacy_city_id = ci.id
);

-- Attach organization to events by city, only if not yet assigned.
UPDATE events e
LEFT JOIN organizations o_city ON o_city.city_id = e.city_id
LEFT JOIN organizations o_default ON o_default.slug = 'legacy-default-org'
SET e.organization_id = COALESCE(o_city.id, o_default.id)
WHERE e.organization_id IS NULL;

-- Register event ownership.
INSERT INTO organization_events (organization_id, event_id, ownership_type, assigned_at, is_active)
SELECT
    e.organization_id,
    e.id,
    'owner' AS ownership_type,
    NOW() AS assigned_at,
    1 AS is_active
FROM events e
WHERE e.organization_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM organization_events oe
      WHERE oe.organization_id = e.organization_id
        AND oe.event_id = e.id
  );
