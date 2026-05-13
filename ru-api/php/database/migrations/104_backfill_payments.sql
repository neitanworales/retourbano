-- 104_backfill_payments.sql
-- Phase 2 / Backfill
-- Populate payments from legacy pagos.

SET NAMES utf8mb4;

INSERT INTO payments (
    legacy_payment_id,
    event_registration_id,
    amount,
    description,
    currency,
    receipt_number,
    paid_at
)
SELECT
    p.id_pago AS legacy_payment_id,
    er.id AS event_registration_id,
    IFNULL(p.cantidad, 0.00) AS amount,
    NULLIF(TRIM(p.descripcion), '') AS description,
    COALESCE(NULLIF(TRIM(p.divisa), ''), 'MXN') AS currency,
    NULLIF(TRIM(p.no_ticket), '') AS receipt_number,
    NULL AS paid_at
FROM pagos p
INNER JOIN event_registrations er ON er.legacy_registration_id = p.id_campamento_guerrero
ON DUPLICATE KEY UPDATE
    event_registration_id = VALUES(event_registration_id),
    amount = VALUES(amount),
    description = VALUES(description),
    currency = VALUES(currency),
    receipt_number = VALUES(receipt_number),
    paid_at = VALUES(paid_at);
