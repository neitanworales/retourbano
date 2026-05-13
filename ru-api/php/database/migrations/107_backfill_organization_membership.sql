-- 107_backfill_organization_membership.sql
-- Phase 2 / Backfill
-- Populate organization_users from legacy assignments and safe defaults.

SET NAMES utf8mb4;

-- 1) Membership from explicit legacy assignments.
INSERT INTO organization_users (
    organization_id,
    user_id,
    membership_role,
    joined_at,
    is_active
)
SELECT
    e.organization_id,
    u.id AS user_id,
    'member' AS membership_role,
    ga.fecha_asignacion AS joined_at,
    1 AS is_active
FROM guerreros_asignaciones ga
INNER JOIN users u ON u.legacy_user_id = ga.id_guerrero
INNER JOIN events e ON e.legacy_event_id = ga.id_campamento
WHERE e.organization_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    joined_at = COALESCE(organization_users.joined_at, VALUES(joined_at)),
    is_active = 1;

-- 2) Ensure every user belongs at least to the default organization.
INSERT INTO organization_users (
    organization_id,
    user_id,
    membership_role,
    joined_at,
    is_active
)
SELECT
    o_default.id AS organization_id,
    u.id AS user_id,
    'member' AS membership_role,
    u.registered_at AS joined_at,
    1 AS is_active
FROM users u
INNER JOIN organizations o_default ON o_default.slug = 'legacy-default-org'
LEFT JOIN organization_users ou ON ou.user_id = u.id
WHERE ou.user_id IS NULL
ON DUPLICATE KEY UPDATE
    is_active = 1;

-- 3) Promote org membership role when user has admin/super role.
UPDATE organization_users ou
INNER JOIN user_roles ur ON ur.user_id = ou.user_id
SET ou.membership_role = 'manager'
WHERE ur.role IN ('admin', 'super')
  AND ou.membership_role = 'member';
