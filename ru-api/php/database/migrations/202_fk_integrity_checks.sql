-- 202_fk_integrity_checks.sql
-- Phase 2 / Validation
-- Detect orphan references in the new schema.

SET NAMES utf8mb4;

SELECT 'event_registrations_missing_event' AS check_name,
       COUNT(*) AS orphan_count
FROM event_registrations er
LEFT JOIN events e ON e.id = er.event_id
WHERE e.id IS NULL;

SELECT 'event_registrations_missing_user' AS check_name,
       COUNT(*) AS orphan_count
FROM event_registrations er
LEFT JOIN users u ON u.id = er.user_id
WHERE u.id IS NULL;

SELECT 'payments_missing_registration' AS check_name,
       COUNT(*) AS orphan_count
FROM payments p
LEFT JOIN event_registrations er ON er.id = p.event_registration_id
WHERE er.id IS NULL;

SELECT 'payments_invalid_created_by_user' AS check_name,
       COUNT(*) AS orphan_count
FROM payments p
LEFT JOIN users u ON u.id = p.created_by_user_id
WHERE p.created_by_user_id IS NOT NULL
  AND u.id IS NULL;

SELECT 'auth_tokens_missing_user' AS check_name,
       COUNT(*) AS orphan_count
FROM auth_tokens at
LEFT JOIN users u ON u.id = at.user_id
WHERE u.id IS NULL;

SELECT 'user_roles_missing_user' AS check_name,
       COUNT(*) AS orphan_count
FROM user_roles ur
LEFT JOIN users u ON u.id = ur.user_id
WHERE u.id IS NULL;

SELECT 'events_missing_organization' AS check_name,
       COUNT(*) AS orphan_count
FROM events e
LEFT JOIN organizations o ON o.id = e.organization_id
WHERE e.organization_id IS NOT NULL
  AND o.id IS NULL;

SELECT 'events_missing_city' AS check_name,
       COUNT(*) AS orphan_count
FROM events e
LEFT JOIN cities c ON c.id = e.city_id
WHERE e.city_id IS NOT NULL
  AND c.id IS NULL;

SELECT 'organizations_missing_city' AS check_name,
       COUNT(*) AS orphan_count
FROM organizations o
LEFT JOIN cities c ON c.id = o.city_id
WHERE o.city_id IS NOT NULL
  AND c.id IS NULL;

SELECT 'organization_users_missing_org' AS check_name,
       COUNT(*) AS orphan_count
FROM organization_users ou
LEFT JOIN organizations o ON o.id = ou.organization_id
WHERE o.id IS NULL;

SELECT 'organization_users_missing_user' AS check_name,
       COUNT(*) AS orphan_count
FROM organization_users ou
LEFT JOIN users u ON u.id = ou.user_id
WHERE u.id IS NULL;

SELECT 'organization_events_missing_org' AS check_name,
       COUNT(*) AS orphan_count
FROM organization_events oe
LEFT JOIN organizations o ON o.id = oe.organization_id
WHERE o.id IS NULL;

SELECT 'organization_events_missing_event' AS check_name,
       COUNT(*) AS orphan_count
FROM organization_events oe
LEFT JOIN events e ON e.id = oe.event_id
WHERE e.id IS NULL;
