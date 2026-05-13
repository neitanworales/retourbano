-- 204_backfill_gap_details.sql
-- Phase 2 / Validation
-- Detailed list of legacy rows that could not be migrated or were deduplicated.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Payments that did not migrate because they cannot resolve to a migrated registration.
SELECT 'missing_payment_registration_link' AS issue_type,
       p.id_pago AS legacy_id,
       p.id_campamento_guerrero AS legacy_registration_id,
       p.cantidad AS amount,
       p.descripcion AS description,
       p.divisa AS currency,
       p.no_ticket AS receipt_number
FROM pagos p
LEFT JOIN event_registrations er ON er.legacy_registration_id = p.id_campamento_guerrero
WHERE er.id IS NULL
ORDER BY p.id_pago;

-- Tokens whose legacy user does not exist in guerreros/users.
SELECT 'missing_token_user_link' AS issue_type,
       t.id_guerrero AS legacy_user_id,
       t.token,
       t.expires,
       t.created
FROM token t
LEFT JOIN users u ON u.legacy_user_id = t.id_guerrero
WHERE u.id IS NULL
ORDER BY t.id_guerrero;

-- Roles whose legacy user does not exist in guerreros/users.
SELECT 'missing_role_user_link' AS issue_type,
       gr.id AS legacy_role_row_id,
       gr.guerrero_id AS legacy_user_id,
       gr.rol AS legacy_role
FROM guerreros_roles gr
LEFT JOIN users u ON u.legacy_user_id = gr.guerrero_id
WHERE u.id IS NULL
ORDER BY gr.id;

-- Duplicate role assignments in legacy that collapse into one row in user_roles.
SELECT 'duplicate_role_assignment' AS issue_type,
       MIN(gr.id) AS first_legacy_row_id,
       gr.guerrero_id AS legacy_user_id,
       LOWER(TRIM(gr.rol)) AS normalized_role,
       COUNT(*) AS duplicate_count
FROM guerreros_roles gr
INNER JOIN users u ON u.legacy_user_id = gr.guerrero_id
WHERE gr.rol IS NOT NULL AND TRIM(gr.rol) <> ''
GROUP BY gr.guerrero_id, LOWER(TRIM(gr.rol))
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, legacy_user_id;
