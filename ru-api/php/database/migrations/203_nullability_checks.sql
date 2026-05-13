-- 203_nullability_checks.sql
-- Phase 2 / Validation
-- Data quality checks after backfill.

SET NAMES utf8mb4;

SELECT 'users_missing_full_name' AS check_name,
       COUNT(*) AS issue_count
FROM users
WHERE full_name IS NULL OR TRIM(full_name) = '';

SELECT 'users_duplicate_legacy_user_id' AS check_name,
       COUNT(*) AS issue_count
FROM (
    SELECT legacy_user_id
    FROM users
    WHERE legacy_user_id IS NOT NULL
    GROUP BY legacy_user_id
    HAVING COUNT(*) > 1
) t;

SELECT 'events_missing_title' AS check_name,
       COUNT(*) AS issue_count
FROM events
WHERE title IS NULL OR TRIM(title) = '';

SELECT 'cities_missing_name' AS check_name,
       COUNT(*) AS issue_count
FROM cities
WHERE name IS NULL OR TRIM(name) = '';

SELECT 'cities_duplicate_legacy_city_id' AS check_name,
       COUNT(*) AS issue_count
FROM (
    SELECT legacy_city_id
    FROM cities
    WHERE legacy_city_id IS NOT NULL
    GROUP BY legacy_city_id
    HAVING COUNT(*) > 1
) t;

SELECT 'events_duplicate_legacy_event_id' AS check_name,
       COUNT(*) AS issue_count
FROM (
    SELECT legacy_event_id
    FROM events
    WHERE legacy_event_id IS NOT NULL
    GROUP BY legacy_event_id
    HAVING COUNT(*) > 1
) t;

SELECT 'registrations_duplicate_legacy_registration_id' AS check_name,
       COUNT(*) AS issue_count
FROM (
    SELECT legacy_registration_id
    FROM event_registrations
    WHERE legacy_registration_id IS NOT NULL
    GROUP BY legacy_registration_id
    HAVING COUNT(*) > 1
) t;

SELECT 'registrations_missing_status' AS check_name,
       COUNT(*) AS issue_count
FROM event_registrations
WHERE registration_status IS NULL OR TRIM(registration_status) = '';

SELECT 'payments_negative_amount' AS check_name,
       COUNT(*) AS issue_count
FROM payments
WHERE amount < 0;

SELECT 'payments_invalid_currency' AS check_name,
       COUNT(*) AS issue_count
FROM payments
WHERE currency IS NULL
   OR CHAR_LENGTH(TRIM(currency)) <> 3;

SELECT 'organization_users_missing_membership_role' AS check_name,
       COUNT(*) AS issue_count
FROM organization_users
WHERE membership_role IS NULL OR TRIM(membership_role) = '';
