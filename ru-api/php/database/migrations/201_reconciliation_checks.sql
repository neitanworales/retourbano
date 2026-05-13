-- 201_reconciliation_checks.sql
-- Phase 2 / Validation
-- Compare legacy vs new migrated row counts.

SET NAMES utf8mb4;

SELECT 'users' AS entity,
       (SELECT COUNT(*) FROM guerreros) AS legacy_count,
       (SELECT COUNT(*) FROM users WHERE legacy_user_id IS NOT NULL) AS new_count,
       ((SELECT COUNT(*) FROM guerreros) - (SELECT COUNT(*) FROM users WHERE legacy_user_id IS NOT NULL)) AS diff;

SELECT 'events' AS entity,
       (SELECT COUNT(*) FROM campamentos) AS legacy_count,
       (SELECT COUNT(*) FROM events WHERE legacy_event_id IS NOT NULL) AS new_count,
       ((SELECT COUNT(*) FROM campamentos) - (SELECT COUNT(*) FROM events WHERE legacy_event_id IS NOT NULL)) AS diff;

SELECT 'cities' AS entity,
       (SELECT COUNT(*) FROM ciudades) AS legacy_count,
       (SELECT COUNT(*) FROM cities WHERE legacy_city_id IS NOT NULL) AS new_count,
       ((SELECT COUNT(*) FROM ciudades) - (SELECT COUNT(*) FROM cities WHERE legacy_city_id IS NOT NULL)) AS diff;

SELECT 'event_registrations' AS entity,
       (SELECT COUNT(*) FROM campamento_guerreros) AS legacy_count,
       (SELECT COUNT(*) FROM event_registrations WHERE legacy_registration_id IS NOT NULL) AS new_count,
       ((SELECT COUNT(*) FROM campamento_guerreros) - (SELECT COUNT(*) FROM event_registrations WHERE legacy_registration_id IS NOT NULL)) AS diff;

SELECT 'payments' AS entity,
       (SELECT COUNT(*) FROM pagos) AS legacy_count,
       (SELECT COUNT(*) FROM payments WHERE legacy_payment_id IS NOT NULL) AS new_count,
       ((SELECT COUNT(*) FROM pagos) - (SELECT COUNT(*) FROM payments WHERE legacy_payment_id IS NOT NULL)) AS diff;

SELECT 'payments_migrable' AS entity,
       (
         SELECT COUNT(*)
         FROM pagos p
         INNER JOIN campamento_guerreros cg ON cg.id = p.id_campamento_guerrero
         INNER JOIN guerreros g ON g.id = cg.id_guerrero
       ) AS legacy_count,
       (SELECT COUNT(*) FROM payments WHERE legacy_payment_id IS NOT NULL) AS new_count,
       (
         (
           SELECT COUNT(*)
           FROM pagos p
           INNER JOIN campamento_guerreros cg ON cg.id = p.id_campamento_guerrero
           INNER JOIN guerreros g ON g.id = cg.id_guerrero
         ) -
         (SELECT COUNT(*) FROM payments WHERE legacy_payment_id IS NOT NULL)
       ) AS diff;

SELECT 'roles' AS entity,
       (SELECT COUNT(*) FROM guerreros_roles) AS legacy_count,
       (
         SELECT COUNT(*)
         FROM user_roles ur
         INNER JOIN users u ON u.id = ur.user_id
         WHERE u.legacy_user_id IS NOT NULL
       ) AS new_count,
       (
         (SELECT COUNT(*) FROM guerreros_roles) -
         (
           SELECT COUNT(*)
           FROM user_roles ur
           INNER JOIN users u ON u.id = ur.user_id
           WHERE u.legacy_user_id IS NOT NULL
         )
       ) AS diff;

SELECT 'roles_distinct_migrable' AS entity,
       (
         SELECT COUNT(*)
         FROM (
           SELECT DISTINCT gr.guerrero_id, LOWER(TRIM(gr.rol)) AS rol
           FROM guerreros_roles gr
           INNER JOIN guerreros g ON g.id = gr.guerrero_id
           WHERE gr.rol IS NOT NULL AND TRIM(gr.rol) <> ''
         ) x
       ) AS legacy_count,
       (
         SELECT COUNT(*)
         FROM user_roles ur
         INNER JOIN users u ON u.id = ur.user_id
         WHERE u.legacy_user_id IS NOT NULL
       ) AS new_count,
       (
         (
           SELECT COUNT(*)
           FROM (
             SELECT DISTINCT gr.guerrero_id, LOWER(TRIM(gr.rol)) AS rol
             FROM guerreros_roles gr
             INNER JOIN guerreros g ON g.id = gr.guerrero_id
             WHERE gr.rol IS NOT NULL AND TRIM(gr.rol) <> ''
           ) x
         ) -
         (
           SELECT COUNT(*)
           FROM user_roles ur
           INNER JOIN users u ON u.id = ur.user_id
           WHERE u.legacy_user_id IS NOT NULL
         )
       ) AS diff;

SELECT 'tokens' AS entity,
       (SELECT COUNT(*) FROM token) AS legacy_count,
       (
         SELECT COUNT(*)
         FROM auth_tokens at
         INNER JOIN users u ON u.id = at.user_id
         WHERE u.legacy_user_id IS NOT NULL
       ) AS new_count,
       (
         (SELECT COUNT(*) FROM token) -
         (
           SELECT COUNT(*)
           FROM auth_tokens at
           INNER JOIN users u ON u.id = at.user_id
           WHERE u.legacy_user_id IS NOT NULL
         )
       ) AS diff;

SELECT 'tokens_migrable' AS entity,
       (
         SELECT COUNT(*)
         FROM token t
         INNER JOIN guerreros g ON g.id = t.id_guerrero
         WHERE t.token IS NOT NULL AND TRIM(t.token) <> ''
       ) AS legacy_count,
       (
         SELECT COUNT(*)
         FROM auth_tokens at
         INNER JOIN users u ON u.id = at.user_id
         WHERE u.legacy_user_id IS NOT NULL
       ) AS new_count,
       (
         (
           SELECT COUNT(*)
           FROM token t
           INNER JOIN guerreros g ON g.id = t.id_guerrero
           WHERE t.token IS NOT NULL AND TRIM(t.token) <> ''
         ) -
         (
           SELECT COUNT(*)
           FROM auth_tokens at
           INNER JOIN users u ON u.id = at.user_id
           WHERE u.legacy_user_id IS NOT NULL
         )
       ) AS diff;
