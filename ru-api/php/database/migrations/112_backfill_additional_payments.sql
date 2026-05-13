-- 112_backfill_additional_payments.sql
-- Phase 2 / Backfill
-- Insert payments from pagos_copy1 and pagos_2023 into payments table.

SET NAMES utf8mb4;

-- Insert from pagos_copy1 (legacy duplicate/archive)
INSERT INTO payments (
    legacy_payment_id,
    event_registration_id,
    amount,
    description,
    currency,
    receipt_number,
    created_at
)
SELECT
    pc.id_pago AS legacy_payment_id,
    er.id AS event_registration_id,
    IFNULL(pc.cantidad, 0) AS amount,
    NULLIF(TRIM(pc.descripcion), '') AS description,
    IFNULL(NULLIF(TRIM(pc.divisa), ''), 'MXN') AS currency,
    NULLIF(TRIM(pc.no_ticket), '') AS receipt_number,
    NOW() AS created_at
FROM pagos_copy1 pc
LEFT JOIN event_registrations er ON er.legacy_registration_id = pc.id_campamento_guerrero
WHERE er.id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM payments p
      WHERE p.legacy_payment_id = pc.id_pago
  )
ON DUPLICATE KEY UPDATE
    amount = VALUES(amount),
    description = VALUES(description),
    currency = VALUES(currency),
    receipt_number = VALUES(receipt_number);

-- Insert from pagos2023 (archived 2023 payments)
INSERT INTO payments (
    legacy_payment_id,
    event_registration_id,
    amount,
    description,
    currency,
    receipt_number,
    created_at
)
SELECT
    p23.id_pago AS legacy_payment_id,
    er.id AS event_registration_id,
    IFNULL(p23.cantidad, 0) AS amount,
    NULLIF(TRIM(p23.descripcion), '') AS description,
    IFNULL(NULLIF(TRIM(p23.divisa), ''), 'MXN') AS currency,
    NULLIF(TRIM(p23.no_ticket), '') AS receipt_number,
    NOW() AS created_at
FROM pagos2023 p23
LEFT JOIN event_registrations er ON er.legacy_registration_id = p23.id_campamento_guerrero
WHERE er.id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM payments p
      WHERE p.legacy_payment_id = p23.id_pago
  )
ON DUPLICATE KEY UPDATE
    amount = VALUES(amount),
    description = VALUES(description),
    currency = VALUES(currency),
    receipt_number = VALUES(receipt_number);

-- Report results
SELECT 'pagos_copy1 inserted' AS status,
       COUNT(*) AS row_count
FROM payments
WHERE legacy_payment_id IN (
    SELECT id_pago FROM pagos_copy1
);

SELECT 'pagos2023 inserted' AS status,
       COUNT(*) AS row_count
FROM payments
WHERE legacy_payment_id IN (
    SELECT id_pago FROM pagos2023
);

SELECT 'Total payments in new schema' AS status,
       COUNT(*) AS row_count
FROM payments;
